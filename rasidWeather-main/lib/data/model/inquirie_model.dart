class InquiryModelBody {
  InquiryModelBody({
    this.data,
    this.meta,
  });

  factory InquiryModelBody.fromJson(Map<String, dynamic> json) => InquiryModelBody(
        data: json['data'] == null
            ? <InquiryModel>[]
            : List<InquiryModel>.from((json['data']! as List<InquiryModel>).map((InquiryModel x) {
                return x;
                // return InquiryModel.fromJson(x);
              })),
        meta: json['meta'] == null ? null : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      );
  final List<InquiryModel>? data;
  final Meta? meta;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data == null ? <InquiryModel>[] : List<dynamic>.from(data!.map((InquiryModel x) => x.toJson())),
        'meta': meta?.toJson(),
      };
}

class InquiryModel {
  InquiryModel(
      {this.id,
      this.userId,
      this.name,
      this.email,
      this.phone,
      this.message,
      this.hasSupportReply,
      this.status,
      this.type,
      this.createdAt,
      this.updatedAt});

  InquiryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    name = json['name'].toString();
    email = json['email'].toString();
    phone = json['phone'].toString();
    message = json['message'].toString();
    hasSupportReply = !(json['has_support_reply'] == null) && json['has_support_reply'] as bool;
    status = json['status'].toString();
    type = json['type'].toString();
    createdAt = json['created_at'] == null ? null : DateTime.parse(json['created_at'].toString());
    updatedAt = json['updated_at'] == null ? null : DateTime.parse(json['updated_at'].toString());
  }
  String? id;
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? message;
  bool? hasSupportReply;
  String? status;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['message'] = message;
    data['has_support_reply'] = hasSupportReply;
    data['status'] = status;
    data['type'] = type;
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }
}

class Meta {
  Meta({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.from,
    this.to,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json['total'] as int,
        perPage: json['per_page'] as int,
        currentPage: json['current_page'] as int,
        lastPage: json['last_page'] as int,
        from: json['from'] as int,
        to: json['to'] as int,
      );
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final int? from;
  final int? to;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'total': total,
        'per_page': perPage,
        'current_page': currentPage,
        'last_page': lastPage,
        'from': from,
        'to': to,
      };
}
