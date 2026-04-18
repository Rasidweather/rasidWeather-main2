// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../../common/constants/index.dart';
// import '../../../../../core/widgets/image_widget.dart';
// import '../../../../../generated/assets.dart';
// import '../../../../../theme/theme_model.dart';
// import '../../../../../utils/utils.dart';
// import '../../../data/models/weather_model.dart';
// import 'hourly_item.dart';
//
// /// A widget that displays sunset information in the hourly weather forecast.
// ///
// /// This widget shows the sunset time along with an icon and related weather details.
// /// It's typically displayed at the hour when sunset occurs to help users identify
// /// the transition from day to night in the weather timeline.
// class SunsetForecastItem extends StatelessWidget {
//   /// Creates a sunset forecast display widget.
//   ///
//   /// Requires [hour] parameter containing the weather data for the sunset hour.
//   const SunsetForecastItem({
//     super.key,
//     required this.hour,
//     this.appearance,
//   });
//
//   /// The weather data for the sunset hour
//   final Hour hour;
//
//   /// The appearance configuration for styling
//   final Appearance? appearance;
//
//   /// Constants for styling and layout
//   static const double _kPadding = 8.0;
//   static const double _kIconSize = 40.0;
//   static const double _kVerticalSpacing = 5.0;
//   static const double _kTextSize = 14.22;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         _buildSunsetInfo(context),
//         _buildHourlyWeather(),
//       ],
//     );
//   }
//
//   /// Builds the sunset information column with icon and time
//   Widget _buildSunsetInfo(BuildContext context) {
//     final TextStyle infoStyle = Theme.of(context).textTheme.headlineSmall!.copyWith(
//           fontSize: _kTextSize.sp,
//           fontWeight: FontWeight.w400,
//           color: AppTheme.getFadedTextColor(colorTheme: true),
//         );
//
//     return Padding(
//       padding: const EdgeInsets.all(_kPadding),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           _buildSunsetIcon(),
//           _buildSunsetLabel(infoStyle),
//           const SizedBox(height: _kVerticalSpacing),
//           _buildSunsetTime(infoStyle),
//         ],
//       ),
//     );
//   }
//
//   /// Builds the sunset icon
//   Widget _buildSunsetIcon() {
//     return ImageView.svgAsset(
//       Assets.svgS,
//       width: _kIconSize,
//       color: Colors.white,
//     );
//   }
//
//   /// Builds the "غروب الشمس" (Sunset) label
//   Widget _buildSunsetLabel(TextStyle style) {
//     return Text(
//       'weather.sunset'.tr(),
//       style: style,
//     );
//   }
//
//   /// Builds the sunset time display
//   Widget _buildSunsetTime(TextStyle style) {
//     return Text(
//       formatDateTime(hour.forecastStart!, format: 'hh:mm a')!,
//       style: style,
//     );
//   }
//
//   /// Builds the hourly weather information widget
//   Widget _buildHourlyWeather() {
//     return Padding(
//       padding: EdgeInsets.all(_kPadding.sp),
//       child: HourlyItem(
//         hour: hour,
//         appearance: appearance,
//       ),
//     );
//   }
// }
