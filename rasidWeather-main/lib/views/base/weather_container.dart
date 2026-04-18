import 'package:flutter/material.dart';

/// A container widget designed for weather-related content with customizable styling.
/// 
/// This widget provides a consistent card-like container with optional header,
/// leading widget, and customizable appearance through colors and gradients.
/// It is optimized for performance with:
/// - Efficient widget rebuilding
/// - Proper use of const constructors
/// - Static decoration building
/// - Memory-efficient color handling
class WeatherContainer extends StatelessWidget {
  /// Creates a weather container with customizable styling.
  /// 
  /// The [content] parameter is required and represents the main content of the container.
  /// The [header] and [leading] parameters are optional and will be displayed in a row
  /// at the top of the container if provided.
  /// 
  /// The [color] parameter defaults to a semi-transparent white.
  /// The [width] parameter will use 90% of screen width if not specified.
  const WeatherContainer({
    super.key,
    this.header,
    this.leading,
    required this.content,
    this.color = const Color(0x0fffffff),
    this.width,
    this.radius = _defaultRadius,
    this.padding = _defaultPadding,
    this.margin = EdgeInsets.zero,
    this.gradient,
  });

  /// The header widget to display at the top of the container
  final Widget? header;
  
  /// The leading widget to display at the top-right of the container
  final Widget? leading;
  
  /// The main content of the container
  final Widget content;
  
  /// The background color of the container
  final Color? color;
  
  /// The width of the container. Defaults to 90% of screen width if null
  final double? width;
  
  /// The corner radius of the container
  final double radius;
  
  /// The padding around the container's content
  final EdgeInsetsGeometry padding;
  
  /// The margin around the container
  final EdgeInsetsGeometry margin;
  
  /// An optional gradient to use instead of a solid color
  final Gradient? gradient;

  /// Default styling constants
  static const double _defaultRadius = 20;
  static const EdgeInsetsGeometry _defaultPadding = EdgeInsets.all(20);
  static const double _headerSpacing = 5.0;
  static const double _dividerHeight = 5.0;
  static const double _dividerThickness = 0.3;
  static const double _shadowBlur = 20.0;
  static const double _shadowOpacity = 0.1;
  static const double _dividerOpacity = 0.2;
  static const double _cardOpacity = 0.06;

  /// Builds the container's decoration with shadow and border radius
  static BoxDecoration _buildDecoration({
    required Color? color,
    required Gradient? gradient,
    required double radius,
  }) {
    return BoxDecoration(
      color: gradient == null ? color : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: const Color(0xff104084).withAlpha((_shadowOpacity * 255).round()),
          blurRadius: _shadowBlur,
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final double width = this.width ?? MediaQuery.sizeOf(context).width * .9;
    
    // Use a more efficient approach by avoiding nested containers and unnecessary repaints
    // Memoize commonly used values
    final BorderRadius cardBorderRadius = BorderRadius.circular(radius);
    const EdgeInsets headerPadding = EdgeInsets.only(bottom: _headerSpacing);
    final RoundedRectangleBorder cardBorder = RoundedRectangleBorder(borderRadius: cardBorderRadius);

    return RepaintBoundary(
      child: Card(
        margin: margin,
        elevation: 0,
        color: Colors.white.withAlpha((_cardOpacity * 255).round()),
        shape: cardBorder,
        child: Container(
          width: width,
          padding: padding,
          clipBehavior: Clip.antiAlias,
          decoration: _buildDecoration(
            color: color,
            gradient: gradient,
            radius: radius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (header != null || leading != null)
                _buildHeaderSection(
                  headerPadding: headerPadding,
                  dividerColor: color?.withAlpha((_dividerOpacity * 255).round()),
                ),
              content,
            ],
          ),
        ),
      ),
    );
    }

  /// Builds the header section with optional header and leading widgets
  Widget _buildHeaderSection({
    required EdgeInsetsGeometry headerPadding,
    required Color? dividerColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            if (header != null)
              Expanded(
                flex: 6,
                child: Padding(
                  padding: headerPadding,
                  child: header,
                ),
              ),
            if (header != null) const Spacer(),
            if (leading != null)
              Expanded(
                child: Padding(
                  padding: headerPadding,
                  child: leading,
                ),
              ),
          ],
        ),
        Divider(
          height: _dividerHeight,
          thickness: _dividerThickness,
          color: dividerColor,
        ),
      ],
    );
  }
}
