import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../subscriptions/entitlement_utils.dart';
import '../../subscriptions/purchases_error_utils.dart';
import '../components/native_dialog.dart';
import '../components/top_bar.dart';
import '../model/singletons_data.dart';
import '../model/styles.dart';
import '../model/weather_data.dart';
import 'paywall.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool _isLoading = false;

  /*
    We should check if we can magically change the weather 
    (subscription active) and if not, display the paywall.
  */
  // void perfomMagic() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   CustomerInfo customerInfo = await Purchases.getCustomerInfo();
  //
  //   if (customerInfo.entitlements.all[entitlementID] != null &&
  //       customerInfo.entitlements.all[entitlementID]?.isActive == true) {
  //     appData.currentData = WeatherData.generateData();
  //
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } else {
  //     Offerings? offerings;
  //     try {
  //       offerings = await Purchases.getOfferings();
  //     } on PlatformException catch (e) {
  //       await showDialog(
  //           context: context,
  //           builder: (BuildContext context) => ShowDialogToDismiss(
  //               title: "Error",
  //               content: e.message ?? "Unknown error",
  //               buttonText: 'OK'));
  //     }
  //
  //     setState(() {
  //       _isLoading = false;
  //     });
  //
  //     if (offerings == null || offerings.current == null) {
  //       // offerings are empty, show a message to your user
  //     } else {
  //       // current offering is available, show paywall
  //       await showModalBottomSheet(
  //         useRootNavigator: true,
  //         isDismissible: true,
  //         isScrollControlled: true,
  //         backgroundColor: kColorBackground,
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  //         ),
  //         context: context,
  //         builder: (BuildContext context) {
  //           return StatefulBuilder(
  //               builder: (BuildContext context, StateSetter setModalState) {
  //             return Paywall(
  //               offering: offerings!.current!,
  //             );
  //           });
  //         },
  //       );
  //     }
  //   }
  // }
  Future<void> performMagic() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      try {
        // 1) فحص الاشتراك عبر RevenueCat
        final bool isPro = await isEntitled();
        if (isPro) {
          // 2) المستخدم فعّال: اشتغل عالبيانات مباشرة
          appData.currentData = WeatherData.generateData();
          if (!mounted) return;
          setState(() => _isLoading = false);
          return;
        }
      } on PlatformException catch (e) {
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => ShowDialogToDismiss(
            title: 'Error getting customer',
            content: e.message ?? 'Unknown error',
            buttonText: 'OK',
          ),
        );
        return; // ما نكمل
      }

      // 3) المستخدم مش مشترك: نجيب العروض
      Offerings? offerings;
      try {
        offerings = await Purchases.getOfferings();
      } on PlatformException catch (e) {
        if (!mounted) return;
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

      if (!mounted) return;
      // نطفّي اللودينغ قبل إظهار الـbottom sheet
      setState(() => _isLoading = false);

      // 4) تحقق من توفر الـoffering
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

      // 5) اعرض الباي وول
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

      // 6) (اختياري) بعد ما يُغلق الباي وول، حدّث الحالة
      if (!mounted) return;
      final bool nowPro = await isEntitled();
      if (nowPro) {
        appData.currentData = WeatherData.generateData();
        if (!mounted) return;
        setState(() {});
      }
    } finally {
      if (mounted) {
        // تأكد دومًا نطفي اللودينغ حتى لو صار خطأ
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return TopBar(
        text: '✨ Magic Weather',
        style: kTitleTextStyle,
        uniqueHeroTag: 'weather',
        child: Scaffold(
          backgroundColor: appData.currentData.weatherColor,
          body: ModalProgressHUD(
            inAsyncCall: _isLoading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: TextButton(
                    onPressed: () => performMagic(),
                    child: Text(
                      '✨ Change the Weather',
                      style: kDescriptionTextStyle.copyWith(
                          fontSize: kFontSizeMedium,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
