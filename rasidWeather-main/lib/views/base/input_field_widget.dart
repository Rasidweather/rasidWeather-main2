import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'input_decoration.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.fillColor,
    this.onSubmit,
    this.onChanged,
    this.capitalization = TextCapitalization.none,
    this.onTap,
    this.isPassword = false,
    this.suffix,
    this.prefixIcon,
    this.isSearch = false,
    this.validator,
    this.readOnly = false,
    this.errorText,
  });

  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType keyboardType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isEnabled;
  final Function? onTap;
  final Function? onChanged;
  final Widget? suffix;
  final Widget? prefixIcon;
  final bool isSearch;
  final Function? onSubmit;
  final TextCapitalization capitalization;
  final String? Function(String?)? validator;
  final bool readOnly;
  final String? errorText;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 16,
          ),
      textInputAction: widget.inputAction,
      keyboardType: widget.keyboardType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      onChanged: widget.onChanged as void Function(String)?,
      onTap: widget.onTap as void Function()?,
      obscureText: widget.isPassword && _obscureText,
      validator: widget.validator,
      onFieldSubmitted: (String text) {
        if (widget.nextFocus != null) {
          FocusScope.of(context).requestFocus(widget.nextFocus);
        }
        if (widget.onSubmit != null) {
          widget.onSubmit!(text);
        }
      },
      inputFormatters: widget.keyboardType == TextInputType.phone
          ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))]
          : null,
      decoration: MyInputDecoration.build(
        context: context,
        fillColor: widget.fillColor ?? const Color(0xff3D3C3C).withOpacity(.1),
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        errorText: widget.errorText,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).hintColor.withOpacity(0.3),
                ),
                onPressed: _toggle,
              )
            : widget.suffix,
      ),
    );
  }
}
