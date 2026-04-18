import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

import '../../features/weather/data/models/weather_model.dart';
import '../../utils/ui_utils.dart';
import '../../views/base/index.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({super.key, this.assetIcon = 'assets/loader.png'});
  final String assetIcon;

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const Duration _animationDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animationDuration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UiWidget(
      child: (Appearance ui) {
        final Color color = convertHexaToColor(ui.textColor!);

        return AnimatedBuilder(
          animation: _controller,
          builder: (_, Widget? child) {
            return Transform.rotate(
              angle: vector.radians(180 * _controller.value),
              child: child,
            );
          },
          child: Icon(
            Icons.sunny,
            color: color,
            key: ValueKey<String>('loader-image-${ui.textColor}'),
          ),
        );
      },
    );
  }
}
