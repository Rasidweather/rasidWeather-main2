import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';




class AdaptiveBackButton extends StatelessWidget {
  const AdaptiveBackButton({
    super.key,
    this.color,
    this.onPressed,
    this.size = 24.0,
    this.padding = const EdgeInsets.all(8.0),
    this.tooltip,
    this.enableFeedback = true,
  });

  /// The color to use for the icon.
  final Color? color;

  /// An override callback to perform instead of the default behavior.
  final VoidCallback? onPressed;

  /// The size of the icon.
  final double size;

  /// The padding around the button.
  final EdgeInsetsGeometry padding;

  /// The tooltip text shown when long-pressing the button.
  final String? tooltip;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool enableFeedback;

  @override
  Widget build(BuildContext context) {
    
    // Determine the appropriate icon based on platform and text direction
    IconData iconData;
    
    if (Platform.isIOS) {
      // iOS uses chevron icons
      iconData = /*isRTL ? Icons.chevron_right :*/ Icons.chevron_left;
    } else {
      // Android uses arrow_back icons
      iconData = /*isRTL ? Icons.arrow_forward :*/ Icons.arrow_back;
    }
    
    final String tooltipText = tooltip ?? 'common.back'.tr();
    
    return IconButton(
      icon: Icon(iconData),
      padding: padding,
      iconSize: size,
      tooltip: tooltipText,
      color: color ?? Colors.black,
      enableFeedback: enableFeedback,
      onPressed: onPressed ?? () {
        Navigator.maybePop(context);
      },
    );
  }
}
