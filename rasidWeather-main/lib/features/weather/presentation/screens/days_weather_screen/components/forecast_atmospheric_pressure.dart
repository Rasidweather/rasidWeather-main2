import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/image_widget.dart';
import '../../../../../../enums/pressure_unit.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../utils/forecast_utils.dart';
import '../../../../../../utils/units.dart';
import '../../../../../../views/base/weather_container.dart';
import '../../../widgets/forecast_meta_info.dart';


/// A widget that displays atmospheric pressure information.
///
/// This widget shows:
/// - Pressure icon in a styled card
/// - Pressure value in hectopascals (hPa)
/// - Label and description in Arabic
///
/// The widget can be configured to show current or forecast data.
class ForecastAtmosphericPressure extends StatelessWidget {
  /// Creates a forecast atmospheric pressure widget.
  ///
  /// [atmosphericPressure] is required and represents the atmospheric pressure in hectopascals.
  /// [currentView] determines if this is showing current or forecast data.
  const ForecastAtmosphericPressure({
    super.key,
    required this.atmosphericPressure,
    this.currentView = false,
  });

  /// The atmospheric pressure in hectopascals (hPa)
  final double atmosphericPressure;

  /// Whether this widget shows current or forecast data
  final bool currentView;

  /// Constants for styling and layout
  static const double _kVerticalMargin = 5.0;
  static const double _kHorizontalPadding = 10.0;
  static const double _kTopPadding = 15.0;
  static const double _kIconPadding = 6.0;
  static const double _kIconSize = 38.0;
  static const double _kIconImageSize = 10.0;
  static const double _kBorderRadius = 12.0;
  static const double _kCardElevation = 10.0;

  /// Text styles
  static const double _kTitleFontSize = 12.0;
  static const double _kSubtitleFontSize = 10.0;
  static const Color _kTextColor = Color(0xff3D3C3C);
  static const Color _kIconBackgroundColor = Color(0xff76C893);

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
          _buildPressureInfo(context),
          _buildDescription(),
        ],
      ),
    );
  }

  /// Builds the pressure information section with icon and value.
  Widget _buildPressureInfo(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildPressureIcon(),
          _buildPressureValue(context),
        ],
      ),
    );
  }

  /// Builds the pressure icon card.
  Widget _buildPressureIcon() {
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
          Assets.svgPressure,
          width: _kIconImageSize,
        ),
      ),
    );
  }

  /// Builds the pressure value display.
  Widget _buildPressureValue(BuildContext context) {
    return ForecastMetaInfo(
      currentView: currentView,
      label: 'pressure',
      value: getPressure(atmosphericPressure, PressureUnit.hpa).toString(),
      unit: const Units().pressure.getText(context),
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
        'weather.pressure.title'.tr(),
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: _kTitleFontSize.sp,
          color: _kTextColor,
        ),
      ),
      subtitle: Text(
        'weather.pressure.rate'.tr(),
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: _kSubtitleFontSize.sp,
          color: _kTextColor,
        ),
      ),
    );
  }
}
