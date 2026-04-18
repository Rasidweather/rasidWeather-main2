import 'package:flutter/material.dart';

import '../../main.dart';
import '../constants/app_strings.dart';

enum SnackDuration { short, medium, long }

extension materialExt on Object {
  void showSnackBar(String message,
      {SnackBarAction? action, SnackDuration duration = SnackDuration.medium, Color color = Colors.teal}) {
    try {
      final BuildContext? context = Get.context;
      if (context == null) {
        return;
      }

      // Check if the context is still mounted
      if (!context.mounted) {
        return;
      }
      
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      
      // Clear any existing snackbars to prevent overlap
      messenger.clearSnackBars();
      
      messenger.showSnackBar(
        SnackBar(
          margin: EdgeInsets.zero,
          dismissDirection: DismissDirection.horizontal,
          duration: duration == SnackDuration.short
              ? const Duration(seconds: 2)
              : duration == SnackDuration.medium
                  ? const Duration(seconds: 4)
                  : const Duration(seconds: 6),
          action: action,
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          content: Text(message),
        ),
      );
    } catch (e) {
      // If showing snackbar fails, use toast as fallback
      // showToast(message, color: color);
    }
  }

  void printLog(String s, {String? file, String? className, bool view = true}) {
    final String appName = AppStrings.appName.toUpperCase();
    if (view) {
      debugPrint('$appName---------------------$s--------------------------\n');
      if (className != null) {
        debugPrint('$appName-------------------class--$className--------------------------\n');
      }
      if (file != null) {
        debugPrint('$appName-------------------file--$file--------------------------\n');
      }
    }
  }

  // static Future<void> shareText(String text, {String? subject}) async {
  //   await Share.share(text, subject: subject);
  // }

  // convert hexadecimal to color
  Color convertHexaToColor(String hexColor) {
    try {
      String normalized = hexColor.toUpperCase().replaceAll('#', '');
      if (normalized.length == 6) {
        normalized = 'FF$normalized';
      }
      if (normalized.length != 8) {
        return const Color(0xFFFFFFFF);
      }
      return Color(int.parse(normalized, radix: 16));
    } catch (_) {
      return const Color(0xFFFFFFFF);
    }
  }

  void navigateDialog({required BuildContext context, required Widget child}) {
    Navigator.of(context).push(
      PageRouteBuilder<Dialog>(
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          const Offset begin = Offset(0.0, 1.0);
          const Offset end = Offset.zero;
          const Cubic curve = Curves.ease;
          final Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierColor: Colors.black45,
        pageBuilder: (BuildContext context, _, __) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            child: child,
          );
        },
        opaque: false,
      ),
    );
  }
}
