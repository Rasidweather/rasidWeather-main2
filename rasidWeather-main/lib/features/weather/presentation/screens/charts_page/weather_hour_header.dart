import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/tab_index_bloc.dart';
import '../../../../../utils/utils.dart';
import '../../../data/models/weather_model.dart';

/// A header widget for displaying hourly weather information in a dialog.
///
/// This widget is designed to show weather data for a specific hour, including:
/// - Time display (optional)
/// - Custom icon (optional)
/// - Custom value display (optional)
///
/// The widget supports a selected state that changes its appearance when active,
/// making it suitable for interactive displays where users can select different hours.
class WeatherHourHeader extends StatelessWidget {
  /// Creates a weather hour header.
  ///
  /// * [hour] - The weather data for the specific hour (required)
  /// * [color] - Text color in unselected state (defaults to white)
  /// * [blueIcon] - Whether to show selection state with blue background
  /// * [value] - Optional widget to display custom content
  /// * [viewTime] - Whether to show the time (defaults to true)
  /// * [icon] - Optional weather icon to display
  const WeatherHourHeader({
    super.key,
    required this.hour,
    this.color = Colors.white,
    this.blueIcon = false,
    this.value,
    this.viewTime = true,
    this.icon,
  });

  /// The weather data for this specific hour
  final Hour hour;

  /// Text color when the header is not selected
  final Color? color;

  /// Whether this header can be selected (shows blue background when selected)
  final bool blueIcon;

  /// Optional widget to display custom content (e.g., temperature, humidity)
  final Widget? value;

  /// Whether to display the time
  final bool viewTime;

  /// Optional weather icon to display
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final TabIndexBloc selectedHour = Provider.of<TabIndexBloc>(context);
    final bool isSelected = blueIcon && selectedHour.hour == hour;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.0.w,
        vertical: 5.0.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Time display section
          if (viewTime)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0.h),
              child: _buildTimeText(context, isSelected),
            ),
          // Weather icon if provided
          if (icon != null) icon!,
          // Custom value widget if provided
          if (value != null) value!,
        ],
      ),
    );
  }

  /// Builds the formatted time text with proper styling
  ///
  /// Displays the hour in 12-hour format with AM/PM indicator
  Widget _buildTimeText(BuildContext context, bool isSelected) {
    return Text.rich(
      TextSpan(
        text: formatDateTime(
          hour.forecastStart!,
          format: 'hh:00\n',
        ).toString(),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: isSelected ? Colors.white : color,
            ),
        children: <InlineSpan>[
          TextSpan(
            text: formatDateTime(hour.forecastStart!, format: 'aa')!.toLowerCase(),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.white : color,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
