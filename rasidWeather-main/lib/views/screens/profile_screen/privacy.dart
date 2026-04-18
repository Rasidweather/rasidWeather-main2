import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/app_web_view.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWebView(
      url: 'https://rasidweather.com/page/privacy',
      title: 'profile.privacy_policy'.tr(),
    );
  }
}
