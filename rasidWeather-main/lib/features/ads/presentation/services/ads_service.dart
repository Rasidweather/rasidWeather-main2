import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../common/constants/index.dart';
import '../../../../views/base/ad_container.dart';
import '../../domain/repositories/i_ads_repository.dart';

class AdsService {
  AdsService(this._adsRepository);

  final IAdsRepository _adsRepository;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  bool _isInitializing = false;
  bool _isInitialized = false;

  int _adRequestCounter = 0;
  DateTime? _lastCleanupTime;

  Future<void> initialize() async {
    debugPrint(
      'AdsService initialize - isVip: ${AppStrings.isVip}, isVipChat: ${AppStrings.isVipChat}',
    );

    if (AppStrings.isVip || AppStrings.isVipChat) return;
    if (_isInitializing || _isInitialized) return;

    _isInitializing = true;
    try {
      await _adsRepository.initialize();
      await loadAppOpenAd();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing ads: $e');
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> loadAppOpenAd() async {
    if (AppStrings.isVip || AppStrings.isVipChat) return;

    debugPrint(
      'loadAppOpenAd - isVip: ${AppStrings.isVip}, isVipChat: ${AppStrings.isVipChat}',
    );

    try {
      await _adsRepository.loadAppOpenAd();
    } catch (e) {
      debugPrint('Error loading app open ad: $e');
    }
  }

  /// ✅ بانر عادي (اللي عندك)
  Future<Widget> getBannerAd({AdSize adSize = AdSize.banner}) async {
    cleanupOldAds();

    debugPrint(
      'getBannerAd - isVip: ${AppStrings.isVip}, isVipChat: ${AppStrings.isVipChat}',
    );

    if (AppStrings.isVip || AppStrings.isVipChat) {
      return const SizedBox.shrink();
    }

    if (!_isInitialized && !_isInitializing) {
      await initialize();
    }

    try {
      final String uniqueRequestId =
          '${DateTime.now().millisecondsSinceEpoch}_${_adRequestCounter++}_banner';

      final BannerAd bannerAd = await _adsRepository.loadBannerAd(
        adSize: adSize,
      );

      return AdsContainer(
        child: FutureBuilder<void>(
          future: Future<void>.delayed(const Duration(milliseconds: 300)),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            final bool isReady =
                snapshot.connectionState == ConnectionState.done;

            return AbsorbPointer(
              absorbing: !isReady,
              child: Opacity(
                opacity: isReady ? 1.0 : 0.8,
                child: Container(
                  key: ValueKey<String>(uniqueRequestId),
                  width: bannerAd.size.width.toDouble(),
                  height: bannerAd.size.height.toDouble(),
                  alignment: Alignment.center,
                  child: AdWidget(ad: bannerAd),
                ),
              ),
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('Error loading banner ad: $e');
      return SizedBox(
        width: adSize.width.toDouble(),
        height: adSize.height.toDouble(),
      );
    }
  }

  /// ✅✅ المستطيل 300x250 (MREC) — بدون فاكتري
  Future<Widget> getMrecAd({
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) async {
    cleanupOldAds();

    debugPrint(
      'getMrecAd - isVip: ${AppStrings.isVip}, isVipChat: ${AppStrings.isVipChat}',
    );

    if (AppStrings.isVip || AppStrings.isVipChat) {
      return const SizedBox.shrink();
    }

    if (!_isInitialized && !_isInitializing) {
      await initialize();
    }

    try {
      final String uniqueRequestId =
          '${DateTime.now().millisecondsSinceEpoch}_${_adRequestCounter++}_mrec';

      final BannerAd bannerAd = await _adsRepository.loadBannerAd(
        adSize: AdSize.mediumRectangle, // ✅ 300x250
      );

      return AdsContainer(
        child: Container(
          key: ValueKey<String>(uniqueRequestId),
          width: bannerAd.size.width.toDouble(),   // 300
          height: bannerAd.size.height.toDouble(), // 250
          padding: padding,
          alignment: Alignment.center,
          child: AdWidget(ad: bannerAd),
        ),
      );
    } catch (e) {
      debugPrint('Error loading MREC: $e');
      return const SizedBox(width: 300, height: 250);
    }
  }

  /// (اختياري) Native - اتركه فقط إذا بدك Native فعلاً
  Future<Widget> getRealNativeAd({
    String factoryId = 'mediumNative',
    double height = 320,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) async {
    cleanupOldAds();

    debugPrint(
      'getRealNativeAd - isVip: ${AppStrings.isVip}, isVipChat: ${AppStrings.isVipChat}, factoryId: $factoryId',
    );

    if (AppStrings.isVip || AppStrings.isVipChat) {
      return const SizedBox.shrink();
    }

    if (!_isInitialized && !_isInitializing) {
      await initialize();
    }

    try {
      final String uniqueRequestId =
          '${DateTime.now().millisecondsSinceEpoch}_${_adRequestCounter++}_native';

      final NativeAd? nativeAd =
      await _adsRepository.loadNativeAd(factoryId: factoryId);

      if (nativeAd == null) {
        debugPrint('NativeAd is null');
        return const SizedBox.shrink();
      }

      return AdsContainer(
        child: Container(
          key: ValueKey<String>(uniqueRequestId),
          width: double.infinity,
          height: height,
          padding: padding,
          alignment: Alignment.center,
          child: AdWidget(ad: nativeAd),
        ),
      );
    } catch (e) {
      debugPrint('Error loading real native ad: $e');
      return const SizedBox.shrink();
    }
  }

  Future<void> showInterstitialAd({Function()? onAdClosed}) async {
    debugPrint(
      'showInterstitialAd - isVip: ${AppStrings.isVip}, isVipChat: ${AppStrings.isVipChat}',
    );

    if (AppStrings.isVip || AppStrings.isVipChat) return;

    if (!_isInitialized && !_isInitializing) {
      await initialize();
    }

    try {
      await _loadInterstitialAd();

      if (_interstitialAd != null && _isInterstitialAdReady) {
        await _interstitialAd!.show();
        _isInterstitialAdReady = false;
        _interstitialAd = null;
        onAdClosed?.call();
      } else {
        debugPrint('Interstitial ad not ready');
      }
    } catch (e) {
      debugPrint('Error showing interstitial ad: $e');
      _isInterstitialAdReady = false;
      _interstitialAd?.dispose();
      _interstitialAd = null;
    }
  }

  Future<void> _loadInterstitialAd() async {
    try {
      _interstitialAd = await _adsRepository.loadInterstitialAd();
      _isInterstitialAdReady = _interstitialAd != null;
    } catch (e) {
      debugPrint('Error loading interstitial ad: $e');
      _isInterstitialAdReady = false;
      _interstitialAd = null;
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
    _adsRepository.disposeAds();
  }

  void cleanupOldAds() {
    final DateTime now = DateTime.now();
    if (_lastCleanupTime != null &&
        now.difference(_lastCleanupTime!).inMinutes < 1) {
      return;
    }
    _lastCleanupTime = now;

    debugPrint('Cleaning up old ads');

    if (_adRequestCounter > 1000) {
      _adRequestCounter = 0;
    }
  }
}
