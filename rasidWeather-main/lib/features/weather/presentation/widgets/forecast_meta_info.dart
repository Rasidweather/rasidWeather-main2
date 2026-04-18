import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/utils.dart';

class ForecastMetaInfo extends StatelessWidget {
  const ForecastMetaInfo({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    this.currentView = false,
    this.valueStyle,
  });
  final String label;
  final String value;
  final String unit;
  final bool currentView;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text(
        value,
        style: valueStyle ??
            TextStyle(
              fontSize: 18.sp,
              color: currentView ? Colors.white.darken() : const Color(0xff3D3C3C).withOpacity(.75),
              fontWeight: FontWeight.bold,
              height: 1,
            ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Text(
            unit,
            style: TextStyle(
              fontSize: 12.sp,
              color: currentView ? Colors.white.darken() : const Color(0xff3D3C3C).withOpacity(.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ]);
  }
}
