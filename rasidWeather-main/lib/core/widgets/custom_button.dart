import 'package:flutter/material.dart';

enum IconDirection { left, right }

class AdaptiveButton extends StatelessWidget {

  const AdaptiveButton({
    super.key,
    this.onTap,
    required this.label,
    required this.height,
    required this.width,
    this.loading = false,
    this.disabled = false,
    this.strokeWidth = 2,
    this.color,
    this.border,
    this.radius = 10,
    this.style,
    this.icon,
    this.elevation = 0,
    this.iconDirection = IconDirection.left,
    this.gradient,
  });
  final String label;
  final double height;
  final double width;
  final bool loading;
  final bool disabled;
  final double? radius;
  final TextStyle? style;
  final Color? color;
  final Color? border;
  final double? strokeWidth;
  final VoidCallback? onTap;
  final Widget? icon;
  final double? elevation;
  final IconDirection? iconDirection;
  final Gradient? gradient;

  Color _buttonColor(BuildContext context) {
    if (gradient != null && !disabled) {
      return Colors.transparent;
    } else {
      return color ??
          (disabled
              ? Colors.grey
              : Theme.of(context).primaryColor);
    }
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.zero,
      elevation: elevation,
      maximumSize: Size(width, height),
      minimumSize: Size(width, height),
      foregroundColor: Theme.of(context).colorScheme.surface,
      backgroundColor: _buttonColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius!),
      ),
    );
  }

  /// بناء محتوى الزر
  Widget _buildChild(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: height * 0.6,
        width: height * 0.6,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.surface,
          ),
        ),
      );
    }

    if (icon != null) {
      return Directionality(
        textDirection: iconDirection == IconDirection.right
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon!,
            const SizedBox(width: 8),
            Text(
              label,
              style: style ??
                  Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: disabled ? Colors.grey : Colors.white,
                  ),
            ),
          ],
        ),
      );
    }

    return Text(
      label,
      style: style ??
          Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: disabled ? Colors.grey : Colors.white,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        gradient: gradient,
      ),
      child: ElevatedButton(
        onPressed: (!loading && !disabled) ? onTap : null,
        style: _buttonStyle(context),
        child: _buildChild(context),
      ),
    );
  }
}
