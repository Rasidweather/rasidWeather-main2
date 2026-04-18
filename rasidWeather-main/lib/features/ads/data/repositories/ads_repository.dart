import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../common/constants/index.dart';
import '../../domain/repositories/i_ads_repository.dart';

class AdsRepository implements IAdsRepository {
  AppOpenAd? _appOpenAd;
  InterstitialAd? _interstitialAd;
  NativeAd? _nativeAd;
  bool _isShowingAd = false;
  bool _isInitialized = false;

  // Cache for ads to improve performance
  final Map<String, dynamic> _adCache = <String, dynamic>{};

  // Static method to clean up all isolates
  static void cleanupIsolates() {
    debugPrint('Cleaning up ad isolates and resources');
    // No isolates to clean up in this implementation, but we keep the method
    // for consistency with the interface and future extensions
  }

  // Add a debug counter to track ad objects
  static const int _totalAdsCreated = 0;
  static const int _totalAdsDisposed = 0;

  static void logAdStats() {
    debugPrint('===== AD OBJECT STATS =====');
    debugPrint('Total ads created: $_totalAdsCreated');
    debugPrint('Total ads disposed: $_totalAdsDisposed');
    debugPrint(
      'Difference (potential leaks): ${_totalAdsCreated - _totalAdsDisposed}',
    );
    debugPrint('==========================');
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('Ads already initialized, skipping');
      return;
    }

    try {
      debugPrint('Initializing Mobile Ads SDK');
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('Mobile Ads SDK initialized successfully');
    } catch (e) {
      debugPrint('Error initializing Mobile Ads SDK: $e');
      _isInitialized = false;
      // Rethrow to allow caller to handle
      rethrow;
    }
  }

  @override
  Future<AppOpenAd?> loadAppOpenAd() async {
    try {
      // Ensure we're initialized
      if (!_isInitialized) {
        await initialize();
      }

      final Completer<AppOpenAd?> completer = Completer<AppOpenAd?>();

      // Check if we have a cached ad that's not too old
      if (_appOpenAd != null) {
        return _appOpenAd;
      }

      // Load the ad directly - no isolate needed
      await AppOpenAd.load(
        adUnitId: AdMobIdentifier.appOpenAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (AppOpenAd ad) {
            _appOpenAd = ad;
            _appOpenAd?.fullScreenContentCallback =
                FullScreenContentCallback<AppOpenAd>(
                  onAdShowedFullScreenContent: (AppOpenAd ad) {
                    _isShowingAd = true;
                  },
                  onAdDismissedFullScreenContent: (AppOpenAd ad) {
                    _isShowingAd = false;
                    ad.dispose();
                    _appOpenAd = null;
                  },
                  onAdFailedToShowFullScreenContent: (
                    AppOpenAd ad,
                    AdError error,
                  ) {
                    _isShowingAd = false;
                    ad.dispose();
                    _appOpenAd = null;
                  },
                );
            if (!_isShowingAd) {
              _appOpenAd?.show();
            }
            if (!completer.isCompleted) {
              completer.complete(_appOpenAd);
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('AppOpenAd failed to load: $error');
            _appOpenAd = null;
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          },
        ),
      );

      return completer.future;
    } catch (e) {
      debugPrint('Error loading AppOpenAd: $e');
      return null;
    }
  }

  @override
  Future<InterstitialAd?> loadInterstitialAd() async {
    try {
      // Ensure we're initialized
      if (!_isInitialized) {
        await initialize();
      }

      final Completer<InterstitialAd?> completer = Completer<InterstitialAd?>();

      // Check if we have a cached ad
      if (_interstitialAd != null) {
        return _interstitialAd;
      }

      // Load the ad directly - no isolate needed
      await InterstitialAd.load(
        adUnitId: AdMobIdentifier.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _setInterstitialCallbacks();
            if (!completer.isCompleted) {
              completer.complete(_interstitialAd);
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          },
        ),
      );

      return completer.future;
    } catch (e) {
      debugPrint('Error loading InterstitialAd: $e');
      return null;
    }
  }

  void _setInterstitialCallbacks() {
    if (_interstitialAd == null) {
      return;
    }

    _interstitialAd!
        .fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        _isShowingAd = true;
        debugPrint('Interstitial ad is now showing');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        _isShowingAd = false;
        ad.dispose();
        debugPrint('Interstitial ad was dismissed');
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        _isShowingAd = false;
        ad.dispose();
        debugPrint('Failed to show interstitial ad: $error');
      },
      onAdImpression: (InterstitialAd ad) {
        debugPrint('Interstitial ad impression recorded');
      },
    );
    
    // Set immersive mode to true to prevent users from closing the ad
    // until it finishes playing
    _interstitialAd!.setImmersiveMode(true);
  }

  @override
  Future<BannerAd> loadBannerAd({AdSize adSize = AdSize.banner}) async {
    final Completer<BannerAd> completer = Completer<BannerAd>();

    try {
      // Ensure we're initialized
      if (!_isInitialized) {
        await initialize();
      }

      // Create a new banner ad - don't use cache for banner ads
      // as we're handling caching in the AdsService
      final BannerAd bannerAd = BannerAd(
        adUnitId: AdMobIdentifier.bannerAdUnitId,
        size: adSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('BannerAd loaded successfully');
            if (!completer.isCompleted) {
              completer.complete(ad as BannerAd);
            }
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('BannerAd failed to load: $error');
            if (!completer.isCompleted) {
              completer.completeError(error);
            }
            ad.dispose();
          },
        ),
      );

      // Start loading the ad
      await bannerAd.load();
      return completer.future;
    } catch (e) {
      debugPrint('Error loading banner ad: $e');
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
      throw Exception('Failed to load banner ad: $e');
    }
  }

  @override
  Future<NativeAd?> loadNativeAd({required String factoryId}) async {
    try {
      if (Platform.isIOS) {
        // Skip iOS native ads if no factory is registered to avoid PlatformException.
        return null;
      }
      // Ensure we're initialized
      if (!_isInitialized) {
        await initialize();
      }

      final Completer<NativeAd?> completer = Completer<NativeAd?>();

      // Create a new native ad
      final NativeAd nativeAd = NativeAd(
        adUnitId: AdMobIdentifier.nativeAdUnitId,
        factoryId: factoryId,
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (Ad ad) {
            debugPrint('NativeAd loaded successfully');
            _nativeAd = ad as NativeAd;
            if (!completer.isCompleted) {
              completer.complete(_nativeAd);
            }
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('NativeAd failed to load: $error');
            if (!completer.isCompleted) {
              completer.completeError(error);
            }
            ad.dispose();
          },
          onAdOpened: (Ad ad) {
            debugPrint('NativeAd opened');
          },
          onAdClosed: (Ad ad) {
            debugPrint('NativeAd closed');
          },
          onAdImpression: (Ad ad) {
            debugPrint('NativeAd impression recorded');
          },
          onAdClicked: (Ad ad) {
            debugPrint('NativeAd clicked');
          },
        ),
      );

      // Start loading the ad
      await nativeAd.load();
      return completer.future;
    } catch (e) {
      debugPrint('Error loading native ad: $e');
      return null;
    }
  }

  @override
  void disposeAds() {
    debugPrint('Disposing all ads');

    // Dispose app open ad
    if (_appOpenAd != null) {
      _appOpenAd!.dispose();
      _appOpenAd = null;
    }

    // Dispose interstitial ad
    if (_interstitialAd != null) {
      _interstitialAd!.dispose();
      _interstitialAd = null;
    }
    
    // Dispose native ad
    if (_nativeAd != null) {
      _nativeAd!.dispose();
      _nativeAd = null;
    }

    // Dispose all cached ads
    for (final dynamic ad in _adCache.values) {
      if (ad is Ad) {
        ad.dispose();
      }
    }
    _adCache.clear();

    // Reset initialization state
    _isInitialized = false;
    debugPrint('All ads disposed');
  }
}
