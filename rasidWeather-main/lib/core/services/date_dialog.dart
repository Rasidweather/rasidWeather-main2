import 'package:flutter/material.dart';

class DateDialog {
  static Future<DateTime?> datePicker(BuildContext context, {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2010),
      lastDate: lastDate ?? DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        // return Theme(
        //   data: Theme.of(context).copyWith(
        //     colorScheme: const ColorScheme.dark(
        //       primary: AppColors.primaryColor,
        //       surface: Color(0xFF1E1E1E),
        //     ),
        //   ),
        //   child: child!,
        // );
        return child!;
      },
    );
  }
}
