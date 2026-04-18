// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import '../../common/constants/index.dart';
// import '../../views/base/ad_container.dart';
//
// class AdManager {
//   factory AdManager() => _instance;
//
//   AdManager._internal() {
//     _initialize();
//   }
//
//   static final AdManager _instance = AdManager._internal();
//
//   InterstitialAd? _interstitialAd;
//   AppOpenAd? _appOpenAd;
//   bool _isInterstitialAdReady = false;
//   bool _isAppOpenAdReady = false;
//
//   void _initialize() {
//     MobileAds.instance.initialize();
//   }
//
//   _BannerAdWidget get bannerAd => _BannerAdWidget()..adSize = AdSize.banner; // Private variable
//
//   void loadInterstitialAd() {
//     if (AppStrings.isVip || AppStrings.isVipChat) {
//       return;
//     }
//     InterstitialAd.load(
//       adUnitId: AdMobIdentifier.interstitialAdUnitId,
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           _interstitialAd = ad;
//           _isInterstitialAdReady = true;
//           print('Interstitial ad loaded.');
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print('Interstitial ad failed to load: $error');
//           _isInterstitialAdReady = false;
//         },
//       ),
//     );
//   }
//
//   void showInterstitialAd() {
//     if (AppStrings.isVip || AppStrings.isVipChat) {
//       return;
//     }
//     if (_isInterstitialAdReady && _interstitialAd != null) {
//       _interstitialAd?.show();
//       _interstitialAd = null;
//       _isInterstitialAdReady = false;
//     } else {
//       print('Interstitial ad is not ready.');
//     }
//   }
//
//   void loadAppOpenAd() {
//     if (kDebugMode) {
//       return;
//     }
//     if (AppStrings.isVip || AppStrings.isVipChat) {
//       return;
//     }
//     AppOpenAd.load(
//       adUnitId: AdMobIdentifier.appOpenAdUnitId,
//       request: const AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (AppOpenAd ad) {
//           _appOpenAd = ad;
//           _isAppOpenAdReady = true;
//           print('App open ad loaded.');
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print('App open ad failed to load: $error');
//           _isAppOpenAdReady = false;
//         },
//       ),
//     );
//   }
//
//   void showAppOpenAd() {
//     if (AppStrings.isVip || AppStrings.isVipChat) {
//       return;
//     }
//     if (_isAppOpenAdReady && _appOpenAd != null) {
//       Future<void>.delayed(const Duration(seconds: 5), () {
//         _appOpenAd?.show();
//         _appOpenAd = null;
//         _isAppOpenAdReady = false;
//       });
//     } else {
//       print('App open ad is not ready.');
//     }
//   }
//
//   void dispose() {
//     _interstitialAd?.dispose();
//     _appOpenAd?.dispose();
//   }
// }
//
// class _BannerAdWidget extends StatefulWidget {
//   late AdSize? adSize;
//
//   @override
//   State<_BannerAdWidget> createState() => _BannerAdWidgetState();
// }
//
// class _BannerAdWidgetState extends State<_BannerAdWidget> {
//   BannerAd? _bannerAd;
//   bool _bannerReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (!AppStrings.isVip && !AppStrings.isVipChat) {
//       _loadBannerAd();
//     }
//   }
//
//   void _loadBannerAd() {
//     _bannerAd = BannerAd(
//       adUnitId: AdMobIdentifier.bannerAdUnitId,
//       request: const AdRequest(
//         nonPersonalizedAds: true,
//       ),
//       size: widget.adSize!,
//       listener: BannerAdListener(
//         onAdLoaded: (_) {
//           if (mounted) setState(() => _bannerReady = true);
//         },
//         onAdFailedToLoad: (Ad ad, LoadAdError err) {
//           debugPrint('Banner ad error: ${err.message}');
//           if (mounted) setState(() => _bannerReady = false);
//           ad.dispose();
//         },
//       ),
//     )..load();
//   }
//
//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (AppStrings.isVip || AppStrings.isVipChat || !_bannerReady || _bannerAd == null) {
//       return const SizedBox.shrink();
//     }
//
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         final double adWidth = _bannerAd!.size.width.toDouble();
//         final double adHeight = _bannerAd!.size.height.toDouble();
//
//         return AdsContainer(
//           child: Center(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: constraints.maxWidth,
//                 maxHeight: adHeight,
//               ),
//               child: SizedBox(
//                 width: adWidth,
//                 height: adHeight,
//                 child: AdWidget(ad: _bannerAd!),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
