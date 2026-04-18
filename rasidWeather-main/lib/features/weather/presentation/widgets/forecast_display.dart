import 'package:flutter/material.dart';

/// A widget that displays weather forecast information with value and unit.
/// 
/// This widget provides two layout options:
/// - Row layout: displays description, value, and unit in a horizontal arrangement
/// - Column layout: displays value and unit in a vertical arrangement
@immutable
class ForecastDisplay extends StatelessWidget {
  /// Creates a forecast display widget.
  ///
  /// The [value], [style], and [unit] parameters are required.
  /// The [unitSizeFactor] must be greater than or equal to 1.0.
  const ForecastDisplay({
    super.key,
    required this.value,
    this.description = '',
    required this.style,
    this.unitAlignment = Alignment.centerRight,
    this.unitSizeFactor = 3.5,
    required this.unit,
    this.row = true,
    this.spacing = 3.0,
  }) : assert(unitSizeFactor >= 1.0, 'unitSizeFactor must be at least 1.0');

  /// The main value to display (e.g., temperature number).
  final String value;

  /// The description text to show before the value (only used in row layout).
  final String description;

  /// The base text style for the value and description.
  final TextStyle style;

  /// The alignment of the unit text.
  final Alignment unitAlignment;

  /// The factor by which to divide the base font size for the unit text.
  /// Must be at least 1.0.
  final double unitSizeFactor;

  /// The unit text to display (e.g., °C, %, mph).
  final String unit;

  /// Whether to display in a row (true) or column (false) layout.
  final bool row;

  /// The spacing between elements when in column layout.
  final double spacing;

  /// Computes the text style for the unit based on the main style.
  TextStyle get unitStyle {
    final double baseSize = style.fontSize ?? 16.0; // Default size if fontSize is not specified
    return style.copyWith(
      fontSize: baseSize / unitSizeFactor,
      height: style.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return row ? _buildRowLayout() : _buildColumnLayout();
  }

  /// Builds the row layout with description, value, and unit.
  Widget _buildRowLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Text(
              description,
              style: style,
            ),
          ),
        _ValueWithUnit(
          value: value,
          unit: unit,
          style: style,
          unitStyle: unitStyle,
          unitAlignment: unitAlignment,
        ),
      ],
    );
  }

  /// Builds the column layout with value and unit.
  Widget _buildColumnLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          value,
          style: style,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Align(
            alignment: unitAlignment,
            child: Text(
              unit,
              style: unitStyle,
            ),
          ),
        ),
      ],
    );
  }
}

/// A widget that displays a value with its unit in a compact layout.
/// 
/// This is an internal widget used by [ForecastDisplay] to reduce rebuild costs.
class _ValueWithUnit extends StatelessWidget {
  const _ValueWithUnit({
    required this.value,
    required this.unit,
    required this.style,
    required this.unitStyle,
    required this.unitAlignment,
  });

  final String value;
  final String unit;
  final TextStyle style;
  final TextStyle unitStyle;
  final Alignment unitAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: style,
        ),
        SizedBox(
          height: style.fontSize,
          child: Align(
            alignment: unitAlignment,
            child: Text(
              unit,
              style: unitStyle,
            ),
          ),
        ),
      ],
    );
  }
}
