import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../bloc/app_cubit/app_cubit.dart';
import '../../../../../../../core/widgets/image_widget.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../views/base/weather_container.dart';
import '../../../../../data/models/weather_model.dart';
import '../../../../widgets/forecast_meta_info.dart';
import '../../weather_hour_header.dart';
import 'rain_gauge.dart';

class RainDetailsSheet extends StatelessWidget {
  const RainDetailsSheet({super.key, required this.hours});

  final List<Hour> hours;

  @override
  Widget build(BuildContext context) {
    final int length = hours.length < 6 ? hours.length : 6;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 2,
      child: WeatherContainer(
        radius: 25,
        color: Colors.white,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        content: Column(
          children: <Widget>[
            // Draggable handle for dismissing sheet
            _buildDragHandle(context),

            // Header with icon and title
            _buildHeader(),

            // Hourly precipitation information
            _buildHourlyInfo(length),

            // Precipitation gauge visualization
            RainGauge(hours: hours, isDialog: true),
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

  Widget _buildHeader() {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (BuildContext context, AppStates state) {
        final int index = state is ChangePressureState ? state.index : 0;

        return ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -4),
          contentPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 2),
          minLeadingWidth: 0,
          title: Row(
            children: <Widget>[
              // Rain icon with background
              _buildRainIcon(),

              const Spacer(),

              // Title text
              Text(
                'weather.rain.details.title'.tr(),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff3D3C3C),
                ),
              ),

              const Spacer(),

              // Current precipitation value
              Row(
                children: <Widget>[
                  ForecastMetaInfo(
                    label: 'precipitation',
                    valueStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    value: hours[index].precipitationAmount!.toString(),
                    unit: 'mm',
                  ),
                  Text(
                    'weather.rain.details.separator'.tr(),
                    style: TextStyle(fontSize: 22.sp, color: Colors.grey[500]),
                  ),
                  ForecastMetaInfo(
                    label: 'precipitation',
                    valueStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    value: hours[index].precipitationChance!.toString(),
                    unit: '%',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRainIcon() {
    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(6),
        width: 35.w,
        height: 35.w,
        decoration: BoxDecoration(
          color: const Color(0xff2BB0DD),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ImageView.svgAsset(
          Assets.svgRain,
          width: 10,
        ),
      ),
    );
  }

  Widget _buildHourlyInfo(int length) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (BuildContext context, AppStates state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ...List<Widget>.generate(length, (int index) {
              return GestureDetector(
                onTap: () => context.read<AppCubit>().changePressure(index),
                child: WeatherHourHeader(
                  hour: hours[index],
                  color: Colors.black,
                  value: Row(
                    children: <Widget>[
                      ForecastMetaInfo(
                        label: 'precipitation',
                        valueStyle: TextStyle(
                          fontSize: 10.sp,
                        ),
                        value: hours[index].precipitationAmount!.toString(),
                        unit: '',
                      ),
                      Text(
                        'weather.rain.details.separator'.tr(),
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                      ),
                      ForecastMetaInfo(
                        label: 'precipitation',
                        valueStyle: TextStyle(
                          fontSize: 10.sp,
                        ),
                        value: hours[index].precipitationChance!.toString(),
                        unit: '',
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
