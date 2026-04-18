import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../utils/utils.dart';

import '../../../../views/base/tooltip_widget.dart';
import '../../../../views/base/ui_widget.dart';
import '../../data/models/weather_model.dart';

class ForecastAttributesInfo extends StatelessWidget {
  const ForecastAttributesInfo({
    super.key,
    required this.icon,
    required this.value,
    required this.unit,
    required this.title,
  });

  final String icon;
  final String value;
  final String unit;
  final String title;

  @override
  Widget build(BuildContext context) {
    return UiWidget(child: (Appearance ui) {
      final Color textColor = convertHexaToColor(ui.textColor!);
      final bool isVideo = ui.type == 'video';
      return ViewTooltip(
        backgroundColor: convertHexaToColor(ui.background!.first),
        messageColor: isVideo ? Colors.black : convertHexaToColor(ui.textColor!),
        message: title,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          SizedBox(
            width: 33.sp,
            child: ImageView.svgAsset(icon, color: textColor.darken()),
          ),
          SizedBox(width: 5.sp),
          Text(
            unit,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 14.sp,
                  color: textColor.darken(),
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(width: 5.sp),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: textColor.darken(),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ]),
      );
    });
  }
}
