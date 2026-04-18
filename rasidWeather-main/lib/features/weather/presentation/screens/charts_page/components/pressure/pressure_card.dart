import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/core.dart';
import '../../../../../../../enums/pressure_unit.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../views/base/weather_container.dart';
import '../../../../../data/models/weather_model.dart';
import '../../../../cubit/weather_cubit.dart';
import '../../../../widgets/forecast_display.dart';
import '../more_widget.dart';
import 'pressure_details_sheet.dart';
import 'pressure_gauge.dart';

class PressureCard extends StatelessWidget {
  const PressureCard({super.key, required this.day});

  final Day day;

  @override
  Widget build(BuildContext context) {
    final WeatherState state = context.watch<WeatherCubit>().state;

    // get Day hours only
    final List<Hour> hours = state.hours!.where((Hour hour) => hour.forecastStart!.day == day.forecastStart!.day).toList();

    return WeatherContainer(
      radius: 25,
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      padding: EdgeInsets.zero,
      content: GestureDetector(
        onTap: () => navigateDialog(context: context, child: PressureDetailsSheet(hours: hours)),
        child: Column(
          children: <Widget>[
            // Header with pressure value
            if (hours.isNotEmpty) _buildHeader(hours.first) else const Text('No data available'),

            // Title and subtitle
            _buildTitleSection(context),

            // "More" button with arrow
            const MoreWidget(),

            // Pressure chart visualization
            if (hours.isNotEmpty) PressureGauge(hours: hours) else SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Text(
                        'weather.noData'.tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Hour hour) {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2),
      minLeadingWidth: 0,
      title: Row(
        children: <Widget>[
          // Pressure icon with background
          _buildPressureIcon(),

          const Spacer(),

          // Current pressure value
          ForecastDisplay(
            row: false,
            value: hour.pressure!.round().toString(),
            unit: PressureUnit.hpa.name,
            unitSizeFactor: 1.6,
            style: TextStyle(
              fontSize: 22.sp,
              height: 1,
              fontWeight: FontWeight.w500,
              color: const Color(0xff3D3C3C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPressureIcon() {
    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(6),
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: const Color(0xff76C893),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ImageView.svgAsset(
          Assets.svgPressure,
          width: 10,
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      visualDensity: const VisualDensity(vertical: -4),
      title: Text(
        'weather.charts.pressure.title'.tr(),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xff3D3C3C),
        ),
      ),
      subtitle: Text(
        'weather.charts.pressure.subtitle'.tr(),
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xff3D3C3C).withOpacity(.75),
        ),
      ),
    );
  }


}
