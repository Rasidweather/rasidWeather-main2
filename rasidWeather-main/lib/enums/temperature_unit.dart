import 'package:flutter/widgets.dart';

enum TemperatureUnit {
  celsius,
  fahrenheit,
  kelvin,
}

extension TemperatureUnitExtension on TemperatureUnit {
  String get units {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'metric';
      case TemperatureUnit.kelvin:
        return 'standard';
      case TemperatureUnit.fahrenheit:
      return 'imperial';
    }
  }

  String get unitSymbol {
    switch (this) {
      case TemperatureUnit.celsius:
        return '\u00B0C';

      case TemperatureUnit.kelvin:
        return 'K';

      case TemperatureUnit.fahrenheit:
      return '\u00B0F';
    }
  }

  String getText(BuildContext context) {
    switch (this) {
      case TemperatureUnit.celsius:
        return 'Celsius';

      case TemperatureUnit.kelvin:
        return 'Kelvin';

      case TemperatureUnit.fahrenheit:
      return 'Fahrenheit';
    }
  }
}

TemperatureUnit getTemperatureUnit(
  String temperatureUnit,
) {
  switch (temperatureUnit) {
    case 'celsius':
      return TemperatureUnit.celsius;

    case 'kelvin':
      return TemperatureUnit.kelvin;

    case 'fahrenheit':
    default:
      return TemperatureUnit.fahrenheit;
  }
}
