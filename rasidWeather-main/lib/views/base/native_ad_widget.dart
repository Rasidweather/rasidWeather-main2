import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../bloc/profile_cubit/profile_cubit.dart';
import '../../common/constants/index.dart';
import '../../locator.dart';

/// A widget that displays banner ads instead of native ads
/// The name is kept as NativeAdWidget for backward compatibility
class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({
    super.key,
    this.size = AdSize.mediumRectangle,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  final AdSize size;
  final EdgeInsetsGeometry padding;

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  // Retry counter for ad loading
  int _retryAttempt = 0;
  static const int _maxRetries = 3;

  void _loadAd() {
    // Don't load ads in debug mode (we'll use dummy ads instead)
    if (kDebugMode) {
      return;
    }

    // Don't load ads if already loading
    if (_isAdLoading) {
      return;
    }

    // Check user login and subscription status through ProfileCubit
    final ProfileState profileState = sl<ProfileCubit>().state;

    // Only skip ads for logged-in users with subscriptions
    if (profileState is ProfileSuccess &&
        (profileState.profile.isVip || profileState.profile.isVipChat)) {
      // User is logged in and has subscription, don't load ad
      return;
    }

    _isAdLoading = true;

    // Get appropriate ad unit ID
    final String adUnitId = AdMobIdentifier.bannerAdUnitId;

    debugPrint(
      'Attempting to load banner ad with ID: $adUnitId (attempt: ${_retryAttempt + 1})',
    );

    // Create a banner ad with improved error handling
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: widget.size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (!mounted) {
            return;
          }

          setState(() {
            _bannerAd = ad as BannerAd;
            _isAdLoaded = true;
            _isAdLoading = false;
            _retryAttempt = 0; // Reset retry counter on success
          });
          debugPrint('Banner ad loaded successfully');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Banner ad failed to load: $error');
          ad.dispose();

          if (!mounted) {
            return;
          }

          setState(() {
            _isAdLoading = false;
          });

          // Handle network errors with retry logic
          if (_retryAttempt < _maxRetries) {
            _retryAttempt++;
            debugPrint(
              'Retrying ad load attempt $_retryAttempt of $_maxRetries',
            );
            // Retry after a delay with exponential backoff
            Future<void>.delayed(Duration(seconds: 3 * _retryAttempt), () {
              if (mounted) {
                _loadAd();
              }
            });
          } else {
            debugPrint(
              'Maximum retry attempts reached. Giving up on loading ad.',
            );
            _retryAttempt = 0;
          }
        },
        onAdOpened: (Ad ad) {
          debugPrint('Banner ad opened');
        },
        onAdClosed: (Ad ad) {
          debugPrint('Banner ad closed');
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  // Height is now handled directly by AdSize and the container's flexible layout

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>.value(
      value: sl<ProfileCubit>(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          // Check if user is logged in and has subscription
          if (state is ProfileSuccess &&
              (state.profile.isVip || state.profile.isVipChat)) {
            // User is logged in and has subscription, don't show ad
            return const SizedBox.shrink();
          }

          // For all other cases (not logged in or logged in without subscription)
          // Show ad if loaded
          return _isAdLoaded && _bannerAd != null
              ? Container(
                  height: widget.size.height.toDouble(),
                  width: double.infinity,
                  padding: widget.padding,
                  child: AdWidget(ad: _bannerAd!),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }

  /// Builds a loading placeholder when the ad is not yet loaded
  Widget _buildLoadingPlaceholder() {
    return Container(
      height: widget.size.height.toDouble(),
      width: widget.size.width.toDouble(),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
