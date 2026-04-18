// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
//
// import '../../../../common/constants/index.dart';
// import '../../../../core/widgets/image_widget.dart';
// import '../../../../features/weather/data/models/weather_model.dart';
// import '../../../../generated/assets.dart';
// import '../../../../utils/utils.dart';
//
// /// A card widget that displays the moon's phase throughout the night.
// ///
// /// This widget shows:
// /// - A radial gauge representing the moon's position
// /// - Moonrise and moonset times
// /// - Current moon phase
// ///
// /// The widget provides visual feedback about the moon's current position
// /// and phase using a combination of gauges and icons.
// class MoonPhaseCard extends StatelessWidget {
//   /// Creates a moon phase card widget.
//   ///
//   /// Requires [day] parameter containing the daily weather data
//   /// with moon phase information.
//   const MoonPhaseCard({super.key, required this.day});
//
//   /// The daily weather data containing moon phase information
//   final Day day;
//
//   /// Constants for styling and layout
//   static const double _kGaugeHeight = 70.0;
//
//   /// Calculates the moon phase percentage.
//   ///
//   /// Returns a value between 0 and 100 representing the current phase
//   /// of the moon, or null if the required data is not available.
//   double? _calculateMoonPhase({DateTime? set, DateTime? rise}) {
//     if (rise == null || set == null) {
//       return null;
//     }
//
//     final int totalDuration = getDifferenceTimeEpoch(
//       startTime: rise,
//       endTime: set,
//     );
//     final int elapsedDuration = getDifferenceTimeEpoch(
//       startTime: day.forecastStart,
//       endTime: set,
//     );
//     final double percentage = (elapsedDuration / totalDuration) * 100;
//     final num remainingPercentage = 100 - percentage;
//
//     if (totalDuration > elapsedDuration &&
//         remainingPercentage < 100 &&
//         remainingPercentage > 0.0) {
//       return remainingPercentage.toDouble();
//     }
//     return 100.0;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double? phaseValue = _calculateMoonPhase(
//       rise: day.moon!.moonrise,
//       set: day.moon!.moonset,
//     );
//
//     return SizedBox(
//       height: _kGaugeHeight.sp,
//       child: _MoonPhaseGauge(
//         value: phaseValue,
//         day: day,
//       ),
//     );
//   }
// }
//
// /// A custom gauge widget that displays the moon's position and phase.
// class _MoonPhaseGauge extends StatelessWidget {
//   const _MoonPhaseGauge({
//     required this.value,
//     required this.day,
//   });
//
//   final double? value;
//   final Day day;
//
//   /// Constants for styling and layout
//   static const double _kRadiusFactor = 0.8;
//   static const double _kLineThickness = 0.04;
//   static const double _kPointerWidth = 0.07;
//   static const double _kPointerSize = 25.0;
//   static const double _kAnnotationSpacing = 25.0;
//   static const double _kTimeFontSize = 7.89;
//
//   @override
//   Widget build(BuildContext context) {
//     return SfRadialGauge(
//       axes: <RadialAxis>[
//         RadialAxis(
//           radiusFactor: _kRadiusFactor.sp,
//           axisLineStyle: AxisLineStyle(
//             cornerStyle: CornerStyle.bothCurve,
//             color: Colors.white.withOpacity(.3),
//             thickness: _kLineThickness,
//             thicknessUnit: GaugeSizeUnit.factor,
//           ),
//           showLabels: false,
//           showTicks: false,
//           startAngle: 180,
//           endAngle: 0,
//           pointers: <GaugePointer>[
//             _buildRangePointer(),
//             _buildMoonPointer(),
//           ],
//           annotations: _buildTimeAnnotations(),
//         ),
//       ],
//     );
//   }
//
//   /// Builds the range pointer showing progress.
//   RangePointer _buildRangePointer() {
//     return RangePointer(
//       width: _kPointerWidth,
//       value: value ?? 0,
//       cornerStyle: CornerStyle.bothCurve,
//       color: Colors.white.withOpacity(.8),
//       sizeUnit: GaugeSizeUnit.factor,
//     );
//   }
//
//   /// Builds the moon pointer showing current phase.
//   WidgetPointer _buildMoonPointer() {
//     return WidgetPointer(
//       enableDragging: true,
//       value: value ?? 0,
//       child: SizedBox(
//         height: _kPointerSize.h,
//         width: _kPointerSize.w,
//         child: value == 100 || value == null
//             ? ImageView.svgAsset(
//           Assets.su,
//                 color: Colors.white30,
//                 width: _kPointerSize,
//               )
//             : Center(
//                 child: ImageView.svgAsset(
//                   Assets.moon_last_quarter,
//                   width: _kPointerSize,
//                 ),
//               ),
//       ),
//     );
//   }
//
//   /// Builds the time annotations for moonrise and moonset.
//   List<GaugeAnnotation> _buildTimeAnnotations() {
//     return <GaugeAnnotation>[
//       _buildTimeAnnotation(
//         0,
//         day.moon!.moonset,
//       ),
//       _buildTimeAnnotation(
//         180,
//         day.moon!.moonrise,
//       ),
//     ];
//   }
//
//   /// Builds a single time annotation.
//   GaugeAnnotation _buildTimeAnnotation(double angle, DateTime? time) {
//     return GaugeAnnotation(
//       angle: angle,
//       positionFactor: 1,
//       widget: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           const SizedBox(height: _kAnnotationSpacing),
//           Text(
//             formatDateTime(time!,
//                   format: 'HH:mm',
//                 ) ??
//                 '00',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: _kTimeFontSize.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
