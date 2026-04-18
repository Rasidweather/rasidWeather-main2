import 'dart:convert';

String searchToJson(Search data) => json.encode(data.toJson());

class Search {
  Search({
    this.totalResultsCount,
    this.geonames,
  });

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        totalResultsCount: json['totalResultsCount'] as int,
        geonames: List<Geoname>.from((json['geonames'] as List<Geoname>).map((Geoname x) {
          return x;
          // return Geoname.fromJson(x);
        })),
      );

  final int? totalResultsCount;
  final List<Geoname>? geonames;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'totalResultsCount': totalResultsCount,
        'geonames': List<dynamic>.from(geonames!.map((Geoname x) => x.toJson())),
      };
}

class Geoname {
  Geoname({
    this.adminCode1,
    this.lng,
    this.geonameId,
    this.toponymName,
    this.countryId,
    this.fcl,
    this.population,
    this.countryCode,
    this.name,
    this.fclName,
    this.adminCodes1,
    this.countryName,
    this.fcodeName,
    this.adminName1,
    this.lat,
    this.fcode,
  });

  factory Geoname.fromJson(Map<String, dynamic> json) => Geoname(
        adminCode1: json['adminCode1']?.toString(),
        lng: json['lng'].toString(),
        geonameId: json['geonameId'] as int,
        toponymName: json['toponymName'].toString(),
        countryId: json['countryId'].toString(),
        fcl: json['fcl'].toString(),
        population: json['population'] as int,
        countryCode: json['countryCode'].toString(),
        name: json['name'].toString(),
        fclName: json['fclName'].toString(),
        adminCodes1: json['adminCodes1'] == null ? null : AdminCodes1.fromJson(json['adminCodes1'] as Map<String, dynamic>),
        countryName: json['countryName'].toString(),
        fcodeName: json['fcodeName'].toString(),
        adminName1: json['adminName1'].toString(),
        lat: json['lat'].toString(),
        fcode: json['fcode'].toString(),
      );

  final String? adminCode1;
  final String? lng;
  final int? geonameId;
  final String? toponymName;
  final String? countryId;
  final String? fcl;
  final int? population;
  final String? countryCode;
  final String? name;
  final String? fclName;
  final AdminCodes1? adminCodes1;
  final String? countryName;
  final String? fcodeName;
  final String? adminName1;
  final String? lat;
  final String? fcode;

  static List<Geoname> fromJsonList(List<dynamic> list) {
    return list.map((item) => Geoname.fromJson(item as Map<String, dynamic>)).toList();
  }

  String get id => 'lat=$lat&lon=$lng';

  Map<String, dynamic> toJson() => <String,dynamic >{
        'adminCode1': adminCode1,
        'lng': lng,
        'geonameId': geonameId,
        'toponymName': toponymName,
        'countryId': countryId,
        'fcl': fcl,
        'population': population,
        'countryCode': countryCode,
        'name': name,
        'fclName': fclName,
        'adminCodes1': adminCodes1?.toJson(),
        'countryName': countryName,
        'fcodeName': fcodeName,
        'adminName1': adminName1,
        'lat': lat,
        'fcode': fcode,
      };
}

class AdminCodes1 {
  AdminCodes1({
    this.iso31662,
  });

  factory AdminCodes1.fromJson(Map<String, dynamic> json) => AdminCodes1(
        iso31662: json['ISO3166_2'].toString(),
      );

  final String? iso31662;

  Map<String, dynamic> toJson() => <String,dynamic>{
        'ISO3166_2': iso31662,
      };
}
