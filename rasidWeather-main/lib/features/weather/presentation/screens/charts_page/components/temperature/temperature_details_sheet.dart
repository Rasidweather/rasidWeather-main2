import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../bloc/app_cubit/app_cubit.dart';
import '../../../../../../../core/widgets/image_widget.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../utils/forecast_utils.dart';
import '../../../../../../../views/base/weather_container.dart';
import '../../../../../data/models/weather_model.dart';
import '../../../../widgets/forecast_icon.dart';
import '../../../../widgets/forecast_meta_info.dart';
import '../../weather_hour_header.dart';
import 'temperature_gauge.dart';

class TemperatureDetailsSheet extends StatelessWidget {
  const TemperatureDetailsSheet({super.key, required this.hours});

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
            // Draggable handle for dismissing sheet
            _buildDragHandle(context),

            // Header with icon and title
            _buildHeader(),

            // Hourly temperature information
            _buildHourlyInfo(length),

            // Temperature gauge visualization
            TemperatureGauge(hours: hours, isDialog: true),
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
              // Temperature icon with background
              _buildTemperatureIcon(),

              const Spacer(),

              // Title text
              Text(
                'weather.charts.temperature.title'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Temperature display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ForecastMetaInfo(
                    label: 'weather.charts.temperature.title',
                    valueStyle: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    value: getTemperature(hours[index].temperature).toString(),
                    unit: 'weather.charts.temperature.celsius'.tr(),
                  ),
                ],
              ),

              const Spacer(),

              // Current temperature value
              Row(
                children: <Widget>[
                  ForecastMetaInfo(
                    label: 'temperature',
                    valueStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    value: getTemperature(hours[index].temperature).toString(),
                    unit: '°',
                  ),
                  Text(
                    'weather.temperature.details.separator'.tr(),
                    style: TextStyle(fontSize: 22.sp, color: Colors.grey[500]),
                  ),
                  ForecastMetaInfo(
                    label: 'temperature apparent',
                    valueStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                    value: getTemperature(hours[index].temperatureApparent).toString(),
                    unit: '°',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTemperatureIcon() {
    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(6),
        width: 35.w,
        height: 35.w,
        decoration: BoxDecoration(
          color: const Color(0xffDD1C1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ImageView.svgAsset(
          Assets.svgTempContainer,
          width: 10,
        ),
      ),
    );
  }

  Widget _buildHourlyInfo(int length) {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (BuildContext context, AppStates state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ...List<Widget>.generate(length, (int index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.read<AppCubit>().changePressure(index),
                  child: Row(
                    children: <Widget>[
                      WeatherHourHeader(
                        hour: hours[index],
                        icon: ForecastIcon(
                          containerSize: 28.sp,
                          iconSize: 25.sp,
                          icon: hours[index].condition!.conditionImageBlue!,
                          animatedIcon: hours[index].condition!.conditionIsAnimated!,
                        ),
                        color: Colors.black,
                        value: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ForecastMetaInfo(
                              label: 'temperature',
                              valueStyle: TextStyle(
                                fontSize: 12.sp,
                              ),
                              value: getTemperature(hours[index].temperature).toString(),
                              unit: '',
                            ),
                            Text(
                              'weather.temperature.details.separator'.tr(),
                              style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                            ),
                            ForecastMetaInfo(
                              label: 'temperature',
                              valueStyle: TextStyle(
                                fontSize: 12.sp,
                              ),
                              value: getTemperature(hours[index].temperatureApparent).toString(),
                              unit: '',
                            ),
                          ],
                        ),
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
