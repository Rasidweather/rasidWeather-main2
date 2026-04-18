import 'package:equatable/equatable.dart';

import '../enums/enums.dart';

class Units extends Equatable {
  const Units({
    this.temperature = TemperatureUnit.celsius,
    this.windSpeed = WindSpeedUnit.kmh,
    this.pressure = PressureUnit.hpa,
    this.distance = DistanceUnit.km,
  });

  const Units.initial({
    this.temperature = TemperatureUnit.celsius,
    this.windSpeed = WindSpeedUnit.kmh,
    this.pressure = PressureUnit.hpa,
    this.distance = DistanceUnit.km,
  });
  final TemperatureUnit temperature;
  final WindSpeedUnit windSpeed;
  final PressureUnit pressure;
  final DistanceUnit distance;

  Units copyWith({
    TemperatureUnit? temperature,
    WindSpeedUnit? windSpeed,
    PressureUnit? pressure,
    DistanceUnit? distance,
  }) =>
      Units(
        temperature: temperature ?? this.temperature,
        windSpeed: windSpeed ?? this.windSpeed,
        pressure: pressure ?? this.pressure,
        distance: distance ?? this.distance,
      );

  static Units fromJson(dynamic json) => (json == null)
      ? const Units()
      : Units(
          temperature: getTemperatureUnit(json['temperatureUnit'].toString()),
          windSpeed: getWindSpeedUnit(json['windSpeedUnit'].toString()),
          pressure: getPressureUnit(json['pressureUnit'].toString()),
          distance: getDistanceUnit(json['distanceUnit'].toString()),
        );

  dynamic toJson() => <String, String>{
        'temperature': temperature.units,
        'windSpeed': windSpeed.units,
        'pressure': pressure.units,
        'distance': distance.units,
      };

  @override
  List<Object> get props => <Object>[
        temperature,
        windSpeed,
        pressure,
        distance,
      ];

  @override
  String toString() => 'Units{temperature: $temperature, windSpeed: $windSpeed, ' 'pressure: $pressure, distance: $distance}';
}
