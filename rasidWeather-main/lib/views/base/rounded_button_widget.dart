import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'rounded_loading_button.dart';

class RoundedButtonWidget extends StatelessWidget {
  const RoundedButtonWidget({
    super.key,
    required this.title,
    this.onPressed,
    required this.controller,
    this.icon,
    this.color = Colors.black,
    this.loadingText,
  });

  final String title;
  final void Function()? onPressed;
  final IconData? icon;
  final RoundedLoadingButtonController controller;
  final Color? color;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ButtonState>(
      stream: controller.stateStream,
      initialData: controller.currentState,
      builder: (BuildContext context, AsyncSnapshot<ButtonState> snapshot) {
        final bool isLoading = snapshot.data == ButtonState.loading;
        
        return RoundedLoadingButton(
          height: 40.h,
          controller: controller,
          onPressed: onPressed,
          width: MediaQuery.of(context).size.width * 0.80,
          color: color,
          elevation: 0,
          borderRadius: 10,
          child: Wrap(children: <Widget>[
            if (icon != null && !isLoading) Icon(icon, size: 20.sp, color: Colors.white),
            if (icon != null && !isLoading) const SizedBox(width: 15),
            Text(
              isLoading && loadingText != null ? loadingText! : title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ]),
        );
      }
    );
  }
}
