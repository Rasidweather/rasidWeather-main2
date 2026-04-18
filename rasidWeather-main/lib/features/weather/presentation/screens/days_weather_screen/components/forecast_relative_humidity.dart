import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/core.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../utils/strings.dart';
import '../../../../../../views/base/weather_container.dart';
import '../../../widgets/forecast_meta_info.dart';


/// A widget that displays relative humidity information.
///
/// This widget shows:
/// - Humidity icon in a styled card
/// - Relative humidity percentage (0-100%)
/// - Label and description in Arabic
///
/// The widget can be configured to show current or forecast data.
class ForecastRelativeHumidity extends StatelessWidget {
  /// Creates a forecast relative humidity widget.
  ///
  /// [relativeHumidity] is required and represents the percentage of relative humidity (0-100%).
  /// [currentView] determines if this is showing current or forecast data.
  const ForecastRelativeHumidity({
    super.key,
    required this.relativeHumidity,
    this.currentView = false,
  });

  /// The percentage of relative humidity (0-100%)
  final double relativeHumidity;

  /// Whether this widget shows current or forecast data
  final bool currentView;

  /// Constants for styling and layout
  static const double _kVerticalMargin = 5.0;
  static const double _kHorizontalPadding = 10.0;
  static const double _kTopPadding = 15.0;
  static const double _kIconPadding = 5.0;
  static const double _kIconSize = 38.0;
  static const double _kIconImageSize = 10.0;
  static const double _kBorderRadius = 12.0;
  static const double _kCardElevation = 10.0;

  /// Text styles
  static const double _kTitleFontSize = 12.0;
  static const double _kSubtitleFontSize = 10.0;
  static const Color _kTextColor = Color(0xff3D3C3C);
  static const Color _kIconBackgroundColor = Color(0xffD1495B);

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
          _buildHumidityInfo(),
          _buildDescription(),
        ],
      ),
    );
  }

  /// Builds the humidity information section with icon and value.
  Widget _buildHumidityInfo() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildHumidityIcon(),
          _buildHumidityValue(),
        ],
      ),
    );
  }

  /// Builds the humidity icon card.
  Widget _buildHumidityIcon() {
    return Card(
      elevation: _kCardElevation,
      child: Container(
        padding: const EdgeInsets.all(_kIconPadding),
        width: _kIconSize,
        height: _kIconSize,
        decoration: BoxDecoration(
          color: _kIconBackgroundColor,
          borderRadius: BorderRadius.circular(_kBorderRadius),
        ),
        child: ImageView.svgAsset(
          Assets.svgHumidity,
          width: _kIconImageSize,
        ),
      ),
    );
  }

  /// Builds the humidity percentage display.
  Widget _buildHumidityValue() {
    return ForecastMetaInfo(
      currentView: currentView,
      label: 'Humidity',
      value: relativeHumidity.toString().removeZeroLeftDecimal(),
      unit: '%',
    );
  }

  /// Builds the description section with title and subtitle.
  Widget _buildDescription() {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero,
      title: Text(
        'weather.humidity.title'.tr(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: _kTitleFontSize.sp,
          color: _kTextColor,
        ),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(
            'weather.humidity.rate'.tr(),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: _kSubtitleFontSize.sp,
              color: _kTextColor,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
