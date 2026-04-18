import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../../common/constants/index.dart';
import '../../../../../locator.dart';
import '../../../../ads/presentation/services/ads_service.dart';
import '../../../data/models/weather_model.dart';
import 'components/cloud_cover/cloudy_cover_card.dart';
import 'components/humidity/humidity_cover_widget.dart';
import 'components/pressure/pressure_card.dart';
import 'components/rain/rain_card.dart';
import 'components/temperature/temperature_card.dart';
import 'components/windy/windy_card.dart';
import 'weather_charts_appbar.dart';

/// A screen that displays various weather charts and metrics in a grid layout.
/// Each tab represents a different time period and shows multiple weather parameters
/// including temperature, wind, humidity, pressure, rain, and cloudiness.
class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key, required this.days});

  /// List of chart models containing weather data for different time periods
  final List<Day> days;

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen>
    with TickerProviderStateMixin {
  /// Controller for managing tab transitions and animations
  late TabController _tabController;
  int? _previousDaysLength;

  /// Manager for handling advertisement displays
  // final AdManager _adManager = AdManager();

  @override
  void initState() {
    _initializeTabController();
    super.initState();
  }

  @override
  void didUpdateWidget(ChartsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the number of days has changed
    if (oldWidget.days.length != widget.days.length) {
      // Dispose of the old controller
      _tabController.dispose();
      _initializeTabController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the number of days has changed
    if (_previousDaysLength != widget.days.length) {
      // Dispose of the old controller if it exists
      if (_previousDaysLength != null) {
        _tabController.dispose();
      }
      _initializeTabController();
    }
  }

  void _initializeTabController() {
    // Safety check to ensure we have days
    if (widget.days.isEmpty) {
      _previousDaysLength = 0;
      _tabController = TabController(
        animationDuration: const Duration(
          milliseconds: AppStrings.animationDuration,
        ),
        length: 1, // Default to 1 tab if no days
        vsync: this,
      );
      return;
    }

    _previousDaysLength = widget.days.length;
    _tabController = TabController(
      animationDuration: const Duration(
        milliseconds: AppStrings.animationDuration,
      ),
      length: widget.days.length,
      vsync: this,
    );
    _tabController.animateTo(
      0,
      duration: const Duration(milliseconds: AppStrings.animationDuration),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    // _adManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            WeatherChartsAppBar(
              days: widget.days,
              tabController: _tabController,
              innerBoxIsScrolled: innerBoxIsScrolled,
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                // Display banner advertisement
                Align(
                  child: FutureBuilder<Widget>(
                    future: sl<AdsService>().getBannerAd(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<Widget> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                // _adManager.bannerAd,
                // Weather charts grid view
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children:
                        widget.days.isEmpty
                            ? <Widget>[const Center(child: Text('No data available'))]
                            : widget.days.length > _tabController.length
                            ? widget.days.sublist(0, _tabController.length).map(
                              (Day forecast) {
                                return _buildDayContent(forecast);
                              },
                            ).toList()
                            : widget.days.map((Day forecast) {
                              return _buildDayContent(forecast);
                            }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Builds a list of weather metric widgets for a given forecast
  ///
  /// Returns a list of widgets displaying different weather parameters:
  /// - Temperature
  /// - Wind
  /// - Humidity
  /// - Pressure
  /// - Rain
  /// - Cloudiness
  List<Widget> _buildItems(Day forecast) {
    return <Widget>[
      TemperatureCard(day: forecast),
      WindyItem(day: forecast),
      HumidityCoverWidget(day: forecast),
      PressureCard(day: forecast),
      RainCard(day: forecast),
      CloudCoverWidget(day: forecast),
    ];
  }

  Widget _buildDayContent(Day forecast) {
    return AlignedGridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 5.sp,
      crossAxisSpacing: 10.sp,
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return RepaintBoundary(child: _buildItems(forecast)[index]);
      },
    );
  }
}
