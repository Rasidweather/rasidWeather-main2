import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/app_web_view.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWebView(
      url: 'https://rasidweather.com/contact',
      title: 'profile.contact_us'.tr(),
    );
  }
}
