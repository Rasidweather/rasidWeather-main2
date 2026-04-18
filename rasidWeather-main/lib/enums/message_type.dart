import 'package:flutter/material.dart';

import '../core/themes/app_theme.dart';

enum MessageType {
  info,
  success,
  warning,
  danger,
}

extension MessageTypeExtension on MessageType {
  Color get color {
    switch (this) {
      case MessageType.success:
        return AppTheme.successColor;

      case MessageType.warning:
        return AppTheme.warningColor;

      case MessageType.danger:
        return AppTheme.dangerColor;

      case MessageType.info:
      return AppTheme.infoColor;
    }
  }
}
