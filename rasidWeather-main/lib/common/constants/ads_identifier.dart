import 'dart:io';
import 'package:flutter/foundation.dart';

String androidAppId = 'ca-app-pub-3705227977301576~6928619829';
String iosAppId = 'ca-app-pub-3705227977301576~1213312613';

String _androidOpenAdId = 'ca-app-pub-3705227977301576/3439338165';
String _iosOpenAdId = 'ca-app-pub-3705227977301576/5434946119';

String _androidBannerId = 'ca-app-pub-3705227977301576/7921508653';
String _iosBannerId = 'ca-app-pub-3705227977301576/5486917005';

String _androidInterstitialId = 'ca-app-pub-3705227977301576/5567369139';
String _iosInterstitialId = 'ca-app-pub-3705227977301576/3935126216';

String _androidNativeId = 'ca-app-pub-3705227977301576/8242027450';
String _iosNativeId = 'ca-app-pub-3705227977301576/9746680811';

String _androidMrecBannerId = 'ca-app-pub-3705227977301576/2920352315';

String _iosMrecBannerId = 'ca-app-pub-3705227977301576/3644715975';

class AdMobIdentifier {
  static String get appOpenAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/9257395921'
          : 'ca-app-pub-3940256099942544/5575463023';
    }
    return Platform.isAndroid ? _androidOpenAdId : _iosOpenAdId;
  }

  static String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return Platform.isAndroid ? _androidBannerId : _iosBannerId;
  }

  static String get mrecBannerUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return Platform.isAndroid ? _androidMrecBannerId : _iosMrecBannerId;
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    return Platform.isAndroid ? _androidInterstitialId : _iosInterstitialId;
  }

  static String get nativeAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-3940256099942544/3986624511';
    }
    return Platform.isAndroid ? _androidNativeId : _iosNativeId;
  }
}

class FacebookAdIdentifier {
  static String get bannerAdId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? '2360159154188962_2566013650270177'
          : '2360159154188962_2566008670270675';
    }
    return Platform.isAndroid
        ? '2360159154188962_2566013650270177'
        : '2360159154188962_2566008670270675';
  }

  static String get interstitialAdId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? '2360159154188962_2566014413603434'
          : '2360159154188962_2566007446937464';
    }
    return Platform.isAndroid
        ? '2360159154188962_2566014413603434'
        : '2360159154188962_2566007446937464';
  }
}

class UnityAdsIdentifiers {
  static String get gameId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return '5685051';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return '5685050';
    }
    return '';
  }

  static String get bannerAdPlacementId {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? 'Banner_iOS'
        : 'Banner_Android';
  }

  static String get interstitialVideoAdPlacementId {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? 'Interstitial_iOS'
        : 'Interstitial_Android';
  }

  static String get rewardedVideoAdPlacementId {
    return defaultTargetPlatform == TargetPlatform.iOS
        ? 'Rewarded_iOS'
        : 'Rewarded_Android';
  }
}
