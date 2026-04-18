import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/core.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../views/base/weather_container.dart';
import '../../../../../data/models/weather_model.dart';
import '../../../../widgets/forecast_display.dart';
import '../../../../widgets/forecast_meta_info.dart';
import '../../weather_hour_header.dart';
import 'cloud_cover_chart.dart';

class CloudyDialog extends StatelessWidget {
  const CloudyDialog({super.key, required this.hours});

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
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        content: Column(
          children: <Widget>[
            // Draggable handle for dismissing dialog
            _buildDragHandle(context),

            // Cloud cover information section
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 2),
              minLeadingWidth: 0,
              title: Row(
                children: <Widget>[
                  Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffD1495B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ImageView.svgAsset(
                        Assets.svgHumidity,
                        width: 10,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'weather.charts.clouds.title'.tr(),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff3D3C3C),
                    ),
                  ),
                  const Spacer(),
                  ForecastDisplay(
                    value: hours.first.cloudCover!.toString().removeZeroLeftDecimalPercentage(),
                    unit: '%',
                    unitSizeFactor: 1.6,
                    style: TextStyle(
                      fontSize: 20.sp,
                      height: 1,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff3D3C3C),
                    ),
                  ),
                ],
              ),
            ),
            _buildCloudCoverInfo(length),

            // Cloud cover chart visualization
            CloudCoverChart(hours: hours, isDialog: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return GestureDetector(
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
    );
  }

  Widget _buildCloudCoverInfo(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(width: 20.w),
        ...List<Widget>.generate(length, (int index) {
          return WeatherHourHeader(
            hour: hours[index],
            color: Colors.black,
            value: ForecastMetaInfo(
              label: 'cloudCover',
              valueStyle: TextStyle(
                fontSize: 12.sp,
              ),
              value: hours[index].cloudCover!.toString().convertToPercentage(),
              unit: '',
            ),
          );
        }),
      ],
    );
  }
}
