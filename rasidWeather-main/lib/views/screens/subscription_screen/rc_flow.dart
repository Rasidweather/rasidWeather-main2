import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../src/components/native_dialog.dart';
import '../../../src/model/singletons_data.dart';
import '../../../src/model/styles.dart';
import '../../../src/model/weather_data.dart';
import '../../../src/views/paywall.dart';
import '../../../subscriptions/entitlement_utils.dart';
import '../../../subscriptions/purchases_error_utils.dart';

class RevenueCatFlow {
  static Future<void> performMagic(
      BuildContext context, {
        required ValueChanged<bool> setLoading,
      }) async {
    setLoading(true);

    try {
      try {
        // 1) فحص الاشتراك عبر RevenueCat
        final bool isPro = await isEntitled();
        if (isPro) {
          // 2) فعّال
          appData.currentData = WeatherData.generateData();
          setLoading(false);
          return;
        }
      } on PlatformException catch (e) {
        await showDialog(
          context: context,
          builder: (_) => ShowDialogToDismiss(
            title: 'Error getting customer',
            content: e.message ?? 'Unknown error',
            buttonText: 'OK',
          ),
        );
        return;
      }

      // 3) العروض
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        final String? msg = billingDeveloperMessage(e);
        await showDialog(
          context: context,
          builder: (_) => ShowDialogToDismiss(
            title: 'Billing Error',
            content: msg ??
                e.message ??
                'Purchases not available. Make sure the app is installed from Google Play and products are active.',
            buttonText: 'OK',
          ),
        );
        if (!Platform.isAndroid) {
          return;
        }
      }

      // نوقف اللودينغ قبل عرض الـ bottom sheet
      setLoading(false);

      final Offering? current = offerings?.current;
      final bool hasPackages =
          current != null && current.availablePackages.isNotEmpty;

      if (!Platform.isAndroid && !hasPackages) {
        await showDialog(
          context: context,
          builder: (_) => const ShowDialogToDismiss(
            title: 'Purchases unavailable',
            content:
            'We couldn’t load products. Install from Play Store with a tester account and ensure products are active.',
            buttonText: 'OK',
          ),
        );
        return;
      }

      // 4) اعرض الباي وول
      await showModalBottomSheet(
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: kColorBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (_) => Paywall(offering: current),
      );

      // 5) حدّث بعد الإغلاق
      final bool nowPro = await isEntitled();
      if (nowPro) {
        appData.currentData = WeatherData.generateData();
      }
    } finally {
      setLoading(false);
    }
  }
}
