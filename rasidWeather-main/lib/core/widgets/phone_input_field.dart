import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'input_field_widget.dart';

class PhoneInputField extends StatefulWidget {

  const PhoneInputField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.focusNode,
    this.nextFocus,
    this.onChanged,
    this.inputAction = TextInputAction.next,
    this.onValidate,
  });
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  // ignore: inference_failure_on_function_return_type
  final Function(String)? onChanged;
  final TextInputAction inputAction;
  final String? Function(String?)? onValidate;

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController();
    
    if (widget.controller != null && widget.controller!.text.isNotEmpty) {
      // Initialize display value from the main controller
      final String text = widget.controller!.text;
      if (text.startsWith('+966')) {
        _displayController.text = text.substring(4);
      } else {
        _displayController.text = text;
        // Update the main controller with the prefix
        widget.controller?.text = '+966$text';
      }
    }
  }

  void _updateMainController(String value) {
    if (widget.controller != null) {
      // Update the main controller with the prefix
      widget.controller?.text = value.isEmpty ? '' : '+966$value';
    }
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputField(
      controller: _displayController,
      hintText: widget.hintText ?? 'common.phone_number'.tr(),
      labelText: widget.labelText,
      focusNode: widget.focusNode,
      nextFocus: widget.nextFocus,
      onChanged: (String? value) {
        // Update the main controller
        _updateMainController(value!);
        
        // Notify parent if needed
        if (widget.onChanged != null) {
          widget.onChanged!(value.isEmpty ? '' : '+966$value');
        }
      },
      inputAction: widget.inputAction,
      keyboardType: TextInputType.phone,
      suffix: const SizedBox(
        width: 100,
        child: Center(
          child: Text(
            '| 966',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
      onValidate: (String? value) {
        if (value == null || value.isEmpty) {
          return 'users.form.phone_number_required'.tr();
        }

        // Remove any spaces or special characters
        value = value.replaceAll(RegExp(r'\s+'), '');
        
        // Saudi mobile numbers start with 5 and are 9 digits long
        if (!RegExp(r'^5[0-9]{8}$').hasMatch(value)) {
          return 'users.validation.phone_number_invalid'.tr();
        }
        
        // If we have external validation, run it with the full number
        if (widget.onValidate != null) {
          return widget.onValidate!('+966$value');
        }
        
        return null;
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        LengthLimitingTextInputFormatter(9),
        _SaudiPhoneFormatter(),
      ],
    );
  }
}

class _SaudiPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only allow digits
    final String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // // Ensure the number starts with 5
    // if (text.isNotEmpty && text[0] != '5') {
    //   text = '5${text.substring(1)}';
    // }

    // Format the number with spaces: 5XX XXX XXXX
    // var newText = '';
    // for (var i = 0; i < text.length; i++) {
    //   if (i == 3 || i == 6) {
    //     newText += ' ';
    //   }
    //   newText += text[i];
    // }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
