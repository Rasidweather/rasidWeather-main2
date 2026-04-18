// import 'dart:convert';
//
// class PlanModel {
//   PlanModel(
//       {this.id,
//       this.name,
//       this.description,
//       this.androidProductId,
//       this.iosProductId,
//       this.allFeatures,
//       this.createdAt,
//       this.duration,
//       this.updatedAt});
//
//   PlanModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'] as int;
//     name = json['name'].toString();
//     description = json['description'].toString();
//     androidProductId = json['android_product_id'].toString();
//     iosProductId = json['ios_product_id'].toString();
//     allFeatures = json['all_features'] as bool;
//     createdAt = json['created_at'].toString();
//     updatedAt = json['updated_at'].toString();
//     duration = int.parse(json['duration'].toString());
//     discount = json['discount'] == null ? null : double.parse(json['discount'].toString());
//   }
//
//   static PlanModel decode(String s) => PlanModel.fromJson(json.decode(s) as Map<String, dynamic>);
//   int? id;
//   String? name;
//   String? description;
//   String? androidProductId;
//   String? iosProductId;
//   bool? allFeatures;
//   String? createdAt;
//   String? updatedAt;
//   int? duration;
//   double? discount;
//
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'id': id,
//         'name': name,
//         'description': description,
//         'androidProductId': androidProductId,
//         'iosProductId': iosProductId,
//         'allFeatures': allFeatures,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//         'duration': duration,
//         'discount': discount,
//       };
//
//   String encode() {
//     return json.encode(toJson());
//   }
// }
import 'dart:convert';

class PlanModel {

  PlanModel({
    this.id,
    this.name,
    this.description,
    this.androidProductId,
    this.iosProductId,
    this.allFeatures,
    this.createdAt,
    this.updatedAt,
    this.duration,
    this.discount,
    this.price,
    this.priceRetail,
    this.revenuecatEntitlement,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    // helpers آمنة
    int? asInt(dynamic v) =>
        v == null ? null : (v is int ? v : int.tryParse(v.toString()));
    double? asDouble(dynamic v) =>
        v == null ? null : (v is num ? v.toDouble() : double.tryParse(v.toString()));
    bool? asBool(dynamic v) {
      if (v == null) return null;
      if (v is bool) return v;
      final String s = v.toString().toLowerCase();
      if (s == 'true') return true;
      if (s == 'false') return false;
      return null;
    }

    return PlanModel(
      id: asInt(json['id']),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      androidProductId: json['android_product_id']?.toString(),
      iosProductId: json['ios_product_id']?.toString(),
      allFeatures: asBool(json['all_features']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      duration: asInt(json['duration']),
      discount: asDouble(json['discount']),
      // لو API عندك يرجّع الأسعار بهذي المفاتيح
      price: asDouble(json['price']),
      priceRetail: asDouble(json['price_retail']),
      revenuecatEntitlement: json['revenuecat_entitlement']?.toString(),
    );
  }
  int? id;
  String? name;
  String? description;
  String? androidProductId;
  String? iosProductId;
  bool? allFeatures;
  String? createdAt;
  String? updatedAt;
  int? duration;
  double? discount;

  // أسعار اختيارية من الـ API (لو عندك)
  double? price;
  double? priceRetail;
  String? revenuecatEntitlement;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'description': description,
    'android_product_id': androidProductId,
    'ios_product_id': iosProductId,
    'all_features': allFeatures,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'duration': duration,
    'discount': discount,
    'price': price,
    'price_retail': priceRetail,
    'revenuecat_entitlement': revenuecatEntitlement,
  };

  String encode() => json.encode(toJson());

  static PlanModel decode(String s) =>
      PlanModel.fromJson(json.decode(s) as Map<String, dynamic>);
}
