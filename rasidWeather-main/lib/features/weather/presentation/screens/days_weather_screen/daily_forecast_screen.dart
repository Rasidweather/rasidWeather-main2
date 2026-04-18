import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../common/constants/strings.dart';
import '../../../../../core/widgets/subscription_widget.dart';
import '../../../../../enums/temperature_unit.dart';
import '../../../../../locator.dart';
import '../../../../../providers/tab_index_bloc.dart';
import '../../../../../utils/utils.dart';
import '../../../../../views/base/native_ad_widget.dart';
import '../../../../../views/base/tooltip_widget.dart';
import '../../../../../views/base/weather_container.dart';
import '../../../../ads/presentation/services/ads_service.dart';
import '../../../data/models/weather_model.dart';
import '../../cubit/weather_cubit.dart';
import '../../widgets/forecast_display.dart';
import '../../widgets/forecast_icon.dart';
import '../../widgets/hours_widget/hourly_item.dart';
import 'components/forecast_metrics_grid.dart';
import 'forecast_day_night_reports.dart';
import 'forecast_days_app_bar.dart';

class DailyForecastScreen extends StatefulWidget {
  const DailyForecastScreen({super.key, required this.index});

  final int index;

  @override
  State<DailyForecastScreen> createState() => _DailyForecastScreenState();
}

class _DailyForecastScreenState extends State<DailyForecastScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  static const double _kHorizontalMargin = 10.0;
  static const double _kVerticalSpacing = 10.0;
  static const double _kContainerHorizontalPadding = 20.0;
  static const double _kContainerVerticalPadding = 15.0;
  static const double _kIconSize = 50.0;
  static const double _kHourlyListHeight = 160.0; // ↑ زودنا شوية عشان الوصف
  static const double _kBottomSpacing = 50.0;
  static const double _kTooltipOffset = -30.0;

  static const double _kTemperatureFontSize = 15.0;
  static const double _kLabelFontSize = 10.0;
  static const Color _kTextColor = Color(0xff3D3C3C);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  int? _previousDaysLength;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final WeatherState state = context.read<WeatherCubit>().state;
    if (state.days != null && _previousDaysLength != state.days!.length) {
      if (_previousDaysLength != null) {
        _tabController.dispose();
      }
      _initializeTabController();
    }
  }

  void _initializeTabController() {
    final WeatherState state = context.read<WeatherCubit>().state;
    if (state.days == null || state.days!.isEmpty) {
      _previousDaysLength = 0;
      return;
    }

    _previousDaysLength = state.days!.length;

    _tabController = TabController(
      length: state.days!.length,
      animationDuration: const Duration(milliseconds: AppStrings.animationDuration),
      vsync: this,
    );

    final int safeIndex = widget.index < state.days!.length ? widget.index : 0;

    _tabController.animateTo(
      safeIndex,
      duration: const Duration(milliseconds: AppStrings.animationDuration),
    );

    _tabController.addListener(_onTabChanged);

    // لا تعرض الإنتيرستيشال إن كان المستخدم VIP
    if (!AppStrings.isVip) {
      sl<AdsService>().showInterstitialAd();
    }
  }

  void _onTabChanged() {
    final WeatherState state = context.read<WeatherCubit>().state;
    if (state.days == null || state.hours == null) return;

    context.read<TabIndexBloc>().selectDayTab(
      state.days![widget.index],
      state.hours!,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<WeatherCubit, WeatherState>(
      listenWhen: (WeatherState previous, WeatherState current) => previous.days?.length != current.days?.length,
      listener: (BuildContext context, WeatherState state) {
        if (_previousDaysLength != state.days?.length) {
          if (_previousDaysLength != null) {
            _tabController.dispose();
          }
          _initializeTabController();
        }
      },
      child: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (BuildContext context, WeatherState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.days == null) {
            return Center(child: Text('weather.no_data'.tr()));
          }

          return Scaffold(
            key: _scaffoldKey,
            // لا نعرض إعلان سفلي للمشتركين
            bottomNavigationBar: AppStrings.isVip ? null : const NativeAdWidget(),
            body: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  ForecastDaysAppBar(
                    tabController: _tabController,
                    innerBoxIsScrolled: innerBoxIsScrolled,
                    onBackPressed: AppStrings.isVip
                        ? () {} // ← دالة فاضية بدل null
                        : () {
                      sl<AdsService>().showInterstitialAd();
                    },
                  ),

                ];
              },
              body: _buildBody(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Builder(
      builder: (BuildContext context) {
        final TabIndexBloc selectedIndex = Provider.of<TabIndexBloc>(context);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // بانر أعلى المحتوى (مخفي للمشتركين)
            if (!AppStrings.isVip)
              FutureBuilder<Widget>(
                future: sl<AdsService>().getBannerAd(),
                builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                  if (snapshot.hasData) return snapshot.data!;
                  return const SizedBox.shrink();
                },
              ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[..._buildDayTabs(selectedIndex)],
              ),
            ),
          ],
        );
      },
    );
  }

  Iterable<ListView> _buildDayTabs(TabIndexBloc selectedIndex) {
    final WeatherState state = context.read<WeatherCubit>().state;
    if (state.days == null) return <ListView>[];

    return state.days!
        .map(
          (Day forecast) => ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDayNightTemperature(forecast),
          const SizedBox(height: _kVerticalSpacing),
          _buildHourlyList(forecast),
          const SizedBox(height: _kVerticalSpacing),
          if (selectedIndex.hour != null)
            ForecastMetricsGrid(hour: selectedIndex.hour!),
          ForecastDayNightReports(day: forecast),
          const SizedBox(height: _kVerticalSpacing),
          // بطاقة الاشتراك مخفية لو VIP
          if (!AppStrings.isVip) const SubscriptionWidget(),
          const SizedBox(height: _kBottomSpacing),
          // إعلان سفلي داخل التاب (مخفي لو VIP)
          if (!AppStrings.isVip) const NativeAdWidget(),
          const SizedBox(height: _kBottomSpacing),
        ],
      ),
    )
        .toList()
        .getRange(0, state.days!.length);
  }

  Widget _buildDayNightTemperature(Day forecast) {
    return Row(
      children: <Widget>[
        Expanded(child: _buildTemperatureCard(forecast, true)),
        const SizedBox(width: _kVerticalSpacing),
        Expanded(child: _buildTemperatureCard(forecast, false)),
      ],
    );
  }

  Widget _buildTemperatureCard(Day forecast, bool isDay) {
    final Forecast dayPart = isDay ? forecast.daytimeForecast! : forecast.overnightForecast!;
    final num temperature = isDay ? forecast.temperatureMax! : forecast.temperatureMin!;

    return WeatherContainer(
      margin: const EdgeInsets.symmetric(horizontal: _kHorizontalMargin),
      padding: const EdgeInsets.fromLTRB(
        _kContainerHorizontalPadding,
        _kContainerVerticalPadding,
        _kContainerHorizontalPadding,
        _kContainerVerticalPadding - 5,
      ),
      color: Colors.white,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildWeatherIcon(dayPart),
          _buildTemperatureInfo(temperature, isDay),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(Forecast forecast) {
    return ViewTooltip(
      message: forecast.condition!.conditionName.toString(),
      backgroundColor: Theme.of(context).primaryColor,
      offset: Offset(_kTooltipOffset.w, _kTooltipOffset.h),
      child: ForecastIcon(
        containerSize: _kIconSize.sp,
        iconSize: _kIconSize.sp,
        icon: forecast.condition!.conditionImageBlue!,
        animatedIcon: forecast.condition!.conditionIsAnimated!,
      ),
    );
  }

  Widget _buildTemperatureInfo(num temperature, bool isDay) {
    return Column(
      children: <Widget>[
        ForecastDisplay(
          value: temperature.round().toString(),
          unit: getUnitSymbol(TemperatureUnit.celsius),
          style: TextStyle(
            color: _kTextColor,
            fontSize: _kTemperatureFontSize.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          isDay ? 'weather.inDay'.tr() : 'weather.inNight'.tr(),
          style: TextStyle(
            color: _kTextColor,
            fontSize: _kLabelFontSize.sp,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }

  // ===== Helpers: استخراج حرارة الساعة =====
  double? _extractTempCHour(Hour h) => h.temperature;

  // ===== Mapping: مفاتيح الترجمة لوصف الحرارة =====
  // <=4  -> very_cold
  // 5-15 -> cold
  // 16-25 -> mild
  // 26-34 -> warm
  // 35-43 -> hot
  // 44-60 -> very_hot
  String _tempLabelKey(double? c) {
    if (c == null) return '';
    if (c <= 4) return 'weather.temperature_labels.very_cold';
    if (c >= 5 && c <= 16) return 'weather.temperature_labels.cold';
    if (c >= 16 && c <= 26) return 'weather.temperature_labels.mild';
    if (c >= 26 && c <= 35) return 'weather.temperature_labels.warm';
    if (c >= 35 && c <= 44) return 'weather.temperature_labels.hot';
    if (c >= 44 && c <= 60) return 'weather.temperature_labels.very_hot';
    return '';
  }

  /// وصف حراري مترجَم أسفل كل ساعة
  Widget _hourTempDescription(Hour h, BuildContext context) {
    final double? t = _extractTempCHour(h);
    final String key = _tempLabelKey(t);
    if (key.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Text(
        key.tr(), // ← ترجمة
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w300,
          color: _kTextColor,
        ),
      ),
    );
  }

  /// قائمة ساعات اليوم بعرض ثابت لكل عنصر + وصف حراري
  Widget _buildHourlyList(Day forecast) {
    final WeatherState state = context.read<WeatherCubit>().state;
    final TabIndexBloc selectedIndex = Provider.of<TabIndexBloc>(context);

    // نحضّر ساعات هذا اليوم فقط
    final List<Hour> hoursForDay = (state.hours ?? <Hour>[])
        .where((Hour h) =>
    h.forecastStart != null &&
        forecast.forecastStart != null &&
        h.forecastStart!.day == forecast.forecastStart!.day &&
        h.forecastStart!.month == forecast.forecastStart!.month &&
        h.forecastStart!.year == forecast.forecastStart!.year)
        .toList();

    // بلاطة موحّدة العرض لثبات المحاذاة
    const double kTileWidth = 72;

    return WeatherContainer(
      margin: const EdgeInsets.symmetric(horizontal: _kHorizontalMargin),
      padding: const EdgeInsets.fromLTRB(
        _kHorizontalMargin,
        _kContainerVerticalPadding,
        _kHorizontalMargin,
        _kContainerVerticalPadding - 5,
      ),
      color: Colors.white,
      content: SizedBox(
        height: _kHourlyListHeight.h,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: hoursForDay.length,
          itemBuilder: (BuildContext context, int index) {
            final Hour hour = hoursForDay[index];

            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => selectedIndex.selectHourTab(hour),
              child: SizedBox(
                width: kTileWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    HourlyItem(hour: hour, blueIcon: true),
                    _hourTempDescription(hour, context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
