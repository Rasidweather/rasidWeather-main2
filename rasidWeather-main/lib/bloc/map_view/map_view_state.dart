import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MapViewState {

  MapViewState({
    this.controller,
    this.isWebViewReady = false,
    this.sliderValue = 0.0,
    this.isPlaying = false,
    this.isRadar = true,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) : scaffoldKey = scaffoldKey ?? GlobalKey<ScaffoldState>();
  final InAppWebViewController? controller;
  final bool isWebViewReady;
  final double sliderValue;
  final bool isPlaying;
  final bool isRadar;
  final GlobalKey<ScaffoldState> scaffoldKey;

  MapViewState copyWith({
    InAppWebViewController? controller,
    bool? isWebViewReady,
    double? sliderValue,
    bool? isPlaying,
    bool? isRadar,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) {
    return MapViewState(
      controller: controller ?? this.controller,
      isWebViewReady: isWebViewReady ?? this.isWebViewReady,
      sliderValue: sliderValue ?? this.sliderValue,
      isPlaying: isPlaying ?? this.isPlaying,
      isRadar: isRadar ?? this.isRadar,
      scaffoldKey: scaffoldKey ?? this.scaffoldKey,
    );
  }
}
