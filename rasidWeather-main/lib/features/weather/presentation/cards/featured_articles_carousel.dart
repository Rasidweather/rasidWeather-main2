import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constants/index.dart';
import '../../../../core/widgets/image_widget.dart';
import '../../../../data/model/article_model.dart';
import '../../../../features/weather/data/models/weather_model.dart';
import '../../../../features/weather/presentation/cubit/weather_cubit.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/date_utils.dart';
import '../../../../utils/ui_utils.dart';
import '../../../../views/base/tooltip_widget.dart';
import '../../../../views/base/ui_widget.dart';
import '../../../../views/base/weather_container.dart';

/// Constants for the carousel to avoid accessing them through the state class
class _CarouselConstants {

  // Private constructor to prevent instantiation
  const _CarouselConstants._();
  static const double horizontalMargin = 20.0;
  static const double horizontalPadding = 10.0;
  static const double topPadding = 15.0;
  static const double bottomPadding = 10.0;
  static const double titleFontSize = 16.0;
  static const double dateFontSize = 12.0;
  static const double articleTitleFontSize = 14.0;
  static const double dotWidth = 4.0;
  static const double activeDotWidth = 15.0;
  static const double dotHeight = 4.0;
  static const double dotBorderRadius = 10.0;
  static const double dotSpacing = 4.0;
  static const double dotTopPadding = 8.0;
  static const double vipIconSize = 40.0;
  static const double vipIconPadding = 5.0;
  static const double vipIconRadius = 15.0;
  static const double vipIconTopRadius = 8.0;
  static const double carouselAspectRatio = 16 / 4;
  static const double activeOpacity = 0.9;
  static const double inactiveOpacity = 0.4;
  static const Duration autoPlayInterval = Duration(seconds: 4);
  static const Duration autoPlayAnimationDuration = Duration(milliseconds: 600);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Cached padding and decoration values to avoid recreating them
  static const EdgeInsets containerMargin = EdgeInsets.symmetric(horizontal: horizontalMargin);
  static const EdgeInsets containerPadding = EdgeInsets.fromLTRB(
    horizontalPadding,
    topPadding,
    horizontalPadding,
    bottomPadding,
  );
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(horizontal: horizontalPadding);
  static const BorderRadius vipBadgeBorderRadius = BorderRadius.only(
    bottomRight: Radius.circular(vipIconRadius),
    topLeft: Radius.circular(vipIconTopRadius),
  );
}

/// Main carousel widget for featured articles
class FeaturedArticlesCarousel extends StatefulWidget {
  const FeaturedArticlesCarousel({super.key});

  @override
  State<FeaturedArticlesCarousel> createState() => _FeaturedArticlesCarouselState();
}

class _FeaturedArticlesCarouselState extends State<FeaturedArticlesCarousel> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final carousel.CarouselSliderController _controller;
  late final AnimationController _animationController;
  bool _isDisposed = false;
  bool _autoPlayEnabled = true;
  Timer? _autoPlayResumeTimer;
  
  // Cache the ValueKey to avoid recreation
  static const ValueKey<String> _carouselKey = ValueKey<String>('featured-articles-carousel');
  static const SizedBox _emptyWidget = SizedBox.shrink();

  @override
  void initState() {
    super.initState();
    _controller = carousel.CarouselSliderController();
    _animationController = AnimationController(
        vsync: this,
        duration: _CarouselConstants.animationDuration
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _autoPlayResumeTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  // Optimized equality check for weather data
  bool _shouldRebuild(WeatherState previous, WeatherState current) {
    // Fast path: if nothing has changed in the relevant data
    if (previous == current) return false;
    
    // Only rebuild if the featured articles list has changed
    final List<ArticleModel>? previousFeatured = previous.current?.featured;
    final List<ArticleModel>? currentFeatured = current.current?.featured;

    if (previousFeatured == null && currentFeatured == null) {
      return false;
    }

    if (previousFeatured == null || currentFeatured == null) {
      return true;
    }

    if (previousFeatured.length != currentFeatured.length) {
      return true;
    }

    // Use a more efficient comparison by checking IDs only
    for (int i = 0; i < previousFeatured.length; i++) {
      if (previousFeatured[i].id != currentFeatured[i].id) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: _shouldRebuild,
      builder: (BuildContext context, WeatherState state) {
        final List<ArticleModel>? featured = state.current?.featured;
        if (featured == null || featured.isEmpty) {
          return _emptyWidget;
        }
        final bool enableAutoPlay = _autoPlayEnabled && featured.length > 1;
        
        return RepaintBoundary(
          key: _carouselKey,
          child: UiWidget(
            child: (Appearance ui) {
              final Color textColor = convertHexaToColor(ui.textColor!);
              
              return _CarouselContent(
                textColor: textColor,
                articles: featured,
                currentIndex: _currentIndex,
                controller: _controller,
                onPageChanged: _handlePageChanged,
                isVip: AppStrings.isVip,
                autoPlayEnabled: enableAutoPlay,
                onUserInteraction: _pauseAutoPlay,
              );
            },
          ),
        );
      },
    );
  }

  void _handlePageChanged(int index, carousel.CarouselPageChangedReason reason) {
    if (reason == carousel.CarouselPageChangedReason.manual) {
      _pauseAutoPlay();
    }
    if (!_isDisposed) {
      setState(() => _currentIndex = index);
    }
  }

  void _pauseAutoPlay() {
    _autoPlayResumeTimer?.cancel();
    if (_autoPlayEnabled && mounted) {
      setState(() => _autoPlayEnabled = false);
    }
    _autoPlayResumeTimer = Timer(const Duration(seconds: 6), () {
      if (!mounted) return;
      setState(() => _autoPlayEnabled = true);
    });
  }
}

class _CarouselContent extends StatelessWidget {
  const _CarouselContent({
    required this.textColor,
    required this.articles,
    required this.currentIndex,
    required this.controller,
    required this.onPageChanged,
    required this.isVip,
    required this.autoPlayEnabled,
    required this.onUserInteraction,
  });

  final Color textColor;
  final List<ArticleModel> articles;
  final int currentIndex;
  final carousel.CarouselSliderController controller;
  final void Function(int, carousel.CarouselPageChangedReason) onPageChanged;
  final bool isVip;
  final bool autoPlayEnabled;
  final VoidCallback onUserInteraction;
  
  // Cached constants
  static const double _carouselAspectRatio = _CarouselConstants.carouselAspectRatio;
  static const Duration _autoPlayInterval = _CarouselConstants.autoPlayInterval;
  static const Duration _autoPlayAnimationDuration = _CarouselConstants.autoPlayAnimationDuration;
  static const Duration _animationDuration = _CarouselConstants.animationDuration;
  static const FontWeight _fontWeight = FontWeight.w500;
  static const Cubic _curve = Curves.easeInOut;
  
  // Cached text height behavior to prevent layout shifts
  static const TextHeightBehavior _textHeightBehavior = TextHeightBehavior(
    leadingDistribution: TextLeadingDistribution.even
  );

  @override
  Widget build(BuildContext context) {
    // Cache the header text style
    final TextStyle headerStyle = TextStyle(
      color: textColor,
      fontSize: _CarouselConstants.titleFontSize.sp,
      fontWeight: _fontWeight
    );

    // Create the header with stable text rendering
    final Text headerText = Text(
      'common.newest_articles'.tr(), 
      style: headerStyle,
      textHeightBehavior: _textHeightBehavior,
    );

    // Create the carousel and dots indicator
    final Widget carouselWidget = _buildCarousel();
    
    // Create the dots indicator
    final _DotsIndicator dotsIndicator = _DotsIndicator(
      count: articles.length,
      currentIndex: currentIndex,
      textColor: textColor,
      onDotTap: (int index) => controller.animateToPage(
        index,
        duration: _animationDuration,
        curve: _curve
      ),
    );

    // Combine carousel and dots in a column with minimal rebuilds
    final Column carouselContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        carouselWidget,
        dotsIndicator,
      ],
    );

    // Use the container directly without extra RepaintBoundary
    return WeatherContainer(
      margin: _CarouselConstants.containerMargin,
      padding: _CarouselConstants.containerPadding,
      header: headerText,
      content: carouselContent,
    );
  }

  Widget _buildCarousel() {
    // Create carousel options once with cached constants
    final carousel.CarouselOptions carouselOptions = carousel.CarouselOptions(
      autoPlay: autoPlayEnabled,
      autoPlayAnimationDuration: _autoPlayAnimationDuration,
      aspectRatio: _carouselAspectRatio,
      viewportFraction: 1,
      onPageChanged: onPageChanged,
    );

    // Use a key based on content length only, not current index
    // to prevent unnecessary rebuilds
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanDown: (_) => onUserInteraction(),
      onTapDown: (_) => onUserInteraction(),
      child: carousel.CarouselSlider.builder(
        key: ValueKey<String>('carousel-${articles.length}'),
        itemCount: articles.length,
        carouselController: controller,
        itemBuilder: (BuildContext context, int index, _) {
          // Use the article ID as a stable key
          final ArticleModel article = articles[index];
          return _ArticleItem(
            key: ValueKey<String>('article-${article.id}'),
            article: article,
            textColor: textColor,
            isVip: isVip
          );
        },
        options: carouselOptions,
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  const _DotsIndicator({
    required this.count,
    required this.currentIndex,
    required this.textColor,
    required this.onDotTap
  });

  final int count;
  final int currentIndex;
  final Color textColor;
  final ValueChanged<int> onDotTap;
  
  // Static padding to avoid recreation
  static const EdgeInsets _topPadding = EdgeInsets.only(top: _CarouselConstants.dotTopPadding);

  @override
  Widget build(BuildContext context) {
    // Pre-generate the dots list once
    final List<_Dot> dots = List.generate(
      count,
      (int index) {
        final bool isActive = currentIndex == index;
        // Only use ValueKey for the active state to avoid unnecessary rebuilds
        return _Dot(
          key: ValueKey<String>('dot-$index-$isActive'),
          isActive: isActive,
          textColor: textColor,
          onTap: () => onDotTap(index)
        );
      }
    );

    return Padding(
      padding: _topPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: dots,
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    super.key,
    required this.isActive,
    required this.textColor,
    required this.onTap
  });

  final bool isActive;
  final Color textColor;
  final VoidCallback onTap;

  // Static constants to avoid recreating them
  static const BorderRadius _dotBorderRadius = BorderRadius.all(
    Radius.circular(_CarouselConstants.dotBorderRadius)
  );
  static const EdgeInsets _dotPadding = EdgeInsets.symmetric(
    horizontal: _CarouselConstants.dotSpacing
  );

  @override
  Widget build(BuildContext context) {
    // Use pre-calculated values instead of calculating in build
    final double width = isActive
        ? _CarouselConstants.activeDotWidth
        : _CarouselConstants.dotWidth;
    final double opacity = isActive
        ? _CarouselConstants.activeOpacity
        : _CarouselConstants.inactiveOpacity;
        
    // Create the decoration once
    final BoxDecoration decoration = BoxDecoration(
      borderRadius: _dotBorderRadius,
      color: textColor.withAlpha((opacity * 255).round()),
    );

    // Use a Container instead of AnimatedContainer when possible
    // Only use AnimatedContainer for the width property
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: _dotPadding,
        child: AnimatedContainer(
          duration: _CarouselConstants.animationDuration,
          width: width,
          height: _CarouselConstants.dotHeight,
          decoration: decoration,
        ),
      ),
    );
  }
}

class _ArticleItem extends StatelessWidget {
  const _ArticleItem({
    super.key,
    required this.article,
    required this.textColor,
    required this.isVip
  });

  final ArticleModel article;
  final Color textColor;
  final bool isVip;

  // Memoized text styles
  TextStyle _getDateStyle(BuildContext context) => TextStyle(
    fontSize: _CarouselConstants.dateFontSize.sp,
    fontWeight: FontWeight.w300,
    color: textColor,
  );

  TextStyle _getTitleStyle(BuildContext context) => TextStyle(
    fontSize: _CarouselConstants.articleTitleFontSize.sp,
    fontWeight: FontWeight.w500,
    color: textColor,
  );

  @override
  Widget build(BuildContext context) {
    // Pre-compute expensive objects
    final TextStyle dateStyle = _getDateStyle(context);
    final TextStyle titleStyle = _getTitleStyle(context);
    final String createdAtText = dateTimeToTimeAgo(article.createdAt!);

    // Precompute trailing widget
    final Widget? trailingWidget = article.isFeatured && !isVip
        ? _buildVipBadge(context)
        : null;

    // Memoize text widgets
    final RepaintBoundary titleWidget = RepaintBoundary(
      child: Text(createdAtText, style: dateStyle),
    );

    final RepaintBoundary subtitleWidget = RepaintBoundary(
      child: Text(
        article.title!,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: titleStyle,
      ),
    );

    return RepaintBoundary(
      key: ValueKey<String>('article-item-${article.id}'),
      child: ListTile(
        contentPadding: _CarouselConstants.contentPadding,
        trailing: trailingWidget,
        title: titleWidget,
        subtitle: subtitleWidget,
        onTap: () => _handleArticleTap(context),
      ),
    );
  }

  Widget? _buildVipBadge(BuildContext context) {
    if (!article.isFeatured || isVip) {
      return null;
    }

    // Cache computed values
    final Color backgroundColor = Theme.of(context).secondaryHeaderColor;
    final String tooltipMessage = 'common.vip_badge'.tr();
    final double width = _CarouselConstants.vipIconSize.w;
    final double height = _CarouselConstants.vipIconSize.h;

    // Cache the decoration
    final BoxDecoration decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: _CarouselConstants.vipBadgeBorderRadius,
    );

    // Pre-compute the diamond icon
    final RepaintBoundary diamondIcon = RepaintBoundary(
      child: ImageView.svgAsset(
          Assets.assetsDiamond,
          color: Colors.white,
          width: 30
      ),
    );

    return RepaintBoundary(
      key: ValueKey<String>('vip-badge-${article.id}'),
      child: ViewTooltip(
        message: tooltipMessage,
        backgroundColor: backgroundColor,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(_CarouselConstants.vipIconPadding),
          decoration: decoration,
          child: diamondIcon,
        ),
      ),
    );
  }

  void _handleArticleTap(BuildContext context) {
    if (article.isFeatured && !isVip) {
      RouterHelper.getSubscriptionIntroRoute();
    } else {
      RouterHelper.getArticleDetailsRoute(article.id!, article: article);
    }
  }
}
