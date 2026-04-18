import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as launch;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:url_launcher/url_launcher.dart';

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';

  String camelCase() {
    final String s = replaceAllMapped(
      RegExp(r'[A-Z]{2,}(?=[A-Z][a-z]+[0-9]*|\b)|[A-Z]?[a-z]+[0-9]*|[A-Z]|[0-9]+'),
      (Match match) => '${match[0]![0].toUpperCase()}${match[0]!.substring(1).toLowerCase()}',
    ).replaceAll(
      RegExp(r'(_|-|\s)+'),
      '',
    );

    return s[0].toLowerCase() + s.substring(1);
  }
}

extension DoubleExtension on double {
  double formatDecimal({
    int decimals = 2,
  }) =>
      double.parse(toStringAsFixed((truncateToDouble() == this) ? 0 : decimals));
}

List<Shadow> commonTextShadow({Color color = Colors.black38, double blurRadius = 1.0, double xOffset = 1.0, double yOffset = 1.0}) {
  return <Shadow>[
    Shadow(
      color: color,
      blurRadius: blurRadius,
      offset: Offset(xOffset, yOffset),
    ),
  ];
}

bool isInteger(num value) => (value is int) || (value == value.roundToDouble());

Future<void> launchURLTap(BuildContext context, String url) async {
  final ThemeData theme = Theme.of(context);
  try {
    await launch.launchUrl(
      Uri.parse(url),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(toolbarColor: theme.colorScheme.surface),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        closeButton: CustomTabsCloseButton(icon: CustomTabsCloseButtonIcons.back),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}

Future<void> launchURL(
  String url,
) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchURL(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> animatePage(
  PageController pageController, {
  num page = 0,
  int duration = 150,
  Curve curve = Curves.linear,
  int pauseMilliseconds = 0,
}) async {
  if (pauseMilliseconds > 0) {
    Future<void>.delayed(Duration(milliseconds: pauseMilliseconds)).then(
      (dynamic onValue) async => pageController.animateToPage(
        page as int,
        duration: Duration(milliseconds: duration),
        curve: curve,
      ),
    );
  } else {
    await pageController.animateToPage(
      page as int,
      duration: Duration(milliseconds: duration),
      curve: curve,
    );
  }
}

void closeKeyboard(
  BuildContext context,
) =>
    FocusScope.of(context).unfocus();

class Nullable<T> {
  Nullable(
    this._value,
  );
  final T _value;

  T get value => _value;
}
