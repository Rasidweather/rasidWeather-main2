import 'package:flutter/widgets.dart';

enum PressureUnit {
  hpa,
  inhg,
}

extension PressureUnitExtension on PressureUnit {
  String get units {
    switch (this) {
      case PressureUnit.hpa:
        return 'hpa';

      case PressureUnit.inhg:
      return 'inhg';
    }
  }

  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case PressureUnit.hpa:
        return 'hPa';

      case PressureUnit.inhg:
      return 'inHg';
    }
  }
}

PressureUnit getPressureUnit(
  String pressureUnit,
) {
  switch (pressureUnit) {
    case 'hpa':
      return PressureUnit.hpa;

    case 'inhg':
    default:
      return PressureUnit.inhg;
  }
}
