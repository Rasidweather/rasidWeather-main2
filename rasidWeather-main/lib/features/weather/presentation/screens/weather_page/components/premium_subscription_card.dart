import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/widgets/image_widget.dart';
import '../../../../../../helper/router_helper.dart';
import '../../../../../../utils/ui_utils.dart';
import '../../../../../../views/base/ui_widget.dart';
import '../../../../../../views/base/weather_container.dart';
import '../../../../data/models/weather_model.dart';

@immutable
class PremiumSubscriptionCard extends StatelessWidget {
  const PremiumSubscriptionCard({super.key});

  static const double _kHorizontalMargin = 20.0;
  static const double _kVerticalMargin = 10.0;
  static const double _kPadding = 10.0;
  static const double _kTitleFontSize = 18.0;
  static const double _kDescriptionFontSize = 15.0;
  static const double _kButtonFontSize = 15.0;
  static const double _kIllustrationWidth = 130.0;
  static const Offset _kTitleShadowOffset = Offset(-2, -2);

  static const EdgeInsets _containerMargin = EdgeInsets.symmetric(
      horizontal: _kHorizontalMargin, vertical: _kVerticalMargin);
  static const EdgeInsets _containerPadding = EdgeInsets.all(_kPadding);
  static final SizedBox _verticalSpacer = SizedBox(height: 10.h);

  static const List<Shadow> _titleShadows = <Shadow>[
    Shadow(offset: _kTitleShadowOffset)
  ];

  @override
  Widget build(BuildContext context) {
    return WeatherContainer(
      margin: _containerMargin,
      padding: _containerPadding,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildTextSection(context),
          ImageView.asset('assets/subscribe-cover.png',
              width: _kIllustrationWidth.w),
        ],
      ),
    );
  }

  Widget _buildTextSection(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'subscription.premium'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: _kTitleFontSize.sp,
            shadows: _titleShadows,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'subscription.premium_description'.tr(),
          style: TextStyle(
            fontSize: _kDescriptionFontSize.sp,
            color: Colors.white,
          ),
        ),
        _verticalSpacer,
        _buildSubscribeButton(context),
      ],
    );
  }

  Widget _buildSubscribeButton(BuildContext context) {
    return UiWidget(
      child: (Appearance ui) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: convertHexaToColor(ui.background!.first),
          minimumSize: Size(130.w, 40.h),
        ),
        onPressed: () => RouterHelper.getSubscriptionIntroRoute(),
        child: Text(
          'subscription.subscribe_now'.tr(),
          style: TextStyle(
            fontSize: _kButtonFontSize.sp,
            color: convertHexaToColor(ui.buttonColor!),
          ),
        ),
      ),
    );
  }
}
