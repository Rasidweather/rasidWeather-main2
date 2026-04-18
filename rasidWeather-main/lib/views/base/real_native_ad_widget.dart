import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../bloc/profile_cubit/profile_cubit.dart';
import '../../common/constants/index.dart';
import '../../locator.dart';

class NativeAdWidgetReal extends StatefulWidget {
  const NativeAdWidgetReal({
    super.key,
    this.factoryId = 'native', // لازم يطابق factory اللي رح نسجله iOS/Android
    this.height = 320,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  });

  final String factoryId;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  State<NativeAdWidgetReal> createState() => _NativeAdWidgetRealState();
}

class _NativeAdWidgetRealState extends State<NativeAdWidgetReal> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  bool _isAdLoading = false;

  int _retryAttempt = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (_isAdLoading) return;
    if (Platform.isIOS) {
      // iOS requires a registered NativeAdFactory; skip to avoid PlatformException.
      return;
    }

    // ✅ Check subscription عبر ProfileCubit (نفس منطقك)
    final ProfileState profileState = sl<ProfileCubit>().state;
    // if (profileState is ProfileSuccess &&
    //     (profileState.profile.isVip || profileState.profile.isVipChat)) {
    //   return;
    // }ظ

    _isAdLoading = true;

    // ✅ مفاتيحك جاهزة هون (وفي debug رح يرجّع Test IDs)
    final String adUnitId = AdMobIdentifier.appOpenAdUnitId;

    debugPrint(
      'Attempting to load NATIVE ad with ID: $adUnitId '
          '(attempt: ${_retryAttempt + 1}) factoryId=${widget.factoryId}',
    );

    try {
      _nativeAd?.dispose();
      _nativeAd = NativeAd(
        adUnitId: adUnitId,
        factoryId: widget.factoryId,
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (Ad ad) {
            if (!mounted) return;
            setState(() {
              _nativeAd = ad as NativeAd;
              _isAdLoaded = true;
              _isAdLoading = false;
              _retryAttempt = 0;
            });
            debugPrint('Native ad loaded successfully');
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            debugPrint('Native ad failed to load: $error');
            ad.dispose();

            if (!mounted) return;

            setState(() {
              _isAdLoading = false;
              _isAdLoaded = false;
              _nativeAd = null;
            });

            if (_retryAttempt < _maxRetries) {
              _retryAttempt++;
              Future<void>.delayed(Duration(seconds: 2 * _retryAttempt), () {
                if (mounted) _loadAd();
              });
            } else {
              _retryAttempt = 0;
            }
          },
          onAdImpression: (Ad ad) => debugPrint('Native ad impression'),
          onAdClicked: (Ad ad) => debugPrint('Native ad clicked'),
        ),
      );

      _nativeAd!.load();
    } catch (e) {
      debugPrint('Native ad load failed: $e');
      _isAdLoading = false;
      _isAdLoaded = false;
      _nativeAd?.dispose();
      _nativeAd = null;
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>.value(
      value: sl<ProfileCubit>(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          // if (state is ProfileSuccess &&
          //     (state.profile.isVip || state.profile.isVipChat)) {
          //   return const SizedBox.shrink();
          // }

          if (!_isAdLoaded || _nativeAd == null) {
            return const SizedBox.shrink();
          }

          return Container(
            height: widget.height,
            width: double.infinity,
            padding: widget.padding,
            child: AdWidget(ad: _nativeAd!),
          );
        },
      ),
    );
  }
}
