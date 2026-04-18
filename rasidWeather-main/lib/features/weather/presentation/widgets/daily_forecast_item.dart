import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/weather_condition_localizer.dart';
import '../../../../enums/enums.dart';
import '../../../../utils/utils.dart';
import '../../../../views/base/tooltip_widget.dart';
import '../../data/models/weather_model.dart';
import 'forecast_display.dart';
import 'forecast_icon.dart';


/// A widget that displays a single day's weather forecast information.
///
/// This widget shows detailed weather information for a specific day including:
/// - Date and day name
/// - Weather condition icon with tooltip
/// - Precipitation chance (if applicable)
/// - Maximum and minimum temperatures
/// - Temperature range visualization bar
class DailyForecastItem extends StatelessWidget {
  /// Creates a daily forecast item widget.
  ///
  /// Requires [day] parameter containing the weather data for the specific day
  /// and [textColor] for styling the text elements.
  const DailyForecastItem({super.key, required this.day, required this.textColor});

  /// The color to be used for text elements
  final Color textColor;

  /// The weather data for this specific day
  final Day day;

  /// Constants for styling and layout
  static const double _kVerticalPadding = 5.0;
  static const double _kBottomPadding = 4.0;
  static const double _kIconSize = 35.0;
  static const double _kTooltipOffset = -30.0;
  static const double _kTooltipVerticalOffset = -37.0;
  static const double _kTemperatureWidth = 40.0;
  static const double _kBarHeight = 5.0;
  static const double _kBarRadius = 10.0;
  static const double _kDateFontSize = 12.64;
  static const double _kDayNameFontSize = 16.0;
  static const double _kTempFontSize = 16.0;
  static const double _kUnitSizeFactor = 2;

  // Static caches for expensive objects
  static final Map<String, TextStyle> _textStyleCache = <String, TextStyle>{};

  // Cached padding instances
  static const EdgeInsets _verticalPadding = EdgeInsets.symmetric(vertical: _kVerticalPadding);

  // Cached tooltip offset
  static const Offset _tooltipOffset = Offset(_kTooltipOffset, _kTooltipVerticalOffset);
  static const Offset _precipitationTooltipOffset = Offset(_kTooltipOffset - 50, _kTooltipVerticalOffset);

  /// Get cached text style
  TextStyle _getTextStyle(BuildContext context, String key, double fontSize, FontWeight weight) {
    final String styleKey = '$key-${textColor.value}-$fontSize-${weight.index}';
    return _textStyleCache.putIfAbsent(
      styleKey,
          () => Theme.of(context).textTheme.headlineSmall!.copyWith(
        color: textColor,
        fontSize: fontSize.sp,
        fontWeight: weight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle dateStyle = _getTextStyle(context, 'date', _kDateFontSize, FontWeight.w400);
    final TextStyle dayNameStyle = _getTextStyle(context, 'dayName', _kDayNameFontSize, FontWeight.w500);

    return Container(
      padding: _verticalPadding,
      child: RepaintBoundary(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 4.5,
              child: Column(
                children: <Widget>[
                  Text(formatDateTime(day.forecastStart!, format: 'dd')!, style: dateStyle),
                  Padding(
                    padding: const EdgeInsets.only(bottom: _kBottomPadding),
                    child: Text('date.weekdays_full.${day.forecastStart!.weekday}'.tr(), style: dayNameStyle),
                  ),
                ],
              ),
            ),
            _buildWeatherIcon(context),
            _buildPrecipitationChance(context),
            _buildMaxTemperature(context),
            _buildTemperatureBar(context),
            _buildMinTemperature(context),
          ],
        ),
      ),
    );
  }

  /// Builds the weather condition icon with tooltip
  Widget _buildWeatherIcon(BuildContext context) {
    final String tooltipText = WeatherConditionLocalizer.localize(
      context,
      day.daytimeForecast?.condition?.conditionName,
    );

    return RepaintBoundary(
      child: ViewTooltip(
        backgroundColor: Theme.of(context).primaryColor,
        // ✅ FIX: localized tooltip
        message: tooltipText,
        offset: _tooltipOffset,
        child: ForecastIcon(
          containerSize: _kIconSize.sp,
          iconSize: _kIconSize.sp,
          animatedIcon: day.daytimeForecast!.condition!.conditionIsAnimated!,
          icon: day.daytimeForecast!.condition!.conditionImage!,
          shadowColor: textColor,
        ),
      ),
    );
  }

  /// Builds the precipitation chance display
  Widget _buildPrecipitationChance(BuildContext context) {
    if (day.daytimeForecast!.precipitationChance == 0) {
      final TextStyle emptyStyle = _getTextStyle(context, 'empty', _kDayNameFontSize, FontWeight.w500);
      return Text('   ', style: emptyStyle);
    }

    final TextStyle precipStyle = _getTextStyle(context, 'precip', 12.0, FontWeight.w400);
    final String percentage = (day.daytimeForecast?.precipitationChance ?? 0).toString().convertToPercentage();

    return RepaintBoundary(
      child: ViewTooltip(
        backgroundColor: Theme.of(context).primaryColor,
        message: 'weather.forecast.rain_chance'.tr(),
        offset: _precipitationTooltipOffset,
        child: Text(percentage, style: precipStyle),
      ),
    );
  }

  /// Builds the maximum temperature display
  Widget _buildMaxTemperature(BuildContext context) {
    return SizedBox(width: _kTemperatureWidth.w, child: _buildTemperatureDisplay(context, day.temperatureMax));
  }

  /// Builds the minimum temperature display
  Widget _buildMinTemperature(BuildContext context) {
    return SizedBox(width: _kTemperatureWidth.w, child: _buildTemperatureDisplay(context, day.temperatureMin));
  }

  /// Helper method to build temperature display
  Widget _buildTemperatureDisplay(BuildContext context, num? temperature) {
    final TextStyle tempStyle = _getTextStyle(context, 'temp', _kTempFontSize, FontWeight.w500);

    return RepaintBoundary(
      child: ForecastDisplay(
        value: getTemperature(temperature).toString(),
        unit: getUnitSymbol(TemperatureUnit.celsius),
        style: tempStyle,
        unitSizeFactor: _kUnitSizeFactor,
      ),
    );
  }

  /// Builds the temperature range visualization bar
  Widget _buildTemperatureBar(BuildContext context) {
    final double gradientWidth = MediaQuery.sizeOf(context).width * 0.16;

    final double tempMax = day.temperatureMax ?? 0;
    final double tempMin = day.temperatureMin ?? 0;

    final double tempDiff = tempMax - tempMin;
    final double percentage = tempDiff > 0 ? tempDiff / 100 : 0;

    return RepaintBoundary(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: gradientWidth, maxHeight: _kBarHeight),
        child: Stack(children: <Widget>[_buildBarBackground(), _buildBarGradient(gradientWidth, percentage)]),
      ),
    );
  }

  /// Builds the background of the temperature bar
  Widget _buildBarBackground() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(_kBarRadius)),
        color: const Color(0xff104084).withOpacity(0.5),
      ),
    );
  }

  /// Builds the gradient part of the temperature bar
  Widget _buildBarGradient(double width, double percentage) {
    final double barWidth = width - (width * percentage).clamp(0.0, width);

    final double tempMin = day.temperatureMin ?? 0;
    final double tempMax = day.temperatureMax ?? 0;

    const double coldTemp = 0;
    const double mildTemp = 15;
    const double hotTemp = 30;

    List<Color> gradientColors = <Color>[];

    if (tempMin <= coldTemp) {
      gradientColors.add(const Color(0xFF0596FF));
    }

    if (tempMin <= mildTemp && tempMax >= coldTemp) {
      gradientColors.add(const Color(0xFF06E036));
    }

    if (tempMax >= hotTemp) {
      gradientColors.add(const Color(0xFFFFA800));
    } else if (tempMax >= mildTemp) {
      gradientColors.add(const Color(0xFFFFC107));
    }

    if (gradientColors.length < 2) {
      if (gradientColors.isEmpty) {
        gradientColors = <Color>[const Color(0xFF0596FF), const Color(0xFF06E036)];
      } else {
        final Color baseColor = gradientColors.first;
        gradientColors.add(baseColor.withOpacity(0.7));
      }
    }

    return Container(
      width: barWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(_kBarRadius)),
        gradient: LinearGradient(colors: gradientColors),
      ),
    );
  }
}
