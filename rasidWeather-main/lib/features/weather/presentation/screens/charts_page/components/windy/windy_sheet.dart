import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/widgets/image_widget.dart';
import '../../../../../../../enums/wind_speed_unit.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../utils/forecast_utils.dart';
import '../../../../../../../views/base/tooltip_widget.dart';
import '../../../../../../../views/base/weather_container.dart';
import '../../../../../data/models/weather_model.dart';
import '../../../../widgets/forecast_meta_info.dart';
import '../../weather_hour_header.dart';
import 'windy_charts_widget.dart';

class WindyDialog extends StatelessWidget {
  const WindyDialog({super.key, required this.hours});

  final List<Hour> hours;

  @override
  Widget build(BuildContext context) {
    final int length = hours.length < 7 ? hours.length : 7;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2,
      child: WeatherContainer(
        radius: 25,
        color: Colors.white,
        padding: EdgeInsets.zero,
        // margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        content: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.h,
                  horizontal: MediaQuery.sizeOf(context).width / 2.7,
                ),
                child: Container(
                  height: 4.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 2),
              minLeadingWidth: 0,
              title: Row(
                children: <Widget>[
                  SizedBox(
                    height: 30.w,
                    width: 30.w,
                    child: ImageView.svgAsset(
                      Assets.svgWindContainer,
                      width: 50.w,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'weather.charts.wind.title'.tr(),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff3D3C3C),
                    ),
                  ),
                  const Spacer(),
                  ForecastMetaInfo(
                    label: 'wind',
                    value: getWindSpeed(hours.first.windSpeed).toString(),
                    unit: WindSpeedUnit.kmh.getText(context),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ...List<Widget>.generate(length, (int index) {
                  return WeatherHourHeader(
                    hour: hours[index],
                    color: Colors.black,
                    icon: ViewTooltip(
                      message: hours[index].windDirectionText.toString(),
                      backgroundColor: Theme.of(context).primaryColor,
                      offset: Offset(-30.w, -40.h),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: ImageView.svgAsset(Assets.svgWindDirection, rotate: hours[index].windDirection! + 90.0),
                      ),
                    ),
                    value: Row(
                      children: <Widget>[
                        Text(
                          getWindSpeed(hours[index].windSpeed).toString(),
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'weather.charts.wind.separator'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          getWindSpeed(hours[index].windGust).toString(),
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            WindyChartsWidget(hours: hours, isDialog: true),
          ],
        ),
      ),
    );
  }
}
