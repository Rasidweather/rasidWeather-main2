import 'package:intl/intl.dart';

double? intToDouble(dynamic value) {
  if (value.runtimeType == double) {
    return value as double;
  } else if (value.runtimeType == int)
    return value as double;
  else
    throw Exception('$value is not of type int or double.');
}

String readTimestamp(int timestamp) {
  final DateTime now = DateTime.now();
  final DateFormat format = DateFormat('HH:mm a');
  final DateTime date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  final Duration diff = date.difference(now);
  String time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = '${diff.inDays}DAY AGO';
    } else {
      time = '${diff.inDays}DAYS AGO';
    }
  }

  return time;
}

enum Unit { CELSIUS, FAHRENHEIT }

class Temperature {
  Temperature(this._temperature);
  final double _temperature;

  String get celsius => '${(_temperature - 273.15).round()}\u2103';

  String get fahrenheit => '${(_temperature * 9 / 5 - 459.67).round()}\u2109';

  double? get celsiusAsDouble => intToDouble((_temperature - 273.15).round());

  double? get fahrenheitAsDouble => intToDouble((_temperature * 9 / 5 - 459.67).round());

  String as(Unit unit) {
    switch (unit) {
      case Unit.CELSIUS:
        return celsius;
      case Unit.FAHRENHEIT:
        return fahrenheit;
    }
  }

  double? asDouble(Unit unit) {
    switch (unit) {
      case Unit.CELSIUS:
        return celsiusAsDouble;
      case Unit.FAHRENHEIT:
        return fahrenheitAsDouble;
    }
  }
}
