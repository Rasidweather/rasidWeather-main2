import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../common/widgets/app_web_view.dart';

/// Terms and Conditions screen that displays the app's terms using WebView
class Terms extends StatelessWidget {
  /// Creates a new Terms screen
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWebView(
      url: 'https://rasidweather.com/page/terms',
      title: 'profile.terms'.tr(),
    );
  }
}
