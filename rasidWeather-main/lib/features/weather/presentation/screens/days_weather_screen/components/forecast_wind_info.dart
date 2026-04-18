import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/image_widget.dart';
import '../../../../../../enums/enums.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../../views/base/weather_container.dart';
import '../../../widgets/forecast_meta_info.dart';

/// A widget that displays wind information including speed and direction.
///
/// This widget shows:
/// - Wind icon in a styled card
/// - Wind speed in kilometers per hour (km/h)
/// - Wind direction with a rotating arrow indicator
/// - Label and description in Arabic
///
/// The widget can be configured to show current or forecast data.
class ForecastWindInfo extends StatelessWidget {
  /// Creates a forecast wind information widget.
  ///
  /// [windSpeed] is required and represents the wind speed in kilometers per hour.
  /// [windDirection] is required and represents the wind direction in degrees (0-360).
  /// [currentView] determines if this is showing current or forecast data.
  const ForecastWindInfo({
    super.key,
    required this.windSpeed,
    required this.windDirection,
    this.currentView = false,
  });

  /// The wind speed in kilometers per hour (km/h)
  final double windSpeed;

  /// The wind direction in degrees (0-360)
  final double windDirection;

  /// Whether this widget shows current or forecast data
  final bool currentView;

  /// Constants for styling and layout
  static const double _kVerticalMargin = 5.0;
  static const double _kHorizontalPadding = 10.0;
  static const double _kTopPadding = 15.0;
  static const double _kIconPadding = 5.0;
  static const double _kIconSize = 40.0;
  static const double _kBorderRadius = 12.0;
  static const double _kCardElevation = 10.0;
  static const double _kDirectionIconSize = 20.0;
  static const double _kDirectionIconRotationOffset = 90.0;

  /// Text styles
  static const double _kTitleFontSize = 12.0;
  static const double _kSubtitleFontSize = 10.0;
  static const Color _kTextColor = Color(0xff3D3C3C);
  static const Color _kIconBackgroundColor = Color(0xffFB8500);

  /// The current compass heading (0 degrees is North)
  final double _heading = 0;

  @override
  Widget build(BuildContext context) {
    return WeatherContainer(
      margin: const EdgeInsets.symmetric(
        vertical: _kVerticalMargin,
      ),
      padding: const EdgeInsets.fromLTRB(
        _kHorizontalPadding,
        _kTopPadding,
        _kHorizontalPadding,
        _kHorizontalPadding,
      ),
      color: Colors.white,
      content: Column(
        children: <Widget>[
          _buildWindInfo(context),
          _buildDescription(context),
        ],
      ),
    );
  }

  /// Builds the wind information section with icon and speed.
  Widget _buildWindInfo(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildWindIcon(),
          _buildWindSpeed(context),
        ],
      ),
    );
  }

  /// Builds the wind icon card.
  Widget _buildWindIcon() {
    return Card(
      elevation: _kCardElevation,
      child: Container(
        width: _kIconSize,
        height: _kIconSize,
        padding: const EdgeInsets.all(_kIconPadding),
        decoration: BoxDecoration(
          color: _kIconBackgroundColor,
          borderRadius: BorderRadius.circular(_kBorderRadius),
        ),
        child: ImageView.svgAsset(
          Assets.svgWindy,
        ),
      ),
    );
  }

  /// Builds the wind speed display.
  Widget _buildWindSpeed(BuildContext context) {
    return ForecastMetaInfo(
      currentView: currentView,
      label: 'wind',
      value: getWindSpeed(windSpeed).toString(),
      unit: WindSpeedUnit.kmh.getText(context),
    );
  }

  /// Builds the description section with title and wind direction.
  Widget _buildDescription(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.zero,
      title: Text(
        'weather.wind.subtitle'.tr(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: _kTitleFontSize.sp,
          color: _kTextColor,
        ),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(
            'weather.wind.direction'.tr(),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: _kSubtitleFontSize.sp,
              color: _kTextColor,
            ),
          ),
          const Spacer(),
          _buildWindDirection(context),
        ],
      ),
    );
  }

  /// Builds the wind direction indicator with rotating arrow.
  Widget _buildWindDirection(BuildContext context) {
    return SizedBox(
      height: _kDirectionIconSize,
      width: _kDirectionIconSize,
      child: ImageView.svgAsset(
        Assets.svgWindDirection,
        rotate: getWindDirection(
              windDirection: windDirection,
              heading: _heading,
            ) +
            _kDirectionIconRotationOffset, // +90 to rotate the icon to the right direction
      ),
    );
  }
}
