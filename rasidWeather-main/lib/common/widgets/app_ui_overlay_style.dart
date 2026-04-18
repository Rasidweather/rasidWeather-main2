import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppUiOverlayStyle extends StatelessWidget {

  const AppUiOverlayStyle({super.key,
    required this.child,
    this.systemNavigationBarColor,
    this.systemNavigationBarIconBrightness,
    this.isDark = true,
  });
  final Widget child;
  final Color? systemNavigationBarColor;
  final Brightness? systemNavigationBarIconBrightness;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: !isDark ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: !isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: systemNavigationBarColor ?? Theme.of(context).appBarTheme.backgroundColor,
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness ?? (isDark
                ? Brightness.dark
                : Brightness.light),
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: child,
    );
  }
}
