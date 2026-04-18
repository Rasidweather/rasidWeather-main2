import 'package:flutter/material.dart';

class ViewTooltip extends StatefulWidget {
  const ViewTooltip({
    super.key,
    required this.child,
    required this.message,
    this.color = Colors.white,
    this.backgroundColor = Colors.white,
    this.messageColor = Colors.white,
    this.offset = const Offset(-10, -35),
    this.minWidth = 75.0,
    this.maxWidth = 200.0,
  });

  final Widget child;
  final String message;
  final Offset? offset;
  final Color color;
  final Color backgroundColor;
  final Color messageColor;
  final double minWidth;
  final double maxWidth;

  @override
  ViewTooltipState createState() => ViewTooltipState();
}

class ViewTooltipState extends State<ViewTooltip> {
  late OverlayEntry? _overlayEntry;
  late final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;

  // Cache calculated tooltip width
  late final double _tooltipWidth = _calculateWidth();

  // Cache tooltip offset
  late final Offset _tooltipOffset = widget.offset!;

  @override
  void initState() {
    super.initState();
    _overlayEntry = _buildOverlayEntry();
  }

  @override
  void dispose() {
    if (_isOpen) {
      _overlayEntry!.remove();
    }
    _overlayEntry!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with RepaintBoundary to isolate repaints
    return RepaintBoundary(
      // Use a key based on message for better identity
      key: ValueKey<String>('tooltip-${widget.message}'),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          key: ValueKey<String>('tooltip-trigger-${widget.message}'),
          onTap: () {
            if (_isOpen) {
              try {
                _overlayEntry!.remove();
                _isOpen = false;
              } catch (e) {
                debugPrint('Error removing tooltip overlay: $e');
              }
            } else {
              final OverlayState overlay = Overlay.of(context);
              overlay.insert(_overlayEntry!);
              _isOpen = true;

              // Auto-hide after delay
              Future<void>.delayed(const Duration(seconds: 2), () {
                if (mounted && _isOpen) {
                  try {
                    _overlayEntry!.remove();
                    _isOpen = false;
                  } catch (e) {
                    debugPrint('Error auto-hiding tooltip: $e');
                  }
                }
              });
            }
          },
          child: widget.child,
        ),
      ),
    );
  }

  // Calculate the appropriate width based on message length
  double _calculateWidth() {
    // Estimate width based on character count (roughly 8 pixels per character)
    final double estimatedWidth = widget.message.length * 8.0;

    // Constrain between min and max width
    return estimatedWidth.clamp(widget.minWidth, widget.maxWidth);
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      builder: (BuildContext context) {
        // Use cached tooltip width instead of recalculating
        final double tooltipWidth = _tooltipWidth;

        // Create a key for tooltip identity
        final ValueKey<String> tooltipKey = ValueKey<String>(
          'tooltip-overlay-${widget.message}',
        );

        // Cache text style
        final TextStyle textStyle = TextStyle(
          color: widget.messageColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        );

        // Cache padding
        const EdgeInsets padding = EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        );

        return Positioned(
          width: tooltipWidth + 10, // Add some padding
          child: RepaintBoundary(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: _tooltipOffset,
              child: Material(
                key: tooltipKey,
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    RepaintBoundary(
                      child: CustomPaint(
                        size: Size(tooltipWidth, 39),
                        painter: _RPSCustomPainter(
                          context,
                          widget.color,
                          widget.backgroundColor,
                          tooltipWidth,
                        ),
                      ),
                    ),
                    Container(
                      width: tooltipWidth,
                      padding: padding,
                      child: Center(
                        child: Text(
                          widget.message,
                          style: textStyle,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RPSCustomPainter extends CustomPainter {
  _RPSCustomPainter(this.context, this.color, this.background, this.width) {
    // Pre-compute path and paints for better performance
    _initializePath();
    _initializePaints();
  }

  final BuildContext context;
  final Color color;
  final Color background;
  final double width;

  // Cache path and paints
  late final Path _path;
  late final Paint _paintStroke;
  late final Paint _paintFill;

  void _initializePath() {
    final double w = width;
    const double h = 39; // Fixed height
    const double radius = 8.0;

    _path = Path();

    // Top left corner
    _path.moveTo(radius, 0);

    // Top edge
    _path.lineTo(w - radius, 0);

    // Top right corner
    _path.quadraticBezierTo(w, 0, w, radius);

    // Right edge
    _path.lineTo(w, h - radius - 10);

    // Bottom right corner
    _path.quadraticBezierTo(w, h - 10, w - radius, h - 10);

    // Bottom edge with pointer
    _path.lineTo(w * 0.6, h - 10);
    _path.lineTo(w * 0.5, h);
    _path.lineTo(w * 0.4, h - 10);

    // Bottom left part
    _path.lineTo(radius, h - 10);

    // Bottom left corner
    _path.quadraticBezierTo(0, h - 10, 0, h - radius - 10);

    // Left edge
    _path.lineTo(0, radius);

    // Top left corner
    _path.quadraticBezierTo(0, 0, radius, 0);

    _path.close();
  }

  void _initializePaints() {
    _paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color;

    _paintFill = Paint()
      ..style = PaintingStyle.fill
      ..color = background;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw with cached path and paints
    canvas.drawPath(_path, _paintStroke);
    canvas.drawPath(_path, _paintFill);
  }

  @override
  bool shouldRepaint(covariant _RPSCustomPainter oldDelegate) {
    // Only repaint if properties have changed
    return oldDelegate.color != color ||
        oldDelegate.background != background ||
        oldDelegate.width != width;
  }
}
