import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/back_button.dart';
import '../../../../../core/widgets/subscription_button.dart';
import '../../../../../providers/tab_index_bloc.dart';
import '../../../../../utils/date_utils.dart';
import '../../../../cities/presentation/cubit/cities_cubit.dart';
import '../../../data/models/weather_model.dart';
import '../../cubit/weather_cubit.dart';

/// A custom app bar for displaying weather forecast information for multiple days.
///
/// This widget creates a sliver app bar that includes:
/// - A back button
/// - Title showing the number of forecast days
/// - Current city and country name
/// - Current weather condition
/// - Scrollable tabs for each day's forecast
/// - Subscription button
class ForecastDaysAppBar extends StatelessWidget {
  /// Creates a forecast days app bar.
   ForecastDaysAppBar({
    super.key,
    required this.tabController,
    required this.innerBoxIsScrolled,
    required this.onBackPressed,
  });


  /// Controller for the day tabs
  final TabController tabController;

  /// Whether the inner box is currently scrolled
  final bool innerBoxIsScrolled;

  /// Callback function when back button is pressed
  final VoidCallback onBackPressed;

  /// Constants for styling and layout
  static const double _kToolbarHeight = 80.0;
  static const double _kSpacing = 5.0;
  static const double _kTabPadding = 12.0;
  static const double _kTabHeight = 40.0;
  static const double _kBorderRadius = 10.0;
  static const double _kHorizontalPadding = 10.0;

  /// Text styles
  static const double _kTitleFontSize = 12.0;
  static const double _kDayNameFontSize = 14.0;


  // Cache text styles for better performance
  TextStyle _getTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
    );
  }
  
  TextStyle _getSubtitleStyle() {
    return TextStyle(
      fontSize: _kTitleFontSize.sp,
      fontWeight: FontWeight.w600,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // We need to return a SliverAppBar directly without wrapping it in a RepaintBoundary
    // because Sliver widgets must have Sliver parents
    return SliverAppBar(
      centerTitle: true,
      elevation: 1,
      pinned: true,
      toolbarHeight: _kToolbarHeight.h,
      leading: _buildBackButton(context),
      title: _buildTitle(context),
      forceElevated: innerBoxIsScrolled,
      bottom: _buildTabBar(context),
      actions: const <Widget>[
        SubscriptionButton(),
      ],
    );
  }

  /// Builds the back button with navigation logic
  Widget _buildBackButton(BuildContext context) {
    return AdaptiveBackButton(
      onPressed: () async {
        if (!context.mounted) return;
         onBackPressed();
        Navigator.pop(context);
      },
    );
  }

  /// Builds the title section including forecast days count, city name, and weather condition
  Widget _buildTitle(BuildContext context) {
    final WeatherState state = context.read<WeatherCubit>().state;
    // Cache text styles to avoid recreation
    final TextStyle titleStyle = _getTitleStyle(context);
    final TextStyle subtitleStyle = _getSubtitleStyle();
    
    // Pre-compute this value to avoid recalculating during build
    final String daysCount = state.days!.length.toString();
    final String weatherTitle = 'weather.weatherForDays'.tr().replaceFirst('{}', daysCount);
    final String conditionText = state.days!.first.condition!.conditionName!;
    
    // We need to ensure this widget doesn't invalidate the sliver hierarchy
    // The RepaintBoundary is safe here since it's within the Column child of the SliverAppBar's title
    return Column(
        children: <Widget>[
          Text(
            weatherTitle,
            style: titleStyle,
          ),
          const SizedBox(height: _kSpacing),
          _buildCityName(),
          const SizedBox(height: _kSpacing),
          Text(
            conditionText,
            style: subtitleStyle,
          ),
        ],
    );
  }

  /// Builds the city name section with BLoC integration
  Widget _buildCityName() {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (BuildContext context, CitiesState state) {
        if (state is SelectedCitySuccess) {
          return Text(
            '${state.selectedCity!.name}, ${state.selectedCity!.countryName}',
            style: TextStyle(
              fontSize: _kTitleFontSize.sp,
              fontWeight: FontWeight.w600,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Builds the tab bar for day selection
  PreferredSizeWidget _buildTabBar(BuildContext context) {
    final WeatherState state = context.read<WeatherCubit>().state;
    
    // Safety check to ensure state.days is not null
    if (state.days == null || state.days!.isEmpty) {
      return TabBar(
        controller: tabController,
        tabs: const <Widget>[],
      );
    }
    
    // Ensure that we don't create more tabs than the TabController can handle
    final int tabCount = tabController.length;
    final List<Day> daysToShow = state.days!.length > tabCount 
        ? state.days!.sublist(0, tabCount) 
        : state.days!;
    
    // Create the indicator once to avoid rebuilding it
    const BoxDecoration tabIndicator = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(_kBorderRadius)),
      color: Color(0xff2BB0DD),
    );
    
    // Cache padding to avoid recalculation
    final EdgeInsets padding = EdgeInsets.only(
      bottom: _kTabPadding.h,
      left: _kTabPadding,
      right: _kTabPadding,
      top: _kTabPadding,
    );
    
    // Use a key to help Flutter maintain identity
    return TabBar(
      key: const ValueKey<String>('forecast-days-tab-bar'),
      tabAlignment: TabAlignment.start,
      padding: padding,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: (int index) {
        if (index < state.days!.length) {
          context.read<TabIndexBloc>().selectDayTab(
            state.days![index],
            state.hours!,
          );
        }
      },
      physics: const AlwaysScrollableScrollPhysics(),
      labelStyle: _getTabLabelStyle(context, true),
      controller: tabController,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.white,
      unselectedLabelStyle: _getTabLabelStyle(context, false),
      isScrollable: true,
      indicator: tabIndicator,
      // Pre-build tabs to avoid rebuilding during scrolling
      tabs: daysToShow.map((Day day) => _buildDayTab(day)).toList(growable: false),
    );
  }


  // Cache tab label styles to avoid recreating them each time
  final Map<bool, TextStyle?> _tabLabelStyleCache = <bool, TextStyle?>{};
  
  /// Returns the style for tab labels, with caching
  TextStyle? _getTabLabelStyle(BuildContext context, bool isSelected) {
    // Return cached style if available
    if (_tabLabelStyleCache.containsKey(isSelected)) {
      return _tabLabelStyleCache[isSelected];
    }
    
    // Create and cache the style
    final TextStyle style = Theme.of(context).textTheme.displayMedium!.copyWith(
      fontSize: _kTitleFontSize,
      fontWeight: FontWeight.w600,
      color: isSelected ? Colors.white : null,
    );
    
    _tabLabelStyleCache[isSelected] = style;
    return style;
  }

  // Cache for tab text styles
  late final TextStyle _tabTextStyle = TextStyle(
    fontSize: _kDayNameFontSize.sp,
    fontWeight: FontWeight.w600,
  );
  
  /// Builds a single day tab with performance optimizations
  Widget _buildDayTab(Day day) {
    // Pre-compute the date string to avoid doing this inside the build method
    final String weekday = 'date.weekdays_full.${day.forecastStart!.weekday}'.tr();
    final String? date = formatDateTime(day.forecastStart!, format: 'dd MMM');
    final String tabText = '$weekday | $date';
    
    // Use a key to maintain identity
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _kHorizontalPadding,
      ),
      key: ValueKey<String>('day-tab-${day.forecastStart!.millisecondsSinceEpoch}'),
      child: Tab(
        height: _kTabHeight.h,
        icon: Text(
          tabText,
          style: _tabTextStyle,
        ),
      ),
    );
  }
}
