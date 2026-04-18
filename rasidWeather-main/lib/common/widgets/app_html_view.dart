import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/utils.dart';

class AppHtmlView extends StatelessWidget {

  const AppHtmlView({super.key, required this.html});
  final String html;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      html,
      onTapUrl: (String url) async {
        if (url.contains('mailto:') || url.contains('tel:')) {
          launchUrl(Uri.parse(url));
        } else {
          launchURLTap(context, url);
        }
        return true;
      },
    );
  }
}
