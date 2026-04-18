import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/dimensions.dart';

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
  }) {
    return InputDecoration(
      errorStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.error,
            fontSize: Dimensions.fontSizeSmall,
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
          color: Theme.of(context).primaryColor.withAlpha((0.4 * 255).round()),
        ),
      ),
      enabledBorder: _getBorder(context),
      border: _getBorder(context),
      isDense: isDense,
      hintText: hintText,
      labelText: labelText,
      fillColor: fillColor ?? AppColors.cardBackgroundColor,
      hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).hintColor.withAlpha((0.7 * 255).round()),
          ),
      filled: true,
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
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
        width: .5,
        color: AppColors.backgroundColor,
      ),
    );
  }
}
