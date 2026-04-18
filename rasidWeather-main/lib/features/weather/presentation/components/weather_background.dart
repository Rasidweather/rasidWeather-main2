// lib/features/subscription/presentation/view/components/weather_background.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/ui_cubit/ui_cubit.dart';
import '../../../../common/utils/debouncer.dart';
import '../../../../core/core.dart';
import '../../../../views/base/background.dart';
import '../../data/models/weather_model.dart';

/// خلفية الطقس. تدعم فيديو/تدرّج.
/// يمكن تعطيل الأنيميشن عبر [showAnimation].
class WeatherBackground extends StatefulWidget {
  const WeatherBackground({
    super.key,
    this.child,
    this.showAnimation = true, // ← جديد
  });

  /// ويدجت اختيارية فوق الخلفية
  final Widget? child;

  /// هل نعرض الخلفية المتحركة (فيديو)؟
  final bool showAnimation;

  @override
  State<WeatherBackground> createState() => _WeatherBackgroundState();
}

class _WeatherBackgroundState extends State<WeatherBackground>
    with WidgetsBindingObserver {
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  String? _currentBackgroundVideo;
  Widget? _cachedBackgroundWidget;
  String? _cachedBackgroundKey;

  Timer? _memoryCleanupTimer;
  bool _isPaused = false;
  bool _isLowMemory = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupMemoryCleanup();
  }

  void _setupMemoryCleanup() {
    _memoryCleanupTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isLowMemory || _isPaused) {
        _cleanupMemory();
      }
    });
  }

  void _cleanupMemory() {
    if (_cachedBackgroundWidget != null &&
        _currentBackgroundVideo != _cachedBackgroundKey) {
      _cachedBackgroundWidget = null;
      _cachedBackgroundKey = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        _isPaused = true;
        _cleanupMemory();
      case AppLifecycleState.resumed:
        _isPaused = false;
        _isLowMemory = false;
      case AppLifecycleState.inactive:
        _cleanupMemory();
      case AppLifecycleState.detached:
        _cleanupMemory();
      case AppLifecycleState.hidden:
        _cleanupMemory();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _memoryCleanupTimer?.cancel();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiCubit, UiState>(
      builder: (BuildContext context, UiState state) {
        final Appearance appearance = state is UiThemeChanged
            ? state.colorModel
            : context.read<UiCubit>().currentAppearance;

        // المفتاح يعتمد على الخلفية + مسار الفيديو + حالة showAnimation
        final String cacheKey =
            '${appearance.background?.first ?? ''}_${appearance.backgroundVideo ?? ''}_${widget.showAnimation}';

        if (_cachedBackgroundWidget != null &&
            _cachedBackgroundKey == cacheKey) {
          return _cachedBackgroundWidget!;
        }

        // إذا كانت الخلفية فيديو ومفعّل الأنيميشن
        // أو إذا كان showAnimation = true ولكن الـ API لم يرجع فيديو (استخدم الفيديو الافتراضي)
        final bool canPlayVideo = widget.showAnimation &&
            (appearance.type == 'video' || appearance.backgroundVideo == null);

        Widget backgroundWidget;
        if (canPlayVideo) {
          // استخدم الفيديو من الـ API أو الفيديو الافتراضي للمشتركين
          final String videoPath = appearance.backgroundVideo ??
              UiCubit.defaultVideoAppearance.backgroundVideo!;

          if (_currentBackgroundVideo != videoPath) {
            _debouncer.run(() {
              if (mounted) {
                setState(() {
                  _currentBackgroundVideo = videoPath;
                });
              }
            });
          }

          backgroundWidget = Stack(
            fit: StackFit.expand,
            children: <Widget>[
              RepaintBoundary(
                child: BackgroundVideo(
                  key: ValueKey<String>(videoPath),
                  video: videoPath,
                ),
              ),
              ColoredBox(color: Colors.black.withOpacity(0.2)),
              if (widget.child != null) widget.child!,
            ],
          );
        } else {
          // تدرّج لوني عند التعطيل أو عدم توفر فيديو
          const Appearance fallback = UiCubit.defaultAppearance;
          final List<String> background =
              (appearance.background != null && appearance.background!.length >= 2)
                  ? appearance.background!
                  : fallback.background ?? const <String>['#ffffff', '#ffffff'];
          final List<Color> colors = background
              .take(2)
              .map((String hex) => convertHexaToColor(hex))
              .toList();
          final List<double> stops = (appearance.stops != null &&
                  appearance.stops!.length == colors.length)
              ? appearance.stops!
              : const <double>[];

          backgroundWidget = Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: colors,
                stops: stops.isEmpty ? null : stops,
              ),
            ),
            child: widget.child,
          );
        }

        _cachedBackgroundWidget = backgroundWidget;
        _cachedBackgroundKey = cacheKey;
        return backgroundWidget;
      },
    );
  }
}
