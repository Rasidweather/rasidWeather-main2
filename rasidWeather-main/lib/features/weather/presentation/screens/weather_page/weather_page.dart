import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../../../bloc/ui_cubit/ui_cubit.dart';
import '../../../../../common/widgets/loader_widget.dart';
import '../../../../../data/model/user_model.dart';
import '../../../../../locator.dart';
import '../../../../../helper/router_helper.dart';
import '../../../../../views/base/index.dart';
import '../../../../../views/base/native_ad_widget.dart';
import '../../../../../views/base/real_native_ad_widget.dart';
import '../../../../../views/screens/dashboard.dart';
import '../../../../../whatsapp/whats_app_contact_card.dart';
import '../../../../ads/presentation/services/ads_service.dart';
import '../../../../language/cubit/language_cubit.dart';
import '../../../data/models/weather_model.dart';
import '../../cards/featured_articles_carousel.dart';
import '../../cards/weather_details_grid.dart';
import '../../components/weather_background.dart';
import '../../cubit/weather_cubit.dart';
import '../../widgets/forecast_last_updated.dart';
import 'components/hourly_weather_widget.dart';
import 'components/premium_subscription_card.dart';
import 'components/weather_header.dart';
import 'components/weather_inquiry_card.dart';
import 'components/weather_maps_widget.dart';
import 'components/weekly_forecast_widget.dart';

class WeatherFeature extends StatefulWidget {
  const WeatherFeature({super.key});

  @override
  State<WeatherFeature> createState() => _WeatherFeatureState();
}

class _WeatherFeatureState extends State<WeatherFeature>
    with SingleTickerProviderStateMixin {
  static const Duration _kAnimationDuration = Duration(milliseconds: 250);
  static const Duration _kRefreshEvery = Duration(minutes: 15);
  static const String _maintenanceTitleAr = 'الموقع في حالة صيانة';
  static const String _maintenanceBodyAr =
      'الخدمة غير متاحة حالياً. حاول مرة أخرى لاحقاً.';

  late final AnimationController _fadeAnimController;
  final ScrollController _scrollController = ScrollController();
  Timer? _refreshTimer;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _fadeAnimController = AnimationController(
      vsync: this,
      duration: _kAnimationDuration,
    )..forward();

    _setupRefreshTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAndRefreshData());
  }

  void _setupRefreshTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_kRefreshEvery, (_) {
      if (_isActive) refresh();
    });
  }

  Future<void> _checkAndRefreshData() async {
    // تحميل بيانات المستخدم للتأكد من حالة الاشتراك
    final ProfileCubit profileCubit = context.read<ProfileCubit>();
    if (profileCubit.state is ProfileInitial) {
      await profileCubit.getProfile();
    }

    final WeatherState state = context.read<WeatherCubit>().state;
    if (state.current == null || await _isDataStale()) {
      await refresh();
    }
  }

  Future<bool> _isDataStale() async {
    final DateTime? lastUpdate = await context
        .read<WeatherCubit>()
        .getLastUpdate();
    return lastUpdate == null ||
        DateTime.now().difference(lastUpdate) > _kRefreshEvery;
  }

  @override
  void dispose() {
    _isActive = false;
    _refreshTimer?.cancel();
    _fadeAnimController.dispose();
    _scrollController.dispose();
    sl<AdsService>().cleanupOldAds();
    super.dispose();
  }

  Future<void> refresh() async {
    if (!_isActive) return;
    await DashboardState.loadData(refresh: true);
    // لو بدك: context.read<ProfileCubit>().getProfile();
  }

  String _weatherErrorTitle(BuildContext context) {
    final bool isArabic = context.read<LanguageCubit>().isArabic();
    return isArabic ? _maintenanceTitleAr : 'Service under maintenance';
  }

  String _weatherErrorBody(BuildContext context) {
    final bool isArabic = context.read<LanguageCubit>().isArabic();
    return isArabic
        ? _maintenanceBodyAr
        : 'The service is temporarily unavailable. Please try again later.';
  }

  // -------------------------
  // ✅ Helpers: اقرأ من toJson()
  // -------------------------

  Map<String, dynamic> _safeUserJson(UserModel? user) {
    try {
      if (user == null) return <String, dynamic>{};
      final Map<String, dynamic> j = user.toJson();
      return j;
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  DateTime? _readExpiredAtFromUserJson(Map<String, dynamic> j) {
    final dynamic raw =
        j['expired_at'] ??
        j['expiredAt'] ??
        j['subscription_expired_at'] ??
        j['subscriptionExpiredAt'] ??
        j['subscription_end'] ??
        j['subscriptionEnd'] ??
        j['ends_at'] ??
        j['endsAt'];

    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }

  String? _readProductIdFromUserJson(Map<String, dynamic> j) {
    final dynamic raw =
        j['product_id'] ??
        j['productId'] ??
        j['subscription_product_id'] ??
        j['subscriptionProductId'] ??
        j['plan_product_id'] ??
        j['planProductId'] ??
        j['ios_product_id'] ??
        j['android_product_id'];

    return raw?.toString();
  }

  String? _readProductId(UserModel? user) {
    // ✅ الأفضل: من subscriptions (حسب كودك في ProfilePage)
    final String? fromSubs = (user?.subscriptions?.isNotEmpty ?? false)
        ? user!.subscriptions!.first.productId
        : null;

    if (fromSubs != null && fromSubs.isNotEmpty) return fromSubs;

    // fallback: من toJson إذا موجود
    final Map<String, dynamic> j = _safeUserJson(user);
    final dynamic raw =
        j['product_id'] ??
        j['productId'] ??
        j['subscription_product_id'] ??
        j['subscriptionProductId'] ??
        j['plan_product_id'] ??
        j['planProductId'];

    return raw?.toString();
  }

  // -------------------------
  // ✅ Plan naming
  // -------------------------

  String _planKeyFromProductId(String? productId) {
    if (productId == null || productId.isEmpty) return 'none';

    // ✅ Backend ids
    if (productId == 'whats-annual') return 'silver';
    if (productId == 'annual_package') return 'gold';
    if (productId == 'annual_package_2') return 'premium';

    // ✅ iOS ids (حسب اللي حطيته أنت)
    if (productId == 'com.rassid.ios.annually.whats') return 'silver';
    if (productId == 'com.rassid.ios.annually.goold') return 'gold';
    if (productId == 'com.rassid.ios.annually.special') return 'premium';

    return 'unknown';
  }

  String _arabicPlanName(String planKey) {
    switch (planKey) {
      case 'silver':
        return 'الفضية';
      case 'gold':
        return 'الذهبية';
      case 'premium':
        return 'المميزة';
      default:
        return 'غير معروف';
    }
  }

  void _openHourlyForecastDetails() {
    RouterHelper.getDaysScreenRoute(index: 0);
  }

  void _openWeeklyForecastDetails() {
    RouterHelper.getDaysScreenRoute(index: 0);
  }

  @override
  Widget build(BuildContext context) {
    return UiWidget(
      child: (Appearance ui) {
        return Scaffold(
          backgroundColor: const Color(0xFF1565C0),
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: HomeAppBar(appearance: ui),
          ),
          body: RefreshIndicator(
            edgeOffset: 100,
            strokeWidth: 2,
            backgroundColor: Colors.white,
            onRefresh: refresh,
            child: BlocBuilder<ProfileCubit, ProfileState>(
              buildWhen: (ProfileState prev, ProfileState curr) => prev != curr,
              builder: (BuildContext context, ProfileState profileState) {
                // ✅ من ProfileCubit عندك: ProfileSuccess(profile)
                UserModel? user;
                if (profileState is ProfileSuccess) {
                  user = profileState.profile;
                }

                final Map<String, dynamic> uj = _safeUserJson(user);

                final bool isVip = user?.isVip ?? false;
                final bool isVipChat = user?.isVipChat ?? false;

                final DateTime? expiredAt = _readExpiredAtFromUserJson(uj);
                final bool notExpired =
                    expiredAt == null || DateTime.now().isBefore(expiredAt);

                final String? productId = _readProductId(user);
                final String planKey = _planKeyFromProductId(productId);

                final bool isActive = notExpired;

                final bool hasPremium =
                    isActive &&
                    (planKey == 'silver' ||
                        planKey == 'gold' ||
                        planKey == 'premium');

                // ✅ ملاحظة: ما غيرت باقي المنطق، خليته زي ما هو عندك
                final bool removeAds =
                    isActive &&
                    (planKey == 'gold' ||
                        planKey == 'premium' ||
                        planKey == 'silver');

                final bool showAnimation = hasPremium;

                final bool chatEmail =
                    isActive && (planKey == 'gold' || planKey == 'silver');
                final bool chatWhatsApp = isActive && (planKey == 'silver');

                return BlocConsumer<WeatherCubit, WeatherState>(
                  buildWhen: (WeatherState previous, WeatherState current) =>
                      previous.current != current.current ||
                      previous.isLoading != current.isLoading ||
                      previous.error != current.error,
                  listener: (_, WeatherState state) {
                    if (state.current?.appearance != null) {
                      context.read<UiCubit>().changeAppTheme(
                        state.current!.appearance!,
                      );
                    }
                  },
                  builder: (BuildContext context, WeatherState state) {
                    if (state.isLoading && state.current == null) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[Color(0xFF1E88E5), Color(0xFF1565C0)],
                          ),
                        ),
                        child: const Center(child: LoaderWidget()),
                      );
                    }

                    if (state.current != null) {
                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          WeatherBackground(showAnimation: showAnimation),

                          _buildMainContent(
                            removeAds: removeAds,
                            chatEmail: chatEmail,
                            chatWhatsApp: chatWhatsApp,
                            hasPremium: hasPremium,
                            planLabel: _arabicPlanName(planKey),
                          ),
                          _buildLastUpdated(),
                        ],
                      );
                    }

                    if (state.error != null) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[Color(0xFF1E88E5), Color(0xFF1565C0)],
                          ),
                        ),
                        child: Center(
                          child: EmptyWidget(
                            icon: Icons.cloud_off_outlined,
                            message: _weatherErrorTitle(context),
                            message1: _weatherErrorBody(context),
                            onTap: () => refresh(),
                          ),
                        ),
                      );
                    }

                    // Default state: show blue background with loader
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[Color(0xFF1E88E5), Color(0xFF1565C0)],
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent({
    required bool removeAds,
    required bool chatEmail,
    required bool chatWhatsApp,
    required bool hasPremium,
    required String planLabel,
  }) {
    final bool isArabic = context.read<LanguageCubit>().isArabic();

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 120),
          const WeatherHeader(),

          if (hasPremium && planLabel != 'unknown') ...<Widget>[
            const SizedBox(height: 8),
            // Text(
            //   'الباقة: $planLabel',
            //   style: const TextStyle(
            //     color: Colors.white,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
          ],

          const SizedBox(height: 20),

          if (!removeAds)
            const NativeAdWidget(
              size: AdSize.banner,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),

          const SizedBox(height: 20),
          const HourlyWeather(),
          Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              right: isArabic ? 25 : 0,
              left: isArabic ? 0 : 25,
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: _openHourlyForecastDetails,
                  child: Text(
                    'weather.seeMore'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isArabic) ...<Widget>[
            const SizedBox(height: 20),
            const RepaintBoundary(
              child: FeaturedArticlesCarousel(
                key: ValueKey<String>('featured_articles'),
              ),
            ),
          ],

          const SizedBox(height: 20),
          const WeeklyForecastWidget(),
          Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              right: isArabic ? 25 : 0,
              left: isArabic ? 0 : 25,
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: _openWeeklyForecastDetails,
                  child: Text(
                    'weather.seeMore'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (!removeAds)
            const NativeAdWidget(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),

          if (!hasPremium) const PremiumSubscriptionCard(),

          if (chatEmail) ...<Widget>[
            const SizedBox(height: 20),
            const WeatherInquiryCard(),
          ],

          const WeatherMapsWidget(),
          const SizedBox(height: 30),
          const NativeAdWidgetReal(),

          if (chatWhatsApp) ...<Widget>[
            const WhatsAppContactCard(),
            const SizedBox(height: 20),
          ],

          const WeatherDetailsGrid(),

          if (!removeAds)
            const NativeAdWidget(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLastUpdated() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FadeTransition(
        opacity: _fadeAnimController,
        child: ScaleTransition(
          scale: _fadeAnimController,
          child: FutureBuilder<DateTime?>(
            future: context.read<WeatherCubit>().getLastUpdate(),
            builder: (_, AsyncSnapshot<DateTime?> snapshot) {
              return ForecastLastUpdated(lastUpdated: snapshot.data);
            },
          ),
        ),
      ),
    );
  }
}
