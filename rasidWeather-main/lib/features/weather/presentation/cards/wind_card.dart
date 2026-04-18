import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../enums/enums.dart';
import '../../../../features/weather/data/models/weather_model.dart';
import '../../../../features/weather/presentation/cubit/weather_cubit.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/ui_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../views/base/ui_widget.dart';
import '../../../../views/base/weather_container.dart';

/// A card widget that displays wind information.
///
/// This widget shows:
/// - Current wind speed in kilometers per hour
/// - Wind direction (e.g., North, South, etc.)
/// - A description of current wind conditions
///
/// The widget provides detailed information about wind conditions
/// including speed, direction, and potential effects on visibility
/// and outdoor activities.
class WindCard extends StatelessWidget {
  /// Creates a wind card widget.
  ///
  /// Requires [current] parameter containing the current weather data
  /// with wind information.
  const WindCard({super.key});

  /// Constants for styling and layout
  static const double _kHorizontalPadding = 10.0;
  static const double _kTopPadding = 15.0;
  static const double _kBottomPadding = 20.0;
  static const double _kVerticalSpacing = 5.0;
  static const double _kTitleFontSize = 14.22;
  static const double _kValueFontSize = 18.0;
  static const double _kUnitFontSize = 10.0;
  static const double _kDescriptionFontSize = 10.0;
  static const double _kIconSize = 30.0;
  static const double _kIconPadding = 3.0;
  static const double _kIconBorderRadius = 5.0;
  static const double _kHorizontalIconSpacing = 8.0;

  /// Wind direction thresholds in degrees
  static const double _kNorthThreshold = 337.5;
  static const double _kNorthWestThreshold = 292.5;
  static const double _kWestThreshold = 247.5;
  static const double _kSouthWestThreshold = 202.5;
  static const double _kSouthThreshold = 157.5;
  static const double _kSouthEastThreshold = 122.5;
  static const double _kEastThreshold = 67.5;
  static const double _kNorthEastThreshold = 22.5;

  /// Wind speed thresholds in km/h
  static const int _kLightWindThreshold = 15;
  static const int _kModerateWindThreshold = 25;
  static const int _kStrongWindThreshold = 49;
  static const int _kVeryStrongWindThreshold = 65;

  /// Converts wind direction in degrees to textual description.
  ///
  /// Returns a string describing the wind direction in Arabic.
  String _getWindDirection(CurrentWeather degree) {
    if (degree.windDirection! > _kNorthThreshold) return 'weather.wind.directions.north'.tr();
    if (degree.windDirection! > _kNorthWestThreshold) return 'weather.wind.directions.north_west'.tr();
    if (degree.windDirection! > _kWestThreshold) return 'weather.wind.directions.west'.tr();
    if (degree.windDirection! > _kSouthWestThreshold) return 'weather.wind.directions.south_west'.tr();
    if (degree.windDirection! > _kSouthThreshold) return 'weather.wind.directions.south'.tr();
    if (degree.windDirection! > _kSouthEastThreshold) return 'weather.wind.directions.south_east'.tr();
    if (degree.windDirection! > _kEastThreshold) return 'weather.wind.directions.east'.tr();
    if (degree.windDirection! > _kNorthEastThreshold) return 'weather.wind.directions.north_east'.tr();
    return 'weather.wind.direction.north'.tr();
  }

  /// Generates a detailed description of wind conditions.
  ///
  /// Takes into account wind speed and direction to provide a comprehensive
  /// description of current wind conditions and their potential effects.
  String _generateWindDescription(CurrentWeather current) {
    final num windSpeed = getWindSpeed(current.windGust);
    final String direction = _getWindDirection(current);

    if (windSpeed <= _kLightWindThreshold) {
      return 'weather.wind.descriptions.light'.tr().replaceFirst('{speed}', windSpeed.toString()).replaceFirst('{direction}', direction);
    }
    if (windSpeed <= _kModerateWindThreshold) {
      return 'weather.wind.descriptions.moderate'.tr().replaceFirst('{speed}', windSpeed.toString()).replaceFirst('{direction}', direction);
    }
    if (windSpeed <= _kStrongWindThreshold) {
      return 'weather.wind.descriptions.strong'.tr().replaceFirst('{speed}', windSpeed.toString()).replaceFirst('{direction}', direction);
    }
    if (windSpeed <= _kVeryStrongWindThreshold) {
      return 'weather.wind.descriptions.very_strong'.tr().replaceFirst('{speed}', windSpeed.toString()).replaceFirst('{direction}', direction);
    }
    return 'weather.wind.descriptions.storm'.tr().replaceFirst('{speed}', windSpeed.toString()).replaceFirst('{direction}', direction);
  }

  @override
  Widget build(BuildContext context) {
    return UiWidget(
      child: (Appearance ui) {
        final Color textColor = convertHexaToColor(ui.textColor!);
        return WeatherContainer(
          padding: const EdgeInsets.fromLTRB(
            _kHorizontalPadding,
            _kTopPadding,
            _kHorizontalPadding,
            _kBottomPadding,
          ),
          header: _buildHeader(textColor),
          content: _buildContent(context, textColor),
        );
      },
    );
  }

  /// Builds the header section with the title "الرياح" (Wind).
  Widget _buildHeader(Color textColor) {
    return Text(
      'weather.wind.title'.tr(),
      style: TextStyle(
        color: textColor,
        fontSize: _kTitleFontSize.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  /// Builds the main content section with wind information.
  Widget _buildContent(BuildContext context, Color textColor) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) => previous.current!.windSpeed != current.current!.windSpeed,
      builder: (BuildContext context, WeatherState state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: _kVerticalSpacing),
            _buildWindInfo(context, state.current!, textColor),
            const SizedBox(height: _kVerticalSpacing),
            _buildDescription(state.current!, textColor),
          ],
        );
      },
    );
  }

  /// Builds the row containing the wind icon and speed value.
  Widget _buildWindInfo(BuildContext context, CurrentWeather current, Color textColor) {
    return Row(
      children: <Widget>[
        _buildWindIcon(context, textColor),
        _buildUnitLabel(context, textColor),
        _buildWindSpeed(context, current, textColor),
      ],
    );
  }

  /// Builds the wind icon with background.
  Widget _buildWindIcon(BuildContext context, Color textColor) {
    return Container(
      width: _kIconSize.sp,
      height: _kIconSize.sp,
      padding: const EdgeInsets.all(_kIconPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_kIconBorderRadius),
        color: Theme.of(context).primaryColor.withAlpha((0.4 * 255).round()),
      ),
      child: ImageView.svgAsset(
        Assets.svgWindy,
        color: textColor,
      ),
    );
  }

  /// Builds the unit label (km/h).
  Widget _buildUnitLabel(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _kHorizontalIconSpacing,
      ),
      child: Text(
        WindSpeedUnit.kmh.getText(context).tr(),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: _kUnitFontSize.sp,
              color: textColor.darken(),
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  /// Builds the wind speed value display.
  Widget _buildWindSpeed(BuildContext context, CurrentWeather current, Color textColor) {
    return Text(
      getWindSpeed(current.windGust).toString(),
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            color: textColor,
            fontSize: _kValueFontSize.sp,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  /// Builds the wind description text.
  Widget _buildDescription(CurrentWeather current, Color textColor) {
    return Text(
      _generateWindDescription(current),
      textAlign: TextAlign.right,
      style: TextStyle(
        color: textColor,
        fontSize: _kDescriptionFontSize.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
