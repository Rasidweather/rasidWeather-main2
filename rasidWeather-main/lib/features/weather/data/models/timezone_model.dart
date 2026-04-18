class TimezoneModel {
  TimezoneModel({
    this.sunrise,
    this.lng,
    this.countryCode,
    this.gmtOffset,
    this.rawOffset,
    this.sunset,
    this.timezoneId,
    this.dstOffset,
    this.countryName,
    this.time,
    this.lat,
  });

  factory TimezoneModel.fromJson(Map<String, dynamic> json) {
    return TimezoneModel(
      sunrise: json['sunrise'].toString(),
      lng: double.parse(json['lng'].toString()),
      countryCode: json['countryCode'].toString(),
      gmtOffset: json['gmtOffset'].toString(),
      rawOffset: json['rawOffset'].toString(),
      sunset: json['sunset'].toString(),
      timezoneId: json['timezoneId'].toString(),
      dstOffset: json['dstOffset'].toString(),
      countryName: json['countryName'].toString(),
      time: DateTime.parse(json['time'].toString()).toIso8601String(),
      lat: double.parse(json['lat'].toString()),
    );
  }
  final String? sunrise;
  final double? lng;
  final String? countryCode;
  final String? gmtOffset;
  final String? rawOffset;
  final String? sunset;
  final String? timezoneId;
  final String? dstOffset;
  final String? countryName;
  final String? time;
  final double? lat;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'sunrise': sunrise,
        'lng': lng,
        'countryCode': countryCode,
        'gmtOffset': gmtOffset,
        'rawOffset': rawOffset,
        'sunset': sunset,
        'timezoneId': timezoneId,
        'dstOffset': dstOffset,
        'countryName': countryName,
        'time': time,
        'lat': lat,
      };
}
