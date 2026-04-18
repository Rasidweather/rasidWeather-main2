import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../enums/enums.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/utils.dart';
import '../../../../views/base/weather_container.dart';
import 'forecast_meta_info.dart';

// TODO(mohamedSleem): not used yet.
class ForecastVisibility extends StatelessWidget {
  const ForecastVisibility({super.key, this.currentView = false, this.visibility});

  final double? visibility;
  final bool currentView;

  @override
  Widget build(BuildContext context) {
    return WeatherContainer(
      color: Colors.white,
      content: Column(
        children: <Widget>[
          ListTile(
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
              Card(
                elevation: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xffD1495B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ImageView.svgAsset(Assets.svgHumidity, width: 10),
                ),
              ),
              ForecastMetaInfo(
                currentView: currentView,
                label: 'visibility',
                value: getDistance(visibility),
                unit: const Units().distance.getText,
              ),
            ]),
          ),
          ListTile(
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'الرطوبة',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: const Color(0xff3D3C3C),
              ),
            ),
            subtitle: Row(
              children: <Widget>[
                Text(
                  'نسبة الرطوبة المتوقعة',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10.sp,
                    color: const Color(0xff3D3C3C),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
