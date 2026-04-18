// import '../../features/weather/data/models/weather_model.dart';
// import 'weather_model.dart';
//
// class ChartModel {
//   ChartModel({
//     this.chartCurrent,
//     this.date,
//     this.chartHours,
//   });
//
//   factory ChartModel.fromJson(Map<String, dynamic> json) => ChartModel(
//         chartCurrent: json['current'] == null ? null : Current.fromJson(json['current'] as Map<String, dynamic>),
//         date: json['date'] == null ? null : DateTime.parse(json['date'].toString()),
//         chartHours:
//             json['hours'] == null ? <Hour>[] : List<Hour>.from((json['hours']! as Iterable).map((x) => Hour.fromJson(x as Map<String, dynamic>))),
//       );
//   final Current? chartCurrent;
//   final DateTime? date;
//   final List<Hour>? chartHours;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'current': chartCurrent?.toJson(),
//         'date': "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//         'hours': chartHours == null ? <Hour>[] : List<dynamic>.from(chartHours!.map((Hour x) => x.toJson())),
//       };
// }
//
// class Current {
//
//   Current({
//     this.forecastStart,
//     this.forecastEnd,
//     this.conditionCode,
//     this.maxUvIndex,
//     this.moonPhase,
//     this.moonrise,
//     this.moonset,
//     this.precipitationAmount,
//     this.precipitationAmountByType,
//     this.precipitationChance,
//     this.precipitationType,
//     this.snowfallAmount,
//     this.solarMidnight,
//     this.solarNoon,
//     this.sunrise,
//     this.sunriseCivil,
//     this.sunriseNautical,
//     this.sunriseAstronomical,
//     this.sunset,
//     this.sunsetCivil,
//     this.sunsetNautical,
//     this.sunsetAstronomical,
//     this.temperatureMax,
//     this.temperatureMin,
//     this.daytimeForecast,
//     this.overnightForecast,
//     this.restOfDayForecast,
//   });
//
//   factory Current.fromJson(Map<String, dynamic> json) => Current(
//         forecastStart: json['forecastStart'] == null ? null : DateTime.parse(json['forecastStart'].toString()),
//         forecastEnd: json['forecastEnd'] == null ? null : DateTime.parse(json['forecastEnd'].toString()),
//         conditionCode: json['conditionCode'].toString(),
//         maxUvIndex: json['maxUvIndex'] as int,
//         moonPhase: json['moonPhase'].toString(),
//         moonrise: json['moonrise'] == null ? null : DateTime.parse(json['moonrise'].toString()),
//         moonset: json['moonset'] == null ? null : DateTime.parse(json['moonset'].toString()),
//         precipitationAmount: double.parse(json['precipitationAmount'].toString()),
//         precipitationAmountByType: json['precipitationAmountByType'] == null
//             ? null
//             : PrecipitationAmountByType.fromJson(json['precipitationAmountByType'] as Map<String, dynamic>),
//         precipitationChance: double.parse(json['precipitationChance'].toString()),
//         precipitationType: json['precipitationType'].toString(),
//         snowfallAmount: double.parse(json['snowfallAmount'].toString()),
//         solarMidnight: json['solarMidnight'] == null ? null : DateTime.parse(json['solarMidnight'].toString()),
//         solarNoon: json['solarNoon'] == null ? null : DateTime.parse(json['solarNoon'].toString()),
//         sunrise: json['sunrise'] == null ? null : DateTime.parse(json['sunrise'].toString()),
//         sunriseCivil: json['sunriseCivil'] == null ? null : DateTime.parse(json['sunriseCivil'].toString()),
//         sunriseNautical: json['sunriseNautical'] == null ? null : DateTime.parse(json['sunriseNautical'].toString()),
//         sunriseAstronomical: json['sunriseAstronomical'] == null ? null : DateTime.parse(json['sunriseAstronomical'].toString()),
//         sunset: json['sunset'] == null ? null : DateTime.parse(json['sunset'].toString()),
//         sunsetCivil: json['sunsetCivil'] == null ? null : DateTime.parse(json['sunsetCivil'].toString()),
//         sunsetNautical: json['sunsetNautical'] == null ? null : DateTime.parse(json['sunsetNautical'].toString()),
//         sunsetAstronomical: json['sunsetAstronomical'] == null ? null : DateTime.parse(json['sunsetAstronomical'].toString()),
//         temperatureMax: double.parse(json['temperatureMax'].toString()),
//         temperatureMin: double.parse(json['temperatureMin'].toString()),
//         daytimeForecast: json['daytimeForecast'] == null ? null : Forecast.fromJson(json['daytimeForecast'] as Map<String, dynamic>),
//         overnightForecast: json['overnightForecast'] == null ? null : Forecast.fromJson(json['overnightForecast'] as Map<String, dynamic>),
//         restOfDayForecast: json['restOfDayForecast'] == null ? null : Forecast.fromJson(json['restOfDayForecast'] as Map<String, dynamic>),
//       );
//   final DateTime? forecastStart;
//   final DateTime? forecastEnd;
//   final String? conditionCode;
//   final int? maxUvIndex;
//   final String? moonPhase;
//   final DateTime? moonrise;
//   final DateTime? moonset;
//   final double? precipitationAmount;
//   final PrecipitationAmountByType? precipitationAmountByType;
//   final double? precipitationChance;
//   final String? precipitationType;
//   final double? snowfallAmount;
//   final DateTime? solarMidnight;
//   final DateTime? solarNoon;
//   final DateTime? sunrise;
//   final DateTime? sunriseCivil;
//   final DateTime? sunriseNautical;
//   final DateTime? sunriseAstronomical;
//   final DateTime? sunset;
//   final DateTime? sunsetCivil;
//   final DateTime? sunsetNautical;
//   final DateTime? sunsetAstronomical;
//   final double? temperatureMax;
//   final double? temperatureMin;
//   final Forecast? daytimeForecast;
//   final Forecast? overnightForecast;
//   final Forecast? restOfDayForecast;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'forecastStart': forecastStart?.toIso8601String(),
//         'forecastEnd': forecastEnd?.toIso8601String(),
//         'conditionCode': conditionCode,
//         'maxUvIndex': maxUvIndex,
//         'moonPhase': moonPhase,
//         'moonrise': moonrise?.toIso8601String(),
//         'moonset': moonset?.toIso8601String(),
//         'precipitationAmount': precipitationAmount,
//         'precipitationAmountByType': precipitationAmountByType?.toJson(),
//         'precipitationChance': precipitationChance,
//         'precipitationType': precipitationType,
//         'snowfallAmount': snowfallAmount,
//         'solarMidnight': solarMidnight?.toIso8601String(),
//         'solarNoon': solarNoon?.toIso8601String(),
//         'sunrise': sunrise?.toIso8601String(),
//         'sunriseCivil': sunriseCivil?.toIso8601String(),
//         'sunriseNautical': sunriseNautical?.toIso8601String(),
//         'sunriseAstronomical': sunriseAstronomical?.toIso8601String(),
//         'sunset': sunset?.toIso8601String(),
//         'sunsetCivil': sunsetCivil?.toIso8601String(),
//         'sunsetNautical': sunsetNautical?.toIso8601String(),
//         'sunsetAstronomical': sunsetAstronomical?.toIso8601String(),
//         'temperatureMax': temperatureMax,
//         'temperatureMin': temperatureMin,
//         'daytimeForecast': daytimeForecast?.toJson(),
//         'overnightForecast': overnightForecast?.toJson(),
//         'restOfDayForecast': restOfDayForecast?.toJson(),
//       };
// }
//
// class Forecast {
//
//   Forecast({
//     this.forecastStart,
//     this.forecastEnd,
//     this.cloudCover,
//     this.conditionCode,
//     this.humidity,
//     this.precipitationAmount,
//     this.precipitationAmountByType,
//     this.precipitationChance,
//     this.precipitationType,
//     this.snowfallAmount,
//     this.windDirection,
//     this.windSpeed,
//   });
//
//   factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
//         forecastStart: json['forecastStart'] == null ? null : DateTime.parse(json['forecastStart'].toString()),
//         forecastEnd: json['forecastEnd'] == null ? null : DateTime.parse(json['forecastEnd'].toString()),
//         cloudCover: double.parse(json['cloudCover'].toString()),
//         conditionCode: json['conditionCode'].toString(),
//         humidity: double.parse(json['humidity'].toString()),
//         precipitationAmount: double.parse(json['precipitationAmount'].toString()),
//         precipitationAmountByType: json['precipitationAmountByType'] == null
//             ? null
//             : PrecipitationAmountByType.fromJson(json['precipitationAmountByType'] as Map<String, dynamic>),
//         precipitationChance: double.parse(json['precipitationChance'].toString()),
//         precipitationType: json['precipitationType'].toString(),
//         snowfallAmount: double.parse(json['snowfallAmount'].toString()),
//         windDirection: double.parse(json['windDirection'].toString()),
//         windSpeed: double.parse(json['windSpeed'].toString()),
//       );
//   final DateTime? forecastStart;
//   final DateTime? forecastEnd;
//   final double? cloudCover;
//   final String? conditionCode;
//   final double? humidity;
//   final double? precipitationAmount;
//   final PrecipitationAmountByType? precipitationAmountByType;
//   final double? precipitationChance;
//   final String? precipitationType;
//   final double? snowfallAmount;
//   final double? windDirection;
//   final double? windSpeed;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'forecastStart': forecastStart?.toIso8601String(),
//         'forecastEnd': forecastEnd?.toIso8601String(),
//         'cloudCover': cloudCover,
//         'conditionCode': conditionCode,
//         'humidity': humidity,
//         'precipitationAmount': precipitationAmount,
//         'precipitationAmountByType': precipitationAmountByType?.toJson(),
//         'precipitationChance': precipitationChance,
//         'precipitationType': precipitationType,
//         'snowfallAmount': snowfallAmount,
//         'windDirection': windDirection,
//         'windSpeed': windSpeed,
//       };
// }
//
// class PrecipitationAmountByType {
//   PrecipitationAmountByType();
//
//   factory PrecipitationAmountByType.fromJson(Map<String, dynamic> json) => PrecipitationAmountByType();
//
//   Map<String, dynamic> toJson() => <String, dynamic>{};
// }
