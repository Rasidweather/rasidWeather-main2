import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';



class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.onPressed, required this.title, required this.subtitle, this.buttonText, this.icon, this.message, this.message1, this.onTap});

  final String title;
  final String subtitle;
  final IconData? icon;
  final void Function()? onPressed;
  final String? buttonText;
  final String? message;
  final String? message1;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon ?? Icons.error_outline,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 10),
          Text(
            message ?? 'common.empty_state'.tr(),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          if (message1 != null) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              message1!,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
          if (onTap != null) ...<Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onTap,
              child: Text('common.retry'.tr()),
            ),
          ],
        ],
      ),
    );
  }
}
