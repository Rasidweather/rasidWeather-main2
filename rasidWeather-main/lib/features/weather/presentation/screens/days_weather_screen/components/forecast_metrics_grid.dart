import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../data/models/weather_model.dart';
import 'forecast_atmospheric_pressure.dart';
import 'forecast_cloud_cover.dart';
import 'forecast_precipitation_amount.dart';
import 'forecast_precipitation_chance.dart';
import 'forecast_relative_humidity.dart';
import 'forecast_wind_info.dart';

/// A widget that displays a grid of weather forecast metrics.
///
/// This widget shows various weather metrics in a grid layout:
/// - Wind speed and direction
/// - Relative humidity percentage
/// - Atmospheric pressure
/// - Precipitation amount
/// - Cloud cover percentage
/// - Precipitation chance
///
/// The components can be configured to show current or forecast data.
class ForecastMetricsGrid extends StatefulWidget {
  /// Creates a forecast metrics grid widget.
  ///
  /// [hour] contains the weather data for the metrics.
  /// [currentView] determines if this shows current or forecast data.
  const ForecastMetricsGrid({
    super.key,
    required this.hour,
    this.currentView = false,
  });

  /// The hour containing weather data
  final Hour hour;

  /// Whether this widget shows current or forecast data
  final bool currentView;

  @override
  State<ForecastMetricsGrid> createState() => _ForecastMetricsGridState();
}

class _ForecastMetricsGridState extends State<ForecastMetricsGrid> {
  /// Constants for styling and layout
  static const double _kHorizontalPadding = 10.0;
  static const double _kBottomPadding = 5.0;
  static const double _kMainAxisSpacing = 5.0;
  static const double _kCrossAxisSpacing = 10.0;
  static const int _kGridColumns = 2;

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(
        _kHorizontalPadding,
        0,
        _kHorizontalPadding,
        _kBottomPadding,
      ),
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: _kGridColumns,
      mainAxisSpacing: _kMainAxisSpacing.sp,
      crossAxisSpacing: _kCrossAxisSpacing.sp,
      itemCount: _forecastMetrics.length,
      itemBuilder: (BuildContext context, int index) {
        return _forecastMetrics[index];
      },
    );
  }

  /// List of forecast metric widgets to display.
  ///
  /// Each metric widget is configured with data from the current hour
  /// and the currentView setting.
  List<Widget> get _forecastMetrics {
    return <Widget>[
      ForecastWindInfo(
        windSpeed: widget.hour.windSpeed!,
        windDirection: widget.hour.windDirection!,
        currentView: widget.currentView,
      ),
      ForecastRelativeHumidity(
        relativeHumidity: widget.hour.humidity!,
        currentView: widget.currentView,
      ),
      ForecastAtmosphericPressure(
        atmosphericPressure: widget.hour.pressure!,
        currentView: widget.currentView,
      ),
      ForecastPrecipitationAmount(
        precipitationAmount: widget.hour.precipitationAmount!,
        currentView: widget.currentView,
      ),
      ForecastCloudCover(
        cloudCoverPercentage: widget.hour.cloudCover!,
        currentView: widget.currentView,
      ),
      ForecastPrecipitationChance(
        precipitationChance: widget.hour.precipitationChance!,
        currentView: widget.currentView,
      ),
    ];
  }
}
