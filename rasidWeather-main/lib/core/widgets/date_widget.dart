import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../services/date_dialog.dart';

class DateWidget extends StatelessWidget {

  const DateWidget({super.key, required this.onDateChanged, required this.title});
  // ignore: inference_failure_on_function_return_type
  final Function(DateTime) onDateChanged;
  final String title;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await DateDialog.datePicker(context);

    if (pickedDate != null) {
      onDateChanged(pickedDate);
    }
    // if (pickedDate != null) {
    //   setState(() {
    //     if (isStartDate) {
    //       _startDate = pickedDate;
    //     } else {
    //       _endDate = pickedDate;
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectDate(context, false);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.cardBackgroundColor,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
            ),
            Icon(
              Icons.calendar_month,
              color: AppColors.backgroundColor,
            )
          ],
        ),
      ),
    );
  }
}
