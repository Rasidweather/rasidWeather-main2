import 'package:flutter/material.dart';

import '../../../../core/widgets/image_widget.dart';

@immutable
class ForecastIcon extends StatelessWidget {
   const ForecastIcon({
    super.key,
    this.containerSize = 90.0,
    required this.icon,
    this.iconSize = 60.0,
    this.color,
    this.shadowColor = Colors.black38,
    this.resizeAnimation,
    this.animatedIcon = false,
  });

  final double containerSize;
  final String icon;
  final double iconSize;
  final Color? color;
  final Color shadowColor;
  final Animation<double>? resizeAnimation;
  final bool animatedIcon;
  

  @override
  Widget build(BuildContext context) {
    // Pre-compute sizes
    final double containerSize = getContainerSize();
    final double iconSize = getIconSize();
    
    // Use RepaintBoundary to isolate repaints
    return RepaintBoundary(
      child: SizedBox(
        height: containerSize,
        child: animatedIcon 
          ? ImageView.lottieLink(
              icon, 
              width: iconSize,
            )
          : ImageView.svgLink(
              icon, 
              // color: color,
              width: iconSize,
            ),
      ),
    );
  }

  double getIconSize() {
    if (resizeAnimation == null) {
      return iconSize;
    }

    return Tween<double>(begin: iconSize - 36.0, end: iconSize).evaluate(resizeAnimation!);
  }

  double getContainerSize() {
    if (resizeAnimation == null) {
      return containerSize;
    }

    return Tween<double>(
      begin: containerSize - 50.0,
      end: containerSize,
    ).evaluate(resizeAnimation!);
  }
}
