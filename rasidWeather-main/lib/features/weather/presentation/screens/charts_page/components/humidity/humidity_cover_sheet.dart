import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/widgets/image_widget.dart';
import '../../../../../../../generated/assets.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../../../views/base/weather_container.dart';
import '../../../../../data/models/weather_model.dart';
import '../../../../widgets/forecast_meta_info.dart';
import '../../weather_hour_header.dart';
import 'humidity_cover_chart.dart';

/// A dialog that displays detailed humidity information and charts.
/// 
/// Shows hourly humidity data with an interactive chart and detailed information
/// for each hour. Includes a draggable handle for easy dismissal.
class HumidityCoverDialog extends StatelessWidget {
  /// Creates a humidity dialog.
  /// 
  /// Requires [day] parameter containing the weather data to display.
  const HumidityCoverDialog({
    super.key, 
    required this.hours
  });

  /// Weather data model containing humidity information
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
            
            // Header with icon and title
            _buildHeader(),
            
            // Hourly humidity information
            _buildHourlyInfo(length),
            
            // Humidity chart
            HumidityCoverChart(hours: hours, isDialog: true),
          ],
        ),
      ),
    );
  }

  /// Builds the draggable handle at the top of the dialog
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

  /// Builds the header section with icon, title and current value
  Widget _buildHeader() {
    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 2),
      minLeadingWidth: 0,
      title: Row(
        children: <Widget>[
          // Humidity icon with background
          _buildHumidityIcon(),
          
          const Spacer(),
          
          // Title text
          Text(
            'weather.charts.humidity.title'.tr(),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff3D3C3C),
            ),
          ),
          
          const Spacer(),
          
          // Current humidity value
          ForecastMetaInfo(
            label: 'humidity',
            valueStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.sp,
            ),
            value: hours.first.humidity!.toString().convertToPercentage(),
            unit: '',
          ),
        ],
      ),
    );
  }

  /// Builds the humidity icon with background
  Widget _buildHumidityIcon() {
    return Card(
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
    );
  }

  /// Builds the hourly humidity information section
  Widget _buildHourlyInfo(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(width: 20.w),
        ...List<Widget>.generate(length, (int index) {
          return WeatherHourHeader(
            hour: hours[index],
            color: Colors.black,
            value: ForecastMetaInfo(
              label: 'humidity',
              valueStyle: TextStyle(
                fontSize: 12.sp,
              ),
              value: hours[index].humidity!.toString().convertToPercentage(),
              unit: '',
            ),
          );
        }),
      ],
    );
  }
}
