import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/dimensions.dart';
import 'input_decoration.dart';

/// A customizable input field widget with various styling and functionality options.
///
/// This widget provides a consistent input field design with features like:
/// - Password visibility toggle
/// - Custom styling
/// - Input formatting
/// - Focus management
/// - Input validation
class InputField extends StatelessWidget {
  /// Creates a custom input field with various customization options.
  const InputField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.keyboardType = _defaultKeyboardType,
    this.inputAction = _defaultInputAction,
    this.maxLines = _defaultMaxLines,
    this.fillColor,
    this.onSubmit,
    this.onChanged,
    this.capitalization = _defaultCapitalization,
    this.onTap,
    this.isPassword = false,
    this.suffix,
    this.prefixIcon,
    this.isSearch = false,
    this.onValidate,
    this.readOnly = false,
    this.inputFormatters,
  });

  /// The hint text to display when the input is empty
  final String? hintText;

  /// The label text to display above the input
  final String? labelText;

  /// The controller for managing the input text
  final TextEditingController? controller;

  /// The focus node for this input field
  final FocusNode? focusNode;

  /// The focus node to move to when submitting this field
  final FocusNode? nextFocus;

  /// The type of keyboard to display
  final TextInputType keyboardType;

  /// The action to take when submitting the input
  final TextInputAction inputAction;

  /// The background color of the input field
  final Color? fillColor;

  /// The maximum number of lines for the input
  final int maxLines;

  /// Whether this is a password field
  final bool isPassword;

  /// Whether the input field is enabled
  final bool isEnabled;

  /// Callback when the input is tapped
  final Function? onTap;

  /// Callback when the input text changes
  final Function? onChanged;

  /// Widget to display at the end of the input field
  final Widget? suffix;

  /// Widget to display at the start of the input field
  final Widget? prefixIcon;

  /// Whether this is a search input field
  final bool isSearch;

  /// Callback when the input is submitted
  final Function? onSubmit;

  /// The type of text capitalization to apply
  final TextCapitalization capitalization;

  /// Validator function for the input
  final String? Function(String?)? onValidate;

  /// Whether the input field is read-only
  final bool readOnly;

  /// Input formatters to apply to the input
  final List<TextInputFormatter>? inputFormatters;

  /// Static constants for styling and functionality
  static final List<TextInputFormatter> _defaultPhoneFormatters = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
  ];

  static const EdgeInsets _iconPadding = EdgeInsets.zero;
  static const double _iconSize = 24.0;
  static const int _defaultMaxLines = 1;
  static const TextInputAction _defaultInputAction = TextInputAction.next;
  static const TextInputType _defaultKeyboardType = TextInputType.text;
  static const TextCapitalization _defaultCapitalization = TextCapitalization.none;
  static const double _iconOpacity = 0.3;

  /// The static password visibility notifier
  static final ValueNotifier<bool> _passwordVisibilityNotifier = ValueNotifier<bool>(true);

  /// Disposes of the static notifier - call this in your app's dispose method
  static void disposeNotifier() {
    _passwordVisibilityNotifier.dispose();
  }

  /// Gets the text style for the input field
  TextStyle _getTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontSize: Dimensions.fontSizeLarge,
        );
  }

  /// Creates the password toggle icon button
  Widget _createPasswordToggle(BuildContext context, bool isObscured) {
    return IconButton(
      padding: _iconPadding,
      iconSize: _iconSize,
      icon: Icon(
        isObscured ? Icons.visibility_off : Icons.visibility,
        color: Theme.of(context).hintColor.withAlpha((_iconOpacity * 255).round()),
      ),
      onPressed: () => _passwordVisibilityNotifier.value = !_passwordVisibilityNotifier.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _passwordVisibilityNotifier,
      builder: (BuildContext context, bool isObscured, _) {
        return TextFormField(
          readOnly: readOnly,
          maxLines: maxLines,
          controller: controller,
          focusNode: focusNode,
          style: _getTextStyle(context),
          textInputAction: inputAction,
          keyboardType: keyboardType,
          cursorColor: Theme.of(context).primaryColor,
          textCapitalization: capitalization,
          enabled: isEnabled,
          onChanged: onChanged as void Function(String)?,
          onTap: onTap as void Function()?,
          obscureText: isPassword && isObscured,
          validator: onValidate,
          onFieldSubmitted: (String text) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            }
            onSubmit?.call(text);
          },
          inputFormatters: keyboardType == TextInputType.phone 
              ? inputFormatters ?? _defaultPhoneFormatters 
              : null,
          decoration: MyInputDecoration.build(
            context: context,
            hintText: hintText,
            labelText: labelText ?? hintText,
            fillColor: fillColor,
            prefixIcon: prefixIcon,
            suffixIcon: isPassword 
                ? _createPasswordToggle(context, isObscured)
                : suffix,
          ),
        );
      },
    );
  }
}
