import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../enums/enums.dart';
import '../../../../../providers/tab_index_bloc.dart';
import '../../../../../utils/ui_utils.dart';
import '../../../../../utils/utils.dart';
import '../../../../../views/base/index.dart';
import '../../../data/models/weather_model.dart';
import '../forecast_display.dart';
import '../forecast_icon.dart';

/// A widget that displays weather information for a specific hour.
///
/// This widget is used in the hourly weather forecast list to show detailed
/// weather information including temperature, precipitation chance, and weather condition
/// for a specific hour of the day.
class HourlyItem extends StatelessWidget {
  /// Creates a hourly weather item widget.
  ///
  /// The [hour] parameter is required and contains the weather data for the specific hour.
  /// The [appearance] parameter controls the visual styling of the widget.
  /// Other boolean parameters control which elements are visible in the widget.
  const HourlyItem({
    super.key,
    required this.hour,
    this.blueIcon = false,
    this.viewTemperature = true,
    this.viewTime = true,
    this.viewPrecipitation = true,
    this.viewIcon = true,
  });

  /// The weather data for this specific hour
  final Hour hour;

  /// The appearance configuration for styling

  /// Whether to use blue icons instead of white ones
  final bool blueIcon;

  /// Whether to show the temperature
  final bool viewTemperature;

  /// Whether to show the time
  final bool viewTime;

  /// Whether to show the weather icon
  final bool viewIcon;

  /// Whether to show precipitation chance
  final bool viewPrecipitation;

  /// Constants for styling and layout
  static const double _kHorizontalPadding = 10.0;
  static const double _kVerticalPadding = 5.0;
  static const double _kBorderRadius = 15.0;
  static const double _kIconSize = 32.0;
  static const double _kTimeTextSize = 12.22;
  static const double _kPrecipitationTextSize = 8.0;
  static const double _kTooltipOffsetX = -30.0;
  static const double _kTooltipOffsetY = -60.0;
  static const double _kPrecipitationTooltipOffsetY = -98.0;

  // Static cached paddings and decorations
  static final Map<String, EdgeInsets> _paddingCache = <String, EdgeInsets>{};
  static final Map<String, BoxDecoration> _decorationCache =
      <String, BoxDecoration>{};

  // Get cached padding
  EdgeInsets _getPadding() {
    final String key = '${_kHorizontalPadding.w}-${_kVerticalPadding.h}';
    return _paddingCache.putIfAbsent(
      key,
      () => EdgeInsets.symmetric(
        horizontal: _kHorizontalPadding.w,
        vertical: _kVerticalPadding.h,
      ),
    );
  }

  // Get cached decoration
  BoxDecoration _getDecoration(BuildContext context, bool isSelected) {
    final String key = '${Theme.of(context).primaryColor.value}-$isSelected';
    return _decorationCache.putIfAbsent(
      key,
      () => BoxDecoration(
        borderRadius: BorderRadius.circular(_kBorderRadius),
        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Hour? selectedHour = context.watch<TabIndexBloc>().hour;
    // ignore: avoid_bool_literals_in_conditional_expressions
    final bool isSelected = blueIcon ? selectedHour == hour : false;

    // Cache the padding and decoration
    final EdgeInsets padding = _getPadding();
    final BoxDecoration decoration = _getDecoration(context, isSelected);

    // Wrap the entire widget in RepaintBoundary to isolate repaints
    return RepaintBoundary(
      key: ValueKey<String>(
        'hourly-${hour.forecastStart!.millisecondsSinceEpoch}',
      ),
      child: UiWidget(
        child: (Appearance ui) {
          final Color appearanceTextColor =
              convertHexaToColor(ui.textColor ?? '#ffffff');
          final bool useWhiteIcon = _isLightColor(appearanceTextColor);
          final Color textColor = blueIcon && isSelected
              ? Colors.white
              : blueIcon
              ? Colors.black
              : Colors.white;
          return Padding(
            padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
            child: DecoratedBox(
              decoration: decoration,
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (viewTime)
                      _buildTimeDisplay(context, textColor, isSelected),
                    if (viewIcon)
                      _buildWeatherIcon(
                        context,
                        isSelected,
                        textColor,
                        useWhiteIcon,
                      ),
                    if (viewPrecipitation)
                      _buildPrecipitationChance(context, textColor, isSelected),
                    if (viewTemperature)
                      _buildTemperatureDisplay(textColor, isSelected),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the time display section showing the hour and AM/PM
  Widget _buildTimeDisplay(
    BuildContext context,
    Color textColor,
    bool isSelected,
  ) {
    // Memoize formatted time values using static cache
    final Map<int, String> timeCache = <int, String>{};
    final Map<int, String> amPmCache = <int, String>{};

    final int timeKey = hour.forecastStart!.millisecondsSinceEpoch;
    final String hourStr = timeCache.putIfAbsent(
      timeKey,
      () => formatDateTime(hour.forecastStart!, format: 'hh:00\n').toString(),
    );
    final String amPm = amPmCache.putIfAbsent(
      timeKey,
      () => formatDateTime(hour.forecastStart!, format: 'aa')!.toLowerCase(),
    );

    // Cache text styles
    final TextStyle baseStyle = Theme.of(context).textTheme.bodyLarge!.copyWith(
      fontSize: _kTimeTextSize.sp,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: textColor,
    );

    final TextStyle amPmStyle = TextStyle(
      fontSize: _kTimeTextSize.sp,
      fontWeight: FontWeight.w400,
      color: textColor,
    );

    // Use a key based on time data for proper widget identity
    final ValueKey<String> timeKey1 = ValueKey<String>(
      'time-${hour.forecastStart!.hour}',
    );

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.0.h),
        child: Text.rich(
          textAlign: TextAlign.center,
          TextSpan(
            text: hourStr,
            style: baseStyle,
            children: <InlineSpan>[TextSpan(text: amPm, style: amPmStyle)],
          ),
          key: timeKey1,
        ),
      ),
    );
  }

  /// Builds the weather condition icon with tooltip
  Widget _buildWeatherIcon(
    BuildContext context,
    bool isSelected,
    Color shadowColor,
    bool useWhiteIcon,
  ) {
    final String icon = _getWeatherIcon(
      isSelected,
      useWhiteIcon,
    );
    final String conditionName = hour.condition!.conditionName.toString();
    final bool isAnimated = hour.condition!.conditionIsAnimated!;

    // Create a key based on the icon and selection state
    final ValueKey<String> iconKey = ValueKey<String>(
      'icon-$icon-${isSelected ? 'selected' : 'normal'}',
    );

    // Cache offset to avoid recalculation
    final Offset tooltipOffset = Offset(_kTooltipOffsetX.w, _kTooltipOffsetY.h);

    return RepaintBoundary(
      child: ViewTooltip(
        message: conditionName,
        backgroundColor: Theme.of(context).primaryColor,
        offset: tooltipOffset,
        child: ForecastIcon(
          key: iconKey,
          containerSize: _kIconSize.sp,
          iconSize: _kIconSize.sp,
          icon: icon,
          animatedIcon: isAnimated,
          shadowColor: shadowColor,
        ),
      ),
    );
  }

  /// Determines which weather icon to use based on selection state
  String _getWeatherIcon(bool isSelected, bool useWhiteIcon) {
    if (blueIcon) {
      return isSelected
          ? hour.condition!.conditionImageWhite!
          : hour.condition!.conditionImageBlue!;
    }
    if (useWhiteIcon) {
      return hour.condition!.conditionImageWhite!;
    }
    return hour.condition!.conditionImageBlue ??
        hour.condition!.conditionImageWhite!;
  }

  bool _isLightColor(Color color) {
    return color.computeLuminance() > 0.6;
  }

  /// Builds the precipitation chance display with tooltip
  Widget _buildPrecipitationChance(
    BuildContext context,
    Color textColor,
    bool isSelected,
  ) {
    if (hour.precipitationChance == 0) {
      return const SizedBox.shrink();
    }

    // Pre-compute values
    final String precipText = hour.precipitationChance!
        .toString()
        .convertToPercentage();
    final String tooltipMessage = 'weather.forecast.precipitation_chance'.tr();

    // Cache text style
    final TextStyle textStyle = TextStyle(
      color: textColor,
      fontSize: _kPrecipitationTextSize.sp,
      fontWeight: FontWeight.w500,
    );

    // Create a key based on the precipitation value
    final ValueKey<String> precipKey = ValueKey<String>(
      'precip-${hour.precipitationChance}',
    );

    // Cache offset
    final Offset tooltipOffset = Offset(
      _kTooltipOffsetX.w,
      _kPrecipitationTooltipOffsetY.h,
    );

    return RepaintBoundary(
      child: ViewTooltip(
        backgroundColor: Theme.of(context).primaryColor,
        message: tooltipMessage,
        offset: tooltipOffset,
        child: Text(precipText, style: textStyle, key: precipKey),
      ),
    );
  }

  /// Builds the temperature display section
  Widget _buildTemperatureDisplay(Color textColor, bool isSelected) {
    // Pre-compute values
    final String temperature = getTemperature(hour.temperature).toString();
    final String unit = getUnitSymbol(TemperatureUnit.celsius);

    // Cache text style
    final TextStyle textStyle = TextStyle(
      height: 2,
      fontSize: _kTimeTextSize.sp,
      fontWeight: FontWeight.w600,
      color: textColor,
    );

    // Create a key based on the temperature
    final ValueKey<String> tempKey = ValueKey<String>(
      'temp-${hour.temperature}',
    );

    return RepaintBoundary(
      key: tempKey,
      child: ForecastDisplay(
        value: temperature,
        unit: unit,
        unitSizeFactor: 1.5,
        style: textStyle,
      ),
    );
  }
}
