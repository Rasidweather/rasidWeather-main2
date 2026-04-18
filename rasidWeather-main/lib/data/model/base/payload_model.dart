import 'dart:convert';

class PayloadModel {
  PayloadModel({
    this.id,
    this.title,
    this.content,
    this.actionUrl,
    this.reviewableType,
    this.reviewableId,
    this.type,
    this.isVideo,
    this.image,
    this.createdAt,
    this.seen = false,
  });

  factory PayloadModel.fromJson(Map<String, dynamic> json) {
    return PayloadModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      actionUrl: json['actionUrl']?.toString() ?? '',
      reviewableType: json['reviewable_type']?.toString() ?? '',
      reviewableId: json['reviewable_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      isVideo: json['isVideo']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      seen: json['seen'] == 1 || json['seen'] == '1',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now() : DateTime.now(),
    );
  }

  final int? id;
  final String? title;
  final String? content;
  final String? actionUrl;
  final String? reviewableType;
  final String? reviewableId;
  final String? type;
  final String? isVideo;
  final String? image;
  final DateTime? createdAt;
  final bool seen;

  static Map<String, dynamic> toJson(PayloadModel payload) => <String, dynamic>{
        'id': payload.id,
        'title': payload.title,
        'content': payload.content ?? '',
        'actionUrl': payload.actionUrl ?? '',
        'reviewable_type': payload.reviewableType ?? '',
        'reviewable_id': payload.reviewableId ?? '',
        'type': payload.type ?? '',
        'isVideo': payload.isVideo ?? '',
        'seen': payload.seen ? '1' : '0',
        'image': payload.image ?? '',
        'created_at': payload.createdAt?.toIso8601String(),
      };

  static List<String> get columnNames => <String>[
        'id',
        'title',
        'content',
        'actionUrl',
        'reviewable_type',
        'reviewable_id',
        'type',
        'isVideo',
        'image',
        'created_at',
        'seen',
      ];

  @override
  String toString() {
    return 'PayloadModel{id: $id, title: $title, content: $content, actionUrl: $actionUrl, isVideo: $isVideo, reviewable_type: $reviewableType, reviewable_id: $reviewableId, type: $type, seen: $seen, image: $image, created_at: $createdAt}';
  }

  static String encode(List<PayloadModel> locations) => json.encode(
        locations
            .map<Map<String, dynamic>>(
              (PayloadModel payload) => PayloadModel.toJson(payload),
            )
            .toList(),
      );

  static List<PayloadModel> decode(dynamic payloads) {
    if (payloads == null) {
      return <PayloadModel>[];
    }

    return (payloads as List<dynamic>).map<PayloadModel>((payload) => PayloadModel.fromJson(payload as Map<String, dynamic>)).toList();
  }

  PayloadModel copyWith({bool? seen}) {
    return PayloadModel(
      id: id,
      title: title,
      content: content,
      actionUrl: actionUrl,
      reviewableType: reviewableType,
      reviewableId: reviewableId,
      type: type,
      image: image,
      createdAt: createdAt,
      isVideo: isVideo,
      seen: seen ?? this.seen,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id, // Keeping id here
      'title': title ?? '',
      'content': content ?? '',
      'actionUrl': actionUrl,
      'reviewable_type': reviewableType ?? '',
      'reviewable_id': reviewableId ?? '',
      'type': type ?? '',
      'isVideo': isVideo ?? '',
      'image': image ?? '',
      'created_at': DateTime.now().toIso8601String(),
      'seen': seen ? '1' : '0',
    };
  }
}
