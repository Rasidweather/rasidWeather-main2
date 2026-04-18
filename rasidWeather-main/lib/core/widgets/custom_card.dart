import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CustomCard extends StatelessWidget {

  const CustomCard({super.key, this.color, this.padding, required this.child});
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          color: color ?? AppColors.cardBackgroundColor,
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(12.0),
          child: child,
        ));
  }
}
