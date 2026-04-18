import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/image_widget.dart';
import '../../../../../generated/assets.dart';
import '../../../../../views/base/weather_container.dart';
import '../../../data/models/weather_model.dart';
import '../../widgets/forecast_icon.dart';

/// A widget that displays detailed weather reports for both day and night periods.
///
/// This widget shows:
/// - Day time forecast with sun icon
///   - Weather conditions and descriptions
///   - Weather icons and animations
/// - Night time forecast with moon icon
///   - Weather conditions and descriptions
///   - Weather icons and animations
///
/// Each period (day/night) is displayed in a separate container with its own:
/// - Period icon (sun/moon)
/// - Weather condition icon (possibly animated)
/// - Weather condition name
/// - Detailed weather overview
class ForecastDayNightReports extends StatelessWidget {
  /// Creates a forecast day and night reports widget.
  ///
  /// Requires a [day] object containing both daytime and overnight forecasts.
  const ForecastDayNightReports({super.key, required this.day});

  /// The day containing forecast information for both periods
  final Day day;

  /// Constants for styling and layout
  static const double _kVerticalPadding = 8.0;
  static const double _kHorizontalPadding = 8.0;
  static const double _kContentPadding = 2.0;
  static const double _kContainerWidth = 0.9;
  static const double _kIconSize = 50.0;
  static const double _kImageSize = 30.0;

  /// Text styles
  static const double _kTitleFontSize = 15.0;
  static const double _kConditionFontSize = 14.0;
  static const double _kOverviewFontSize = 12.0;
  static const Color _kTextColor = Color(0xff3D3C3C);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildForecastItem(context, day.daytimeForecast!, 'weather.inDay'.tr(), Assets.svgDay),
        _buildForecastItem(context, day.overnightForecast!, 'weather.inNight'.tr(), Assets.svgNight),
      ],
    );
  }

  /// Builds a forecast item for either day or night period.
  ///
  /// [context] The build context
  /// [forecast] The forecast data for the period
  /// [title] The title of the period (day/night)
  /// [image] The image asset path for the period icon
  Widget _buildForecastItem(BuildContext context, Forecast forecast, String title, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _kVerticalPadding, horizontal: _kHorizontalPadding),
      child: WeatherContainer(
        width: MediaQuery.sizeOf(context).width * _kContainerWidth,
        color: Colors.white,
        content: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: _kContentPadding),
          leading: _buildForecastIcon(forecast),
          title: _buildTitle(title, image),
          subtitle: _buildSubtitle(forecast),
        ),
      ),
    );
  }

  /// Builds the forecast icon with animation support.
  Widget _buildForecastIcon(Forecast forecast) {
    return ForecastIcon(
      containerSize: _kIconSize.sp,
      iconSize: _kIconSize.sp,
      icon: forecast.condition!.conditionImageBlue!,
      animatedIcon: forecast.condition!.conditionIsAnimated!,
    );
  }

  /// Builds the title row with period label and icon.
  Widget _buildTitle(String title, String image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title, style: TextStyle(color: _kTextColor, fontSize: _kTitleFontSize.sp, fontWeight: FontWeight.w400)),
        ImageView.svgAsset(image, width: _kImageSize.sp),
      ],
    );
  }

  /// Builds the subtitle with condition name and overview.
  Widget _buildSubtitle(Forecast forecast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          forecast.condition!.conditionName!,
          style: TextStyle(color: _kTextColor.withOpacity(.5), fontSize: _kConditionFontSize.sp, fontWeight: FontWeight.w400),
        ),
        Text(forecast.overView!, style: TextStyle(color: _kTextColor, fontSize: _kOverviewFontSize.sp, fontWeight: FontWeight.w700)),
      ],
    );
  }
}
