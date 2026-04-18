// import 'article_model.dart';
//
// class WeatherModel {
//   WeatherModel({
//     this.current,
//     this.hours,
//     this.thunderstormSummary,
//     this.days,
//   });
//
//   factory WeatherModel.fromJson(Map<String, dynamic> json) => WeatherModel(
//         current: json['current'] == null ? null : Current.fromJson(json['current'] as Map<String, dynamic>),
//         hours: json['hours'] == null ? <Hour>[] : List<Hour>.from((json['hours']! as Iterable).map((x) => Hour.fromJson(x as Map<String, dynamic>))),
//         thunderstormSummary: json['thunderstormSummary'] == null
//             ? <ThunderstormSummary>[]
//             : List<ThunderstormSummary>.from(
//                 (json['thunderstormSummary']! as Iterable).map((x) => ThunderstormSummary.fromJson(x as Map<String, dynamic>))),
//         days: json['days'] == null ? <Day>[] : List<Day>.from((json['days']! as Iterable).map((x) => Day.fromJson(x as Map<String, dynamic>))),
//       );
//   final Current? current;
//   final List<Hour>? hours;
//   final List<ThunderstormSummary>? thunderstormSummary;
//   final List<Day>? days;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'current': current?.toJson(),
//         'hours': hours == null ? <Hour>[] : List<dynamic>.from(hours!.map((Hour x) => x.toJson())),
//         'thunderstormSummary': thunderstormSummary == null
//             ? <ThunderstormSummary>[]
//             : List<dynamic>.from(thunderstormSummary!.map((ThunderstormSummary x) => x.toJson())),
//         'days': days == null ? <Day>[] : List<dynamic>.from(days!.map((Day x) => x.toJson())),
//       };
// }
//
// class ThunderstormSummary {
//   ThunderstormSummary({
//     this.conditionCode,
//     this.start,
//     this.end,
//     this.description,
//     this.conditionName,
//   });
//
//   factory ThunderstormSummary.fromJson(Map<String, dynamic> json) => ThunderstormSummary(
//         conditionCode: json['conditionCode'].toString(),
//         start: json['start'].toString(),
//         end: json['end'].toString(),
//         description: json['description'].toString(),
//         conditionName: json['conditionName'].toString(),
//       );
//   final String? conditionCode;
//   final String? start;
//   final String? end;
//   final String? description;
//   final String? conditionName;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'conditionCode': conditionCode,
//         'start': start,
//         'end': end,
//         'description': description,
//         'conditionName': conditionName,
//       };
// }
//
// class Current {
//   Current({
//     this.appearance,
//     this.featured,
//     this.meta,
//     this.temperatureMax,
//     this.temperatureMin,
//     this.windDirection,
//     this.windDirectionText,
//     this.windGust,
//     this.windGustKmPerHour,
//     this.windGustText,
//     this.windSpeedKmPerHoure,
//     this.windSpeed,
//     this.windSpeedText,
//     this.humidity,
//     this.humidityText,
//     this.visibility,
//     this.visibilityText,
//     this.uvIndex,
//     this.dewPoint,
//     this.pressure,
//     this.pressureTrend,
//     this.pressureTrendLabel,
//     this.pressureTrendDescription,
//     this.precipitation,
//     this.condition,
//     this.moon,
//     this.sunrise,
//     this.sunset,
//     this.cloudCover,
//     this.cloudCoverLowAltPct,
//     this.cloudCoverMidAltPct,
//     this.cloudCoverHighAltPct,
//     this.daylight,
//     this.precipitationIntensity,
//     this.temperature,
//     this.temperatureApparent,
//     this.temperatureDewPoint,
//     this.dewPointText,
//   });
//
//   factory Current.fromJson(Map<String, dynamic> json) => Current(
//         appearance: json['appearance'] == null ? null : Appearance.fromJson(json['appearance'] as Map<String, dynamic>),
//         featured: json['featured'] == null
//             ? <ArticleModel>[]
//             : List<ArticleModel>.from(
//                 (json['featured'] as List<dynamic>).map((dynamic x) => ArticleModel.fromJson(x as Map<String, dynamic>)),
//               ),
//         meta: json['meta'] == null ? null : Meta.fromJson(json['meta'] as Map<String, dynamic>),
//         temperatureMax: double.parse(json['temperatureMax'].toString()),
//         temperatureMin: double.parse(json['temperatureMin'].toString()),
//         windDirection: json['windDirection'] as int,
//         windDirectionText: json['windDirectionText'].toString(),
//         windGust: double.parse(json['windGust'].toString()),
//         windGustKmPerHour: json['windGustKmPerHour'].toString(),
//         windGustText: json['windGustText'].toString(),
//         windSpeedKmPerHoure: json['windSpeedKmPerHoure'].toString(),
//         windSpeed: double.parse(json['windSpeed'].toString()),
//         windSpeedText: json['windSpeedText'].toString(),
//         humidity: double.parse(json['humidity'].toString()),
//         humidityText: json['humidityText'].toString(),
//         visibility: double.parse(json['visibility'].toString()),
//         visibilityText: json['visibilityText'].toString(),
//         uvIndex: json['uvIndex'] == null ? null : UvIndex.fromJson(json['uvIndex'] as Map<String, dynamic>),
//         dewPoint: double.parse(json['dewPoint'].toString()),
//         pressure: double.parse(json['pressure'].toString()),
//         pressureTrend: json['pressureTrend'].toString(),
//         pressureTrendLabel: json['pressureTrendLabel'].toString(),
//         pressureTrendDescription: json['pressureTrendDescription'].toString(),
//         precipitation: json['precipitation'] == null ? null : Precipitation.fromJson(json['precipitation'] as Map<String, dynamic>),
//         condition: json['condition'] == null ? null : Condition.fromJson(json['condition'] as Map<String, dynamic>),
//         moon: json['moon'] == null ? null : CurrentMoon.fromJson(json['moon'] as Map<String, dynamic>),
//         sunrise: json['sunrise'] == null ? null : DateTime.parse(json['sunrise'].toString()),
//         sunset: json['sunset'] == null ? null : DateTime.parse(json['sunset'].toString()),
//         cloudCover: double.parse(json['cloudCover'].toString()),
//         cloudCoverLowAltPct: double.parse(json['cloudCoverLowAltPct'].toString()),
//         cloudCoverMidAltPct: double.parse(json['cloudCoverMidAltPct'].toString()),
//         cloudCoverHighAltPct: double.parse(json['cloudCoverHighAltPct'].toString()),
//         daylight: json['daylight'] as bool,
//         precipitationIntensity: double.parse(json['precipitationIntensity'].toString()),
//         temperature: double.parse(json['temperature'].toString()),
//         temperatureApparent: double.parse(json['temperatureApparent'].toString()),
//         temperatureDewPoint: double.parse(json['temperatureDewPoint'].toString()),
//         dewPointText: json['dewPointText'].toString(),
//       );
//   final Appearance? appearance;
//   final List<ArticleModel>? featured;
//   final Meta? meta;
//   final double? temperatureMax;
//   final double? temperatureMin;
//   final int? windDirection;
//   final String? windDirectionText;
//   final double? windGust;
//   final String? windGustKmPerHour;
//   final String? windGustText;
//   final String? windSpeedKmPerHoure;
//   final double? windSpeed;
//   final String? windSpeedText;
//   final double? humidity;
//   final String? humidityText;
//   final double? visibility;
//   final String? visibilityText;
//   final UvIndex? uvIndex;
//   final double? dewPoint;
//   final double? pressure;
//   final String? pressureTrend;
//   final String? pressureTrendLabel;
//   final String? pressureTrendDescription;
//   final Precipitation? precipitation;
//   final Condition? condition;
//   final CurrentMoon? moon;
//   final DateTime? sunrise;
//   final DateTime? sunset;
//   final double? cloudCover;
//   final double? cloudCoverLowAltPct;
//   final double? cloudCoverMidAltPct;
//   final double? cloudCoverHighAltPct;
//   final bool? daylight;
//   final double? precipitationIntensity;
//   final double? temperature;
//   final double? temperatureApparent;
//   final double? temperatureDewPoint;
//   final String? dewPointText;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'featured': featured == null ? <ArticleModel>[] : List<dynamic>.from(featured!.map((ArticleModel x) => x.toJson())),
//         'meta': meta?.toJson(),
//         'temperatureMax': temperatureMax,
//         'temperatureMin': temperatureMin,
//         'windDirection': windDirection,
//         'windDirectionText': windDirectionText,
//         'windGust': windGust,
//         'windGustKmPerHour': windGustKmPerHour,
//         'windGustText': windGustText,
//         'windSpeedKmPerHoure': windSpeedKmPerHoure,
//         'windSpeed': windSpeed,
//         'windSpeedText': windSpeedText,
//         'humidity': humidity,
//         'humidityText': humidityText,
//         'visibility': visibility,
//         'visibilityText': visibilityText,
//         'uvIndex': uvIndex?.toJson(),
//         'dewPoint': dewPoint,
//         'pressure': pressure,
//         'pressureTrend': pressureTrend,
//         'pressureTrendLabel': pressureTrendLabel,
//         'pressureTrendDescription': pressureTrendDescription,
//         'precipitation': precipitation?.toJson(),
//         'condition': condition?.toJson(),
//         'moon': moon?.toJson(),
//         'sunrise': sunrise?.toIso8601String(),
//         'sunset': sunset?.toIso8601String(),
//         'cloudCover': cloudCover,
//         'cloudCoverLowAltPct': cloudCoverLowAltPct,
//         'cloudCoverMidAltPct': cloudCoverMidAltPct,
//         'cloudCoverHighAltPct': cloudCoverHighAltPct,
//         'daylight': daylight,
//         'precipitationIntensity': precipitationIntensity,
//         'temperature': temperature,
//         'temperatureApparent': temperatureApparent,
//         'temperatureDewPoint': temperatureDewPoint,
//         'dewPointText': dewPointText,
//       };
// }
//
// class Appearance {
//   Appearance({
//     this.background,
//     this.backgroundVideo,
//     this.type,
//     this.textColor,
//     this.buttonColor,
//     this.cardBackground,
//     this.stops,
//   });
//
//   factory Appearance.fromJson(Map<String, dynamic> json) {
//     return Appearance(
//       background: json['type'] == 'video'
//           ? <String>['#ffffff', '#ffffff']
//           : json['background'] == null
//               ? <String>[]
//               : List<String>.from((json['background']! as List<dynamic>).map((dynamic x) => x)),
//       backgroundVideo: json['type'] == 'video' ? json['background'].toString() : null,
//       type: json['type'].toString(),
//       textColor: json['textColor'].toString(),
//       buttonColor: json['buttonColor'].toString(),
//       cardBackground: json['cardBackground'].toString(),
//       stops: json['stops'] == null ? <double>[] : List<double>.from((json['stops'] as List<dynamic>).map((x) => x.toDouble())),
//     );
//   }
//
//   final List<String>? background;
//   final String? backgroundVideo;
//   final String? type;
//   final String? textColor;
//   final String? buttonColor;
//   final String? cardBackground;
//   final List<double>? stops;
// }
//
// class Condition {
//   Condition({
//     this.conditionCode,
//     this.conditionName,
//     this.conditionEmoji,
//     this.conditionImageWhite,
//     this.conditionImageBlue,
//     this.conditionImage,
//     this.conditionIsAnimated,
//   });
//
//   factory Condition.fromJson(Map<String, dynamic> json) => Condition(
//         conditionCode: json['conditionCode'].toString(),
//         conditionName: json['conditionName'].toString(),
//         conditionEmoji: json['conditionEmoji'].toString(),
//         conditionImageWhite: json['conditionImageWhite'].toString(),
//         conditionImageBlue: json['conditionImageBlue'].toString(),
//         conditionImage: json['conditionImage'].toString(),
//         conditionIsAnimated: json['conditionIsAnimated'] as bool,
//       );
//   final String? conditionCode;
//   final String? conditionName;
//   final String? conditionEmoji;
//   final String? conditionImageWhite;
//   final String? conditionImageBlue;
//   final String? conditionImage;
//   final bool? conditionIsAnimated;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'conditionCode': conditionCode,
//         'conditionName': conditionName,
//         'conditionEmoji': conditionEmoji,
//         'conditionImageWhite': conditionImageWhite,
//         'conditionImageBlue': conditionImageBlue,
//         'conditionImage': conditionImage,
//         'conditionIsAnimated': conditionIsAnimated,
//       };
// }
//
// class Meta {
//   Meta({
//     this.asOf,
//     this.latitude,
//     this.longitude,
//   });
//
//   factory Meta.fromJson(Map<String, dynamic> json) => Meta(
//         asOf: json['asOf'] == null ? null : DateTime.parse(json['asOf'].toString()),
//         latitude: double.parse(json['latitude'].toString()),
//         longitude: double.parse(json['longitude'].toString()),
//       );
//   final DateTime? asOf;
//   final double? latitude;
//   final double? longitude;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'asOf': asOf?.toIso8601String(),
//         'latitude': latitude,
//         'longitude': longitude,
//       };
// }
//
// class CurrentMoon {
//   CurrentMoon({
//     this.moonPhase,
//     this.description,
//     this.moonTime,
//     this.moonrise,
//     this.moonset,
//     this.moonsetNext,
//   });
//
//   factory CurrentMoon.fromJson(Map<String, dynamic> json) => CurrentMoon(
//         moonPhase: json['moonPhase'].toString(),
//         description: json['description'].toString(),
//         moonTime: json['moonTime'].toString(),
//         moonrise: json['moonrise'] == null ? null : DateTime.parse(json['moonrise'].toString()),
//         moonset: json['moonset'] == null ? null : DateTime.parse(json['moonset'].toString()),
//         moonsetNext: json['moonsetNext'] == null ? null : DateTime.parse(json['moonsetNext'].toString()),
//       );
//   final String? moonPhase;
//   final String? description;
//   final String? moonTime;
//   final DateTime? moonrise;
//   final DateTime? moonset;
//   final DateTime? moonsetNext;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'moonPhase': moonPhase,
//         'description': description,
//         'moonTime': moonTime,
//         'moonrise': moonrise?.toIso8601String(),
//         'moonset': moonset?.toIso8601String(),
//         'moonsetNext': moonsetNext?.toIso8601String(),
//       };
// }
//
// class Precipitation {
//   Precipitation({
//     this.type,
//     this.label,
//     this.description,
//   });
//
//   factory Precipitation.fromJson(Map<String, dynamic> json) => Precipitation(
//         type: json['type'].toString(),
//         label: json['label'].toString(),
//         description: json['description'].toString(),
//       );
//   final String? type;
//   final String? label;
//   final String? description;
//
//   Map<String, String> toJson() => <String, String>{
//         'type': type!,
//         'label': label!,
//         'description': description!,
//       };
// }
//
// class UvIndex {
//   UvIndex({
//     this.uvIndex,
//     this.value,
//     this.level,
//     this.description,
//     this.colorName,
//     this.colorAsRgb,
//     this.colorAsHex,
//     this.maxUvIndex,
//   });
//
//   factory UvIndex.fromJson(Map<String, dynamic> json) => UvIndex(
//         uvIndex: json['uvIndex'] == null ? 0 : int.parse(json['uvIndex'].toString()),
//         value: json['value'] as int,
//         level: json['level'].toString(),
//         description: json['description'].toString(),
//         colorName: json['colorName'].toString(),
//         colorAsRgb: json['colorAsRGB'].toString(),
//         colorAsHex: json['colorAsHex'].toString(),
//         maxUvIndex: json['maxUvIndex'] == null ? 0 : int.parse(json['maxUvIndex'].toString()),
//       );
//   final int? uvIndex;
//   final int? value;
//   final String? level;
//   final String? description;
//   final String? colorName;
//   final String? colorAsRgb;
//   final String? colorAsHex;
//   final int? maxUvIndex;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'uvIndex': uvIndex,
//         'value': value,
//         'level': level,
//         'description': description,
//         'colorName': colorName,
//         'colorAsRGB': colorAsRgb,
//         'colorAsHex': colorAsHex,
//         'maxUvIndex': maxUvIndex,
//       };
// }
//
// class Day {
//   Day({
//     this.forecastStart,
//     this.forecastEnd,
//     this.condition,
//     this.maxUvIndex,
//     this.moon,
//     this.precipitationAmount,
//     this.precipitationAmountByType,
//     this.precipitationChance,
//     this.precipitation,
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
//   factory Day.fromJson(Map<String, dynamic> json) => Day(
//         forecastStart: json['forecastStart'] == null ? null : DateTime.parse(json['forecastStart'].toString()),
//         forecastEnd: json['forecastEnd'] == null ? null : DateTime.parse(json['forecastEnd'].toString()),
//         condition: json['condition'] == null ? null : Condition.fromJson(json['condition'] as Map<String, dynamic>),
//         maxUvIndex: json['maxUvIndex'] == null ? null : UvIndex.fromJson(json['maxUvIndex'] as Map<String, dynamic>),
//         moon: json['moon'] == null ? null : DayMoon.fromJson(json['moon'] as Map<String, dynamic>),
//         precipitationAmount: double.parse(json['precipitationAmount'].toString()),
//         precipitationAmountByType: json['precipitationAmountByType'] == null
//             ? null
//             : PrecipitationAmountByType.fromJson(json['precipitationAmountByType'] as Map<String, dynamic>),
//         precipitationChance: double.parse(json['precipitationChance'].toString()),
//         precipitation: json['precipitation'] == null ? null : Precipitation.fromJson(json['precipitation'] as Map<String, dynamic>),
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
//   final Condition? condition;
//   final UvIndex? maxUvIndex;
//   final DayMoon? moon;
//   final double? precipitationAmount;
//   final PrecipitationAmountByType? precipitationAmountByType;
//   final double? precipitationChance;
//   final Precipitation? precipitation;
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
//         'condition': condition?.toJson(),
//         'maxUvIndex': maxUvIndex?.toJson(),
//         'moon': moon?.toJson(),
//         'precipitationAmount': precipitationAmount,
//         'precipitationAmountByType': precipitationAmountByType?.toJson(),
//         'precipitationChance': precipitationChance,
//         'precipitation': precipitation?.toJson(),
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
//     this.condition,
//     this.overView,
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
//         condition: json['condition'] == null ? null : Condition.fromJson(json['condition'] as Map<String, dynamic>),
//         overView: json['overview'].toString(),
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
//   final Condition? condition;
//   final String? overView;
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
//         'condition': condition?.toJson(),
//         'overview': overView,
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
//
// class DayMoon {
//   DayMoon({
//     this.moonPhase,
//     this.description,
//     this.moonrise,
//     this.moonset,
//     this.moonTime,
//   });
//
//   factory DayMoon.fromJson(Map<String, dynamic> json) => DayMoon(
//         moonPhase: json['moonPhase'].toString(),
//         description: json['description'].toString(),
//         moonrise: json['moonrise'] == null ? null : DateTime.parse(json['moonrise'].toString()),
//         moonset: json['moonset'] == null ? null : DateTime.parse(json['moonset'].toString()),
//         moonTime: json['moonTime'] == null ? null : DateTime.parse(json['moonTime'].toString()),
//       );
//   final String? moonPhase;
//   final String? description;
//   final DateTime? moonrise;
//   final DateTime? moonset;
//   final DateTime? moonTime;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'moonPhase': moonPhase,
//         'description': description,
//         'moonrise': moonrise?.toIso8601String(),
//         'moonset': moonset?.toIso8601String(),
//         'moonTime': moonTime?.toIso8601String(),
//       };
// }
//
// class Hour {
//   Hour({
//     this.forecastStart,
//     this.cloudCover,
//     this.condition,
//     this.humidity,
//     this.precipitationAmount,
//     this.precipitationIntensity,
//     this.precipitationChance,
//     this.precipitation,
//     this.pressure,
//     this.pressureTrend,
//     this.pressureTrendLabel,
//     this.pressureTrendDescription,
//     this.snowfallIntensity,
//     this.snowfallAmount,
//     this.temperature,
//     this.temperatureApparent,
//     this.uvIndex,
//     this.visibility,
//     this.windDirection,
//     this.windDirectionText,
//     this.windGust,
//     this.windSpeed,
//     this.temperatureDewPoint,
//   });
//
//   factory Hour.fromJson(Map<String, dynamic> json) => Hour(
//         forecastStart: json['forecastStart'] == null ? null : DateTime.parse(json['forecastStart'].toString()),
//         cloudCover: double.parse(json['cloudCover'].toString()),
//         condition: json['condition'] == null ? null : Condition.fromJson(json['condition'] as Map<String, dynamic>),
//         humidity: double.parse(json['humidity'].toString()),
//         precipitationAmount: double.parse(json['precipitationAmount'].toString()),
//         precipitationIntensity: double.parse(json['precipitationIntensity'].toString()),
//         precipitationChance: double.parse(json['precipitationChance'].toString()),
//         precipitation: json['precipitation'] == null ? null : Precipitation.fromJson(json['precipitation'] as Map<String, dynamic>),
//         pressure: double.parse(json['pressure'].toString()),
//         pressureTrend: json['pressureTrend'].toString(),
//         pressureTrendLabel: json['pressureTrendLabel'].toString(),
//         pressureTrendDescription: json['pressureTrendDescription'].toString(),
//         snowfallIntensity: double.parse(json['snowfallIntensity'].toString()),
//         snowfallAmount: double.parse(json['snowfallAmount'].toString()),
//         temperature: double.parse(json['temperature'].toString()),
//         temperatureApparent: double.parse(json['temperatureApparent'].toString()),
//         uvIndex: json['uvIndex'] as int,
//         visibility: double.parse(json['visibility'].toString()),
//         windDirection: double.parse(json['windDirection'].toString()),
//         windDirectionText: json['windDirectionText'].toString(),
//         windGust: double.parse(json['windGust'].toString()),
//         windSpeed: double.parse(json['windSpeed'].toString()),
//         temperatureDewPoint: double.parse(json['temperatureDewPoint'].toString()),
//       );
//   final DateTime? forecastStart;
//   final double? cloudCover;
//   final Condition? condition;
//   final double? humidity;
//   final double? precipitationAmount;
//   final double? precipitationIntensity;
//   final double? precipitationChance;
//   final Precipitation? precipitation;
//   final double? pressure;
//   final String? pressureTrend;
//   final String? pressureTrendLabel;
//   final String? pressureTrendDescription;
//   final double? snowfallIntensity;
//   final double? snowfallAmount;
//   final double? temperature;
//   final double? temperatureApparent;
//   final int? uvIndex;
//   final double? visibility;
//   final double? windDirection;
//   final String? windDirectionText;
//   final double? windGust;
//   final double? windSpeed;
//   final double? temperatureDewPoint;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'forecastStart': forecastStart?.toIso8601String(),
//         'cloudCover': cloudCover,
//         'condition': condition?.toJson(),
//         'humidity': humidity,
//         'precipitationAmount': precipitationAmount,
//         'precipitationIntensity': precipitationIntensity,
//         'precipitationChance': precipitationChance,
//         'precipitation': precipitation?.toJson(),
//         'pressure': pressure,
//         'pressureTrend': pressureTrend,
//         'pressureTrendLabel': pressureTrendLabel,
//         'pressureTrendDescription': pressureTrendDescription,
//         'snowfallIntensity': snowfallIntensity,
//         'snowfallAmount': snowfallAmount,
//         'temperature': temperature,
//         'temperatureApparent': temperatureApparent,
//         'uvIndex': uvIndex,
//         'visibility': visibility,
//         'windDirection': windDirection,
//         'windDirectionText': windDirectionText,
//         'windGust': windGust,
//         'windSpeed': windSpeed,
//         'temperatureDewPoint': temperatureDewPoint,
//       };
// }
