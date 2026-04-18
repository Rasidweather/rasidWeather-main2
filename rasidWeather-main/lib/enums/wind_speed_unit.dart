import 'package:flutter/widgets.dart';

enum WindSpeedUnit {
  kmh,
  mph,
  ms,
}

extension WindSpeedUnitExtension on WindSpeedUnit {
  String get units {
    switch (this) {
      case WindSpeedUnit.kmh:
        return 'kmh';

      case WindSpeedUnit.ms:
        return 'ms';

      case WindSpeedUnit.mph:
      return 'mph';
    }
  }

  String getText(
    BuildContext context,
  ) {
    switch (this) {
      case WindSpeedUnit.kmh:
        return 'km/h';

      case WindSpeedUnit.ms:
        return 'm/s';

      case WindSpeedUnit.mph:
      return 'mph';
    }
  }
}

WindSpeedUnit getWindSpeedUnit(
  String windSpeedUnit,
) {
  switch (windSpeedUnit) {
    case 'kmh':
      return WindSpeedUnit.kmh;

    case 'ms':
      return WindSpeedUnit.ms;

    case 'mph':
    default:
      return WindSpeedUnit.mph;
  }
}
