import 'package:flutter/material.dart';

class MyInputDecoration {
  static InputDecoration build({
    required BuildContext context,
    String? hintText,
    String? labelText,
    Color? fillColor,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isDense = true,
    EdgeInsetsGeometry? contentPadding,
    String? errorText,
  }) {
    return InputDecoration(
      errorStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.error,
        fontSize: 12,
      ),
      focusedBorder: _getBorder(context),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.4),
        ),
      ),
      enabledBorder: _getBorder(context),
      border: _getBorder(context),
      isDense: isDense,
      hintText: hintText,
      labelText: labelText,
      errorText: errorText,
      fillColor: fillColor,
      hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
        fontSize: 12,
        color: Theme.of(context).hintColor.withOpacity(0.7),
      ),
      filled: true,
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 22,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  static OutlineInputBorder _getBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        width: 0,
        color: Theme.of(context).hintColor.withOpacity(0.7),
        // color: AppColors.cardBackgroundColor,
      ),
    );
  }
}
