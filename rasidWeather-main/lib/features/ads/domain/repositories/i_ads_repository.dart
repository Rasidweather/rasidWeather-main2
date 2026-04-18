import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class IAdsRepository {
  Future<void> initialize();
  Future<AppOpenAd?> loadAppOpenAd();
  Future<InterstitialAd?> loadInterstitialAd();
  Future<BannerAd> loadBannerAd({AdSize adSize});
  Future<NativeAd?> loadNativeAd({required String factoryId});
  void disposeAds();
}
