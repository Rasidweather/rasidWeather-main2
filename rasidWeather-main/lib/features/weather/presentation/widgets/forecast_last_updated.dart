import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../utils/ui_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../views/base/ui_widget.dart';
import '../../data/models/weather_model.dart';

/// A widget that displays the last update time of the weather forecast.
///
/// This widget shows when the weather data was last updated, using different formats
/// depending on whether the update was today or on a different day.
///
/// Features:
/// - Displays "آخر تحديث في" (Last updated at) followed by the formatted time
/// - Uses a short format for updates from today
/// - Uses a long format for updates from previous days
/// - Supports both RTL and LTR text directions
class ForecastLastUpdated extends StatelessWidget {
  /// Creates a ForecastLastUpdated widget.
  ///
  /// Parameters:
  /// - [lastUpdated]: The DateTime when the forecast was last updated
  /// - [shortFormat]: Format pattern for same-day updates (default: 'h:mm a')
  /// - [longFormat]: Format pattern for different-day updates (default: 'EEE, MMM d, yyyy @ h:mm a')
   ForecastLastUpdated({super.key, this.lastUpdated, this.shortFormat = 'h:mm a', this.longFormat = 'EEE, MMM d, yyyy @ h:mm a'}) :
    // Pre-compute formatted text at construction time
    _formattedText = lastUpdated == null ? null : _getFormattedText(lastUpdated, shortFormat, longFormat);

  /// The timestamp of when the forecast was last updated
  final DateTime? lastUpdated;

  /// Format pattern for displaying times from the same day
  /// Example output: "2:30 PM"
  final String shortFormat;

  /// Format pattern for displaying times from different days
  /// Example output: "Sun, Jan 19, 2025 @ 2:30 PM"
  final String longFormat;
  
  /// Pre-computed formatted text to avoid recalculating on each build
  final String? _formattedText;
  
  /// Static method to format the last update text
  static String? _getFormattedText(DateTime? dateTime, String shortFormat, String longFormat) {
    if (dateTime == null) return null;
    
    final DateTime localDateTime = dateTime.toLocal();
    
    if (localDateTime.isToday()) {
      // For updates from today, use the short time format
      return 'weather.last_updated'.tr().replaceFirst('{}', formatDateTime(localDateTime, format: shortFormat)!);
    } else {
      // For updates from previous days, use the long date-time format
      return 'weather.last_updated'.tr().replaceFirst('{}', formatDateTime(localDateTime, format: longFormat)!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return empty container if no update time is provided
    if (lastUpdated == null || _formattedText == null) {
      return Container();
    }

    // Create a container with a semi-transparent background and rounded corners
    // Wrap with RepaintBoundary to isolate repaints
    return RepaintBoundary(
      // Use a key based on lastUpdated for better identity management
      key: ValueKey<String>('forecast-last-updated-${lastUpdated!.millisecondsSinceEpoch}'),
      child: UiWidget(child: (Appearance color) => _buildContainer(context, color)),
    );
  }



  /// Builds the container with styling and the formatted text
  Widget _buildContainer(BuildContext context, Appearance color) {
    // Cache computed values
    final Color backgroundColor = convertHexaToColor(color.buttonColor!).withOpacity(0.1);
    final Color textColor = convertHexaToColor(color.textColor!).withOpacity(0.8);
    final double bottomMargin = MediaQuery.of(context).padding.bottom + 16.0;
    
    // Use const for padding to avoid recreating
    const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(10.0));
    const TextStyle textStyle = TextStyle(fontSize: 12.0);
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      padding: padding,
      // Add bottom padding to account for device's bottom safe area
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Text(
        _formattedText!, 
        style: textStyle.copyWith(color: textColor),
      ),
    );
  }
}
