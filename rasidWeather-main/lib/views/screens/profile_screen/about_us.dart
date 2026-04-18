import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/app_web_view.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the new AppWebView component with the about us URL
    return AppWebView(
      url: 'https://rasidweather.com/page/about',
      title: 'profile.about_us'.tr(),
    );
  }
}
