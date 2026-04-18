import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/core.dart';
import '../../../../../../../enums/wind_speed_unit.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../utils/forecast_utils.dart';
import '../../../../../../../views/base/weather_container.dart';
import '../../../../../data/models/weather_model.dart';
import '../../../../cubit/weather_cubit.dart';
import '../../../../widgets/forecast_display.dart';
import '../more_widget.dart';
import 'windy_charts_widget.dart';
import 'windy_sheet.dart';

class WindyItem extends StatelessWidget {
  const WindyItem({super.key, required this.day});

  final Day day;

  @override
  Widget build(BuildContext context) {
    final WeatherState state = context.watch<WeatherCubit>().state;

    // get Day hours only
    final List<Hour> hours = state.hours!.where((Hour hour) => hour.forecastStart!.day == day.forecastStart!.day).toList();
    return WeatherContainer(
      radius: 25,
      color: Colors.white,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      content: GestureDetector(
        onTap: () => navigateDialog(context: context, child: WindyDialog(hours: hours)),
        child: Column(
          children: <Widget>[
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(vertical: -4),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
              minLeadingWidth: 0,
              title: Row(
                children: <Widget>[
                  SizedBox(
                    height: 30.w,
                    width: 30.w,
                    child: ImageView.svgAsset(Assets.svgWindContainer, width: 50.w),
                  ),
                  const Spacer(),
                  ForecastDisplay(
                    row: false,
                    value: getWindSpeed(day.daytimeForecast!.windSpeed).toString(),
                    unit: WindSpeedUnit.kmh.getText(context),
                    unitSizeFactor: 1.6,
                    style: TextStyle(fontSize: 22.sp, height: 1, fontWeight: FontWeight.w500, color: const Color(0xff3D3C3C)),
                  ),
                ],
              ),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              visualDensity: const VisualDensity(vertical: -4),
              title: Text(
                'weather.charts.wind.title'.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color(0xff3D3C3C)),
              ),
              subtitle: Text(
                'weather.charts.wind.subtitle'.tr(),
                style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w400, color: const Color(0xff3D3C3C).withOpacity(.75)),
              ),
            ),
            const MoreWidget(),

            WindyChartsWidget(hours: hours),
          ],
        ),
      ),
    );
  }
}
