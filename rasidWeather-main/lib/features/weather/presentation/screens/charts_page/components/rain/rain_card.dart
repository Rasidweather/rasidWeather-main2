import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/core.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../views/base/weather_container.dart';
import '../../../../../data/models/weather_model.dart';
import '../../../../cubit/weather_cubit.dart';
import '../../../../widgets/forecast_display.dart';
import '../more_widget.dart';
import 'rain_details_sheet.dart';
import 'rain_gauge.dart';

class RainCard extends StatelessWidget {
  const RainCard({super.key, required this.day});

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
        onTap: () => navigateDialog(context: context, child: RainDetailsSheet(hours: hours)),
        child: Column(children: <Widget>[
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -4),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
            minLeadingWidth: 0,
            title: Row(children: <Widget>[
              Card(
                elevation: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(color: const Color(0xff2BB0DD), borderRadius: BorderRadius.circular(12)),
                  child: ImageView.svgAsset(Assets.svgCloudRain, width: 10),
                ),
              ),
              const Spacer(),
              ForecastDisplay(
                  value: day.daytimeForecast!.precipitationChance.toString(),
                  unit: '%',
                  unitSizeFactor: 1.6,
                  unitAlignment: Alignment.bottomCenter,
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500, color: const Color(0xff3D3C3C))),
            ]),
          ),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
            visualDensity: const VisualDensity(vertical: -4),
            title: Text(
              'weather.rain.title'.tr(),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff3D3C3C),
              ),
            ),
            subtitle: Text(
              'weather.rain.subtitle'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
          ),
          const MoreWidget(),

          RainGauge(hours: hours),
        ]),
      ),
    );
  }
}
