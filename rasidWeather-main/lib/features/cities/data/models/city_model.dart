import 'dart:convert';

class CityModel {
  CityModel({
     this.locationId,
     this.name,
     this.isSelected,
     this.latitude,
     this.longitude,
     this.createdAt,
     this.countryCode,
     this.countryName,
     this.timezone,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        locationId: json['id'].toString(),
        name: json['location'].toString(),
        isSelected: json['selected'] as bool,
        latitude: json['latitude'].toString(),
        longitude: json['longitude'].toString(),
        countryCode: json['country_code'].toString(),
        createdAt: DateTime.parse(json['created_at'].toString()),
        countryName: json['country_name'].toString(),
        timezone: json['timezone'].toString(),
      );

  final String? locationId;
  final String? name;
  bool? isSelected;
  final String? latitude;
  final String? longitude;
  final DateTime? createdAt;
  final String? countryCode;
  final String? countryName;
  String? timezone;

  static Map<String, dynamic> toJson(CityModel location) => <String, dynamic>{
        'id': location.id,
        'location': location.name,
        'selected': location.isSelected,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'country_code': location.countryCode,
        'created_at': location.createdAt!.toIso8601String(),
        'country_name': location.countryName,
        'timezone': location.timezone,
      };

  // copyWith
  CityModel copyWith({
    String? locationId,
    String? name,
    bool? isSelected,
    String? latitude,
    String? longitude,
    DateTime? createdAt,
    String? countryCode,
    String? countryName,
    String? timezone,
  }) {
    return CityModel(
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      timezone: timezone ?? this.timezone,
    );
  }

  @override
  String toString() {
    return 'CityModel{id: $id, location: $name, selected: $isSelected, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, countryCode: $countryCode, countryName: $countryName, timezone: $timezone}';
  }

  static String encode(List<CityModel> locations) => json.encode(
        locations.map<Map<String, dynamic>>((CityModel x) => CityModel.toJson(x)).toList(),
      );

  static List<CityModel> decode(String locations) =>
      (json.decode(locations) as List<dynamic>).map<CityModel>((item) => CityModel.fromJson(item as Map<String, dynamic>)).toList();

  String get id => 'lat=$latitude&lon=$longitude';

  static Future<CityModel> withError(String s) {
    throw s;
  }
}
