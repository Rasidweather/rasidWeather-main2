import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/themes/app_theme.dart';
import '../../../data/models/weather_model.dart';
import 'hourly_item.dart';

/// A widget that displays the header for each day in the hourly weather forecast.
///
/// This widget combines the day and date information with the hourly weather details
/// to create a clear visual separation between different days in the forecast.
/// It's typically displayed at the start of each day (00:00) in the forecast timeline,
/// helping users easily identify when a new day begins in the hourly forecast view.
class DailyForecastHeader extends StatelessWidget {
  /// Creates a daily forecast header widget.
  ///
  /// Requires [hour] parameter for the weather data and [appearance] for styling.
  /// The [hour] typically represents the first hour (00:00) of the day.
  const DailyForecastHeader({
    super.key,
    required this.hour,
  });

  /// The weather data for this hour (typically 00:00)
  final Hour hour;


  /// Constants for styling and layout
  static const double _kPadding = 8.0;
  static const double _kVerticalSpacing = 5.0;
  static const double _kTextSize = 14.22;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[_buildDateColumn(context), _buildHourlyWeather()],
    );
  }

  /// Builds the date column showing the day name and date
  Widget _buildDateColumn(BuildContext context) {
    final TextStyle dateStyle = Theme.of(
      context,
    ).textTheme.headlineSmall!.copyWith(
      fontSize: _kTextSize.sp,
      fontWeight: FontWeight.w400,
      color: AppTheme.getFadedTextColor(colorTheme: true),
    );

    return Padding(
      padding: const EdgeInsets.all(_kPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDayName(context, dateStyle),
          const SizedBox(height: _kVerticalSpacing),
          _buildMonthDay(context, dateStyle),
        ],
      ),
    );
  }

  /// Builds the day name text widget
  Widget _buildDayName(BuildContext context, TextStyle style) {
    return Text(
      'date.weekdays_full.${hour.forecastStart!.weekday}'.tr(),
      style: style,
    );
  }

  /// Builds the month and day text widget
  Widget _buildMonthDay(BuildContext context, TextStyle style) {
    return Text(
      'date.format.month_day'.tr(
        args: <String>[
          hour.forecastStart!.day.toString(),
          'date.months_full.${hour.forecastStart!.month}'.tr(),
        ],
      ),
      style: style,
    );
  }

  /// Builds the hourly weather information widget
  Widget _buildHourlyWeather() {
    return Padding(
      padding: EdgeInsets.all(_kPadding.sp),
      child: HourlyItem(hour: hour),
    );
  }
}
