import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

enum IconDirection { left, right }

class AdaptiveButton extends StatefulWidget {
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
    this.radius = 3,
    this.style,
    this.icon,
    this.elevation = 0,
    this.iconDirection = IconDirection.left,
    this.gradient,
    this.isShimmer = false,
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
  final bool isShimmer;

  @override
  State<AdaptiveButton> createState() => _AdaptiveButtonState();
}

class _AdaptiveButtonState extends State<AdaptiveButton> {
  Color buttonColor() {
    if (widget.gradient != null && !widget.disabled) {
      return Colors.transparent;
    } else {
      return widget.color ?? (widget.disabled ? Colors.grey : Theme.of(context).primaryColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.background;

    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.radius!),
        gradient: widget.gradient,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          elevation: widget.elevation,
          maximumSize: Size(widget.width, widget.height),
          minimumSize: Size(widget.width, widget.height),
          foregroundColor: textColor,
          backgroundColor: buttonColor(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius!)),
        ),
        onPressed: !widget.loading && !widget.disabled ? widget.onTap : null,
        child: Shimmer.fromColors(
          baseColor: Colors.white,
          highlightColor: Colors.orange,
          enabled: widget.isShimmer,
          child: Directionality(
            textDirection: widget.iconDirection == IconDirection.right ? TextDirection.rtl : TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (widget.loading)
                  Container(
                    constraints:
                        BoxConstraints(maxHeight: widget.height - widget.height * 40 / 100, maxWidth: widget.height - widget.height * 40 / 100),
                    child: CircularProgressIndicator(
                      strokeWidth: widget.strokeWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                else
                  Text(
                    widget.label,
                    style: widget.style ?? Theme.of(context).textTheme.titleMedium!.copyWith(color: widget.disabled ? Colors.grey : textColor),
                  ),
                if (!widget.loading && widget.icon != null)
                  SizedBox(
                    width: 10.w,
                    child: widget.icon,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
