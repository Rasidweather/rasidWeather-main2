import 'package:flutter/services.dart';

String? billingDeveloperMessage(PlatformException e) {
  final String code = e.code;
  if (code == 'PurchaseNotAllowedError' ||
      code == 'BILLING_UNAVAILABLE' ||
      code == 'ProductNotAvailable') {
    return 'Google Play Billing غير متاح. ثبّت التطبيق من Play Store (Internal testing) '
        'وتأكد المنتجات Active وحسابك Tester.';
  }
  return null;
}
