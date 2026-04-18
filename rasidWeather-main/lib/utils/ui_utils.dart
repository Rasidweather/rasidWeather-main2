import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/constants/index.dart';
import '../core/services/dialog_service.dart';
import '../data/model/base/dialog_models.dart';
import '../helper/router_helper.dart';
import '../locator.dart';

enum SnackDuration { short, medium, long }

DialogService _dialogService = sl<DialogService>();

extension MaterialExt on Object {
  Future<String?> openSignInDialog() async {
    final DialogResponse result = await _dialogService.showConfirmationDialog(
        title: 'common.no_sign_in'.tr(), description: 'common.no_sign_in_message'.tr(), confirmationTitle: 'common.sign_in'.tr(), cancelTitle: 'common.cancel'.tr());
    if (result.confirmed!) {
      return RouterHelper.getLoginRoute(action: RouteAction.popAndPush);
    }
    return null;
  }

  Future<void> showBottomSheetWidget({required BuildContext context, required Widget child}) async {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => child,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 35, maxWidth: MediaQuery.of(context).size.width),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        isScrollControlled: true);
  }

  void showSnackBar(BuildContext context, String message,
      {SnackBarAction? action, SnackDuration duration = SnackDuration.medium, Color color = Colors.teal}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.zero,
        dismissDirection: DismissDirection.horizontal,
        duration: duration == SnackDuration.short
            ? const Duration(seconds: 1)
            : duration == SnackDuration.medium
                ? const Duration(seconds: 2)
                : const Duration(seconds: 5),
        action: action,
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }

  void printLog(String s, {String? file, String? className, bool view = true}) {
    final String appName = AppStrings.appName.toUpperCase();
    if (view && kDebugMode) {
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
  Color convertHexaToColor(String hexColorCode) {
    try {
      String hexColor = hexColorCode.replaceAll('#', '').toUpperCase();
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      if (hexColor.length != 8) {
        return const Color(0xFFFFFFFF);
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return const Color(0xFFFFFFFF);
    }
  }

  void navigateDialog({required BuildContext context, required Widget child}) {
    Navigator.of(context).push(PageRouteBuilder<Widget>(
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          const Offset begin = Offset(0.0, 1.0);
          const Offset end = Offset.zero;
          const Cubic curve = Curves.ease;
          final Animatable<Offset> tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierColor: Colors.black45,
        pageBuilder: (BuildContext context, _, __) {
          return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              child: child);
        },
        opaque: false));
  }
}
