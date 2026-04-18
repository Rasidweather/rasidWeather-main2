import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../features/weather/data/models/weather_model.dart';
import '../../utils/ui_utils.dart';
import 'index.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.errorMessage, this.onPressed});

  final String errorMessage;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return UiWidget(child: (Appearance ui) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              color: convertHexaToColor(ui.textColor!),
              size: 50.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              'common.error'.tr(),
              style: TextStyle(
                color: convertHexaToColor(ui.textColor!),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: convertHexaToColor(ui.textColor!),
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10.0),
            if (onPressed != null)
              ElevatedButton(
                onPressed: () => onPressed!(),
                child:  Text('common.retry'.tr()),
              ),
          ],
        ),
      );
    });
  }
}
