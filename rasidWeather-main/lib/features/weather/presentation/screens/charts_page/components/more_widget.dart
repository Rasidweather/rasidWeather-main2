import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/image_widget.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../main.dart';

class MoreWidget extends StatelessWidget {
  const MoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'common.more'.tr(),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff2BB0DD),
              ),
            ),
            SizedBox(width: 5.w),
            ImageView.svgAsset(
              Assets.svgArrowRight,
              color: const Color(0xff2BB0DD),
              width: 13.w,
              rotate: Get.context?.locale.languageCode == 'en' ? 180 : 0,
            ),
          ],
        ),
      );
  }
}
