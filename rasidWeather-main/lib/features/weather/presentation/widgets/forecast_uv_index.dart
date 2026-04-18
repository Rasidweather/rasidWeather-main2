// import 'package:flutter/material.dart';
// import 'package:rasid_weather/utils/utils.dart';
//
// import '../../../../common/constants/images.dart';
// import '../../../../core/core.dart';
// import '../../../../views/base/weather_container.dart';
// import 'forecast_meta_info.dart';
//
// // TODO(mohamedSleem): not used yet.
// class ForecastUVIndex extends StatelessWidget {
//   const ForecastUVIndex({super.key, required this.currentView, this.uvi});
//
//   final int? uvi;
//   final bool currentView;
//
//   @override
//   Widget build(BuildContext context) {
//     return WeatherContainer(
//       color: Colors.white,
//       content: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: 30.0, width: 30.0, child: ImageView.svgAsset(Assets.day)),
//           ForecastMetaInfo(
//             currentView: currentView,
//             label: 'uv-index',
//             value: (uvi == null) ? '0' : (uvi ?? 0).toDouble().formatDecimal().toString(),
//             unit: '', // TODO(mohamedSleem): getUnitSymbol,
//           ),
//         ],
//       ),
//     );
//   }
// }
