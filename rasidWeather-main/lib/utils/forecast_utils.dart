import 'package:flutter/material.dart';

import '../enums/enums.dart';
import 'utils.dart';

num getTemperature(
  num? temperature, {
  TemperatureUnit unit = TemperatureUnit.celsius,
}) {
  if (temperature == null) {
    return 0;
  }

  switch (unit) {
    case TemperatureUnit.fahrenheit:
      return (temperature * (9 / 5) + 32).round();

    case TemperatureUnit.kelvin:
      return (temperature + 273.15).formatDecimal();

    case TemperatureUnit.celsius:
      return temperature.toDouble().round();
  }
}

String getTemperatureStr(num temperature, TemperatureUnit unit) =>
    '${temperature.round()}${getTemperatureUnitStr(unit)}';

Color getTemperatureColor(num temperature) {
  if (temperature > 100) {
    return Colors.red[900]!;
  } else if ((temperature > 90) && (temperature <= 100)) {
    return Colors.red;
  } else if ((temperature > 80) && (temperature <= 90)) {
    return Colors.deepOrange;
  } else if ((temperature > 70) && (temperature <= 80)) {
    return Colors.orange;
  } else if ((temperature > 60) && (temperature <= 70)) {
    return Colors.amber;
  } else if ((temperature > 50) && (temperature <= 60)) {
    return Colors.yellow;
  } else if ((temperature > 40) && (temperature <= 50)) {
    return Colors.lightGreen;
  } else if ((temperature > 30) && (temperature <= 40)) {
    return Colors.green;
  } else if ((temperature > 20) && (temperature <= 30)) {
    return Colors.cyan;
  } else if ((temperature > 10) && (temperature <= 20)) {
    return Colors.blue;
  } else if ((temperature > 0) && (temperature <= 10)) {
    return Colors.indigo;
  } else if ((temperature > -10) && (temperature <= 0)) {
    return Colors.purple;
  } else if ((temperature > -20) && (temperature <= -10)) {
    return Colors.deepPurple;
  } else if ((temperature > -30) && (temperature <= -20)) {
    return Colors.deepPurple[100]!;
  }

  return Colors.blueGrey[50]!;
}

String getTemperatureUnitStr(TemperatureUnit unit) {
  switch (unit) {
    case TemperatureUnit.celsius:
      return '°C';

    case TemperatureUnit.kelvin:
      return ' K';

    case TemperatureUnit.fahrenheit:
      return '°F';
  }
}

num getWindSpeed(double? windSpeed, {WindSpeedUnit unit = WindSpeedUnit.kmh}) {
  /// wind speed default km/h
  if (windSpeed == null) {
    return 0;
  }

  switch (unit) {
    case WindSpeedUnit.ms:
      return (windSpeed / 3.6).formatDecimal(decimals: 1);

    case WindSpeedUnit.mph:
      return (windSpeed / 1.60934).formatDecimal(decimals: 1);

    case WindSpeedUnit.kmh:
      return windSpeed.round();
  }
}

String getWindSpeedText(
  BuildContext context,
  double? windSpeed, {
  WindSpeedUnit unit = WindSpeedUnit.kmh,
}) {
  if (windSpeed == null) {
    return '0 ${unit.getText(context)}';
  }

  return '${getWindSpeed(windSpeed, unit: unit)} ${unit.getText(context)}';
}

num getPressure(num? pressure, PressureUnit unit) {
  if (pressure == null) {
    return 0;
  }

  switch (unit) {
    case PressureUnit.inhg:
      return (pressure / 33.863886666667).formatDecimal();

    case PressureUnit.hpa:
      return pressure.round();
  }
}

String getDistance(double? distance, {DistanceUnit unit = DistanceUnit.km}) {
  if (distance == null) {
    return '0';
  }

  switch (unit) {
    case DistanceUnit.mi:
      return (distance * 0.00062137).formatDecimal().toString();
    case DistanceUnit.km:
      return (distance * 0.001).round().toString();
  }
}

String getPressureText(BuildContext context, num? pressure, PressureUnit unit) {
  if (pressure == null) {
    return '0 ${unit.getText(context)}';
  }

  return '${getPressure(pressure, unit)} ${unit.getText(context)}';
}

String getHumidity(num? humidity) {
  if (humidity == null) {
    return '0%';
  }

  return '${humidity.toDouble().round()}%';
}

String getPrecipitationIntensity(num? precipitationIntensity) {
  if (precipitationIntensity == null) {
    return '0';
  }

  return precipitationIntensity.toString().convertToPercentage();
}

String getUnitSymbol(TemperatureUnit unit) {
  switch (unit) {
    case TemperatureUnit.fahrenheit:
      return '\u2109';

    case TemperatureUnit.celsius:
      return '\u2103';

    case TemperatureUnit.kelvin:
      return '\u212A';
  }
}

String getTitle(BuildContext context, num currentPage) {
  if (currentPage.toInt() == 1) {
    return 'Country';
  }

  return 'Edit Forecast';
}

DateTime getNextUpdateTime(DateTime dateTime) => dateTime.add(
  const Duration(
    milliseconds: 500,
    // milliseconds: AppConfig.instance.config.refreshTimeout,
  ),
);

double getScrollProgress({
  required double shrinkOffset,
  required double maxExtent,
  required double minExtent,
  double speed = 1.0,
  double clampUpper = 1.0,
  double clampLower = 0.0,
}) => ((shrinkOffset * speed) / (maxExtent - minExtent)).clamp(
  clampLower,
  clampUpper,
);

double getScrollScale({
  required double shrinkOffset,
  required double maxExtent,
  required double minExtent,
  double factor = 4.0,
}) {
  final double position =
      getScrollProgress(
        shrinkOffset: shrinkOffset,
        maxExtent: maxExtent,
        minExtent: minExtent,
      ) /
      factor;

  return 1.0 - position;
}

/// Return wind direction relative to plane heading
double getWindDirection({required num windDirection, num? heading}) {
  if (heading == null) {
    return windDirection.toDouble();
  }

  return ((windDirection - heading + 180) % 360) - 180;
}

String? formatHour({int? dateTime, String format = 'h:mm'}) {
  if (dateTime != null) {
    final DateTime dt = epochToDateTime(dateTime);
    final String formatted = formatDateTime(dt, format: format)!;
    return formatted;
  }

  return null;
}
