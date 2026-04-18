// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:rasid_weather/constant.dart';
// import 'package:rasid_weather/src/app.dart';
// import 'package:rasid_weather/store_config.dart';
//
//
// void main() async {
//   if (kIsWeb) {
//     StoreConfig(
//       store: Store.rcBilling,
//       apiKey: webApiKey,
//     );
//   } else if (Platform.isIOS || Platform.isMacOS) {
//     StoreConfig(
//       store: Store.appStore,
//       apiKey: appleApiKey,
//     );
//   } else if (Platform.isAndroid) {
//     // Run the app passing --dart-define=AMAZON=true
//     const useAmazon = bool.fromEnvironment("amazon");
//     StoreConfig(
//       store: useAmazon ? Store.amazon : Store.playStore,
//       apiKey: useAmazon ? amazonApiKey : googleApiKey,
//     );
//   }
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await configureRevenueCat();
//
//   runApp(const MagicWeatherFlutter());
// }
//
// Future<void> configureRevenueCat() async {
//   await Purchases.setLogLevel(LogLevel.debug);
//
//   late PurchasesConfiguration configuration;
//
//   if (StoreConfig.isForAmazonAppstore()) {
//     // لو بتستهدف Amazon واستخدمت purchases_flutter بإصدار يدعم AmazonConfiguration
//     configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
//       ..appUserID = null        // أو حط userId تبعك
//       ..observerMode = false;   // خلّي SDK يكمّل المعاملات تلقائياً
//   } else {
//     configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
//       ..appUserID = null
//       ..observerMode = false;
//   }
//
//   await Purchases.configure(configuration);
// }
//
