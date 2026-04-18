import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'map_view_state.dart';

class MapViewCubit extends Cubit<MapViewState> {

  MapViewCubit() : super(MapViewState());
  Timer? _timer;
  static const int _animationStepsPerSecond = 60;
  static const Duration _animationDuration = Duration(milliseconds: 1000);

  void setController(InAppWebViewController controller) {
    emit(state.copyWith(
      controller: controller,
      isWebViewReady: false,
    ));
  }

  void setWebViewReady(bool isReady) {
    if (state.controller == null) return;
    emit(state.copyWith(isWebViewReady: isReady));
  }

  void updateSliderValue(double value) {
    if (!state.isWebViewReady) return;
    emit(state.copyWith(sliderValue: value));
  }

  Future<void> togglePlay() async {
    if (!state.isWebViewReady || state.controller == null) return;

    try {
      final bool willPlay = !state.isPlaying;
      emit(state.copyWith(isPlaying: willPlay));

      if (willPlay) {
        await state.controller?.evaluateJavascript(source: 'play();');
        _startAnimation();
      } else {
        await _stopAnimation();
      }
    } catch (e) {
      debugPrint('Error toggling play state: $e');
      emit(state.copyWith(isPlaying: false));
    }
  }

  void _startAnimation() {
    _timer?.cancel();
    const double stepSize = 1.0 / _animationStepsPerSecond;
    final int stepDuration = _animationDuration.inMilliseconds ~/ _animationStepsPerSecond;

    _timer = Timer.periodic(
      Duration(milliseconds: stepDuration),
      (Timer timer) {
        if (!state.isPlaying) return;

        final double newValue = (state.sliderValue + stepSize).clamp(0.0, 1.0);
        emit(state.copyWith(sliderValue: newValue));

        if (newValue >= 1.0) {
          _stopAnimation();
        }
      },
    );
  }

  Future<void> _stopAnimation() async {
    _timer?.cancel();
    _timer = null;
    
    if (state.controller == null) return;
    
    try {
      await state.controller?.evaluateJavascript(source: 'stop();');
      emit(state.copyWith(
        isPlaying: false,
        sliderValue: 0.0,
      ));
    } catch (e) {
      debugPrint('Error stopping animation: $e');
    }
  }

  Future<void> setMapType(bool isRadar) async {
    if (!state.isWebViewReady || state.controller == null) return;

    try {
      emit(state.copyWith(isRadar: isRadar));
      await state.controller?.evaluateJavascript(
        source: "setKind('${isRadar ? 'radar' : 'satellite'}')",
      );
    } catch (e) {
      debugPrint('Error setting map type: $e');
    }
  }

  @override
  Future<void> close() async {
    await _stopAnimation();
    emit(state.copyWith(
      isWebViewReady: false,
      isPlaying: false,
      sliderValue: 0.0,
    ));
    return super.close();
  }
}
