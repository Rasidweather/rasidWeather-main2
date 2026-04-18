import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/core.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../utils/forecast_utils.dart';
import '../../../../../../../views/base/weather_container.dart';
import '../../../../../data/models/weather_model.dart';
import '../../../../cubit/weather_cubit.dart';
import '../../../../widgets/forecast_display.dart';
import '../more_widget.dart';
import 'temperature_details_sheet.dart';
import 'temperature_gauge.dart';

/// A card widget that displays temperature information.
///
/// Features:
/// - Current temperature display with icon
/// - Temperature range indicators
/// - Interactive gauge visualization
/// - Tap to show detailed information
class TemperatureCard extends StatelessWidget {
  /// Creates a temperature card widget.
  ///
  /// * [day] - Weather data model containing temperature information
  const TemperatureCard({super.key, required this.day});

  /// Weather data model containing temperature measurements
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
        onTap: () => navigateDialog(context: context, child: TemperatureDetailsSheet(hours: hours)),
        child: Column(
          children: <Widget>[
            // Header with temperature info
            _buildHeader(),

            // Temperature range section
            _buildTemperatureRange(),

            // "More" link
            const MoreWidget(),

            // Temperature gauge visualization
            TemperatureGauge(hours: hours),
          ],
        ),
      ),
    );
  }

  /// Builds the header section with temperature icon and current temperature
  Widget _buildHeader() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      minLeadingWidth: 0,
      title: Row(
        children: <Widget>[
          // Temperature icon with background
          _buildTemperatureIcon(),

          const Spacer(),

          // Current temperature display
          ForecastDisplay(
            value: getTemperature(day.temperatureMax).toString(),
            unit: 'weather.charts.temperature.celsius'.tr(),
            unitSizeFactor: 1.6,
            unitAlignment: Alignment.topCenter,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff3D3C3C),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the temperature icon with blue background
  Widget _buildTemperatureIcon() {
    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(6),
        width: 30.w,
        height: 30.w,
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

  /// Builds the temperature range section with min and max values
  Widget _buildTemperatureRange() {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
      visualDensity: const VisualDensity(vertical: -4),
      title: Row(
        children: <Widget>[
          // Maximum temperature
          ForecastDisplay(
            value: getTemperature(day.temperatureMax).toString(),
            unit: 'weather.charts.temperature.celsius'.tr(),
            unitSizeFactor: 1.6,
            unitAlignment: Alignment.topCenter,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff3D3C3C),
            ),
          ),

          Text(
            ' / ',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff3D3C3C),
            ),
          ),

          // Minimum temperature
          ForecastDisplay(
            value: getTemperature(day.temperatureMin).toString(),
            unit: 'weather.charts.temperature.celsius'.tr(),
            unitSizeFactor: 1.6,
            unitAlignment: Alignment.topCenter,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff3D3C3C),
            ),
          ),
        ],
      ),
      subtitle: Text(
        'weather.charts.temperature.title'.tr(),
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xff3D3C3C).withOpacity(.75),
        ),
      ),
    );
  }
}
