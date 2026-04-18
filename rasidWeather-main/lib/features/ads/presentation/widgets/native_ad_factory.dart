import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Utility class for native ads
class NativeAdFactory {
  /// Initialize native ads
  static void registerNativeAdFactories() {
    try {
      // Initialize the Mobile Ads SDK
      MobileAds.instance.initialize().then((InitializationStatus status) {
        debugPrint('MobileAds initialization status: $status');
      });
      
      // Note: We're not using native ads anymore, but keeping this method for backward compatibility
      // Instead, we're using banner ads in the NativeAdWidget class
      
      debugPrint('Mobile ads initialized successfully');
    } catch (e) {
      debugPrint('Error initializing ads: $e');
    }
  }
  
  /// Clean up resources when they're no longer needed
  static void unregisterNativeAdFactories() {
    // No custom factories to unregister
    debugPrint('Native ad cleanup complete');
  }
  
  /// Get the appropriate test ad unit ID based on platform
  static String getTestAdUnitId() {
    if (kDebugMode) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/2247696110'; // Android test native ad unit ID
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/3986624511'; // iOS test native ad unit ID
      }
    }
    return '';
  }
}





/// Widget for displaying a small native ad
class SmallNativeAdWidget extends StatelessWidget {

  const SmallNativeAdWidget({super.key, required this.ad});
  final NativeAd ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              AdWidget(ad: ad),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NativeAdHeadline(),
                    SizedBox(height: 4),
                    NativeAdAttribution(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying a medium native ad
class MediumNativeAdWidget extends StatelessWidget {

  const MediumNativeAdWidget({super.key, required this.ad});
  final NativeAd ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              NativeAdIcon(),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NativeAdHeadline(),
                    SizedBox(height: 4),
                    NativeAdAttribution(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          NativeAdMedia(),
          SizedBox(height: 8),
          NativeAdBody(),
          SizedBox(height: 12),
          NativeAdButton(),
        ],
      ),
    );
  }
}

/// Widget for displaying a large native ad
class LargeNativeAdWidget extends StatelessWidget {

  const LargeNativeAdWidget({super.key, required this.ad});
  final NativeAd ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              NativeAdIcon(size: 48),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    NativeAdHeadline(),
                    SizedBox(height: 4),
                    NativeAdAttribution(),
                    SizedBox(height: 4),
                    NativeAdAdvertiser(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          NativeAdMedia(height: 180),
          SizedBox(height: 12),
          NativeAdBody(),
          SizedBox(height: 16),
          NativeAdButton(),
          SizedBox(height: 8),
          NativeAdStarRating(),
        ],
      ),
    );
  }
}

/// Helper widget for native ad headline
class NativeAdHeadline extends StatelessWidget {
  const NativeAdHeadline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 20),
      child: const AdLabel(label: 'headline'),
    );
  }
}

/// Helper widget for native ad body
class NativeAdBody extends StatelessWidget {
  const NativeAdBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      child: const AdLabel(label: 'body'),
    );
  }
}

/// Helper widget for native ad icon
class NativeAdIcon extends StatelessWidget {
  
  const NativeAdIcon({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: AdLabel(label: 'icon'),
      ),
    );
  }
}

/// Helper widget for native ad media
class NativeAdMedia extends StatelessWidget {
  
  const NativeAdMedia({super.key, this.height = 120});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: AdLabel(label: 'media'),
      ),
    );
  }
}

/// Helper widget for native ad button
class NativeAdButton extends StatelessWidget {
  const NativeAdButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: AdLabel(
          label: 'call to action',
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Helper widget for native ad attribution
class NativeAdAttribution extends StatelessWidget {
  const NativeAdAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'Ad',
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Helper widget for native ad advertiser
class NativeAdAdvertiser extends StatelessWidget {
  const NativeAdAdvertiser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 16),
      child: const AdLabel(label: 'advertiser'),
    );
  }
}

/// Helper widget for native ad star rating
class NativeAdStarRating extends StatelessWidget {
  const NativeAdStarRating({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
        5,
        (int index) => const Icon(
          Icons.star,
          color: Colors.amber,
          size: 16,
        ),
      ),
    );
  }
}

/// Helper widget for ad labels
class AdLabel extends StatelessWidget {
  
  const AdLabel({
    super.key,
    required this.label,
    this.color = Colors.black,
  });
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 12,
      ),
    );
  }
}
