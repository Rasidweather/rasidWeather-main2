import '../../../../data/model/article_model.dart';

enum NotificationType { custom, weather }

class NotificationsModelBody {
  NotificationsModelBody({
    this.notifications,
    this.meta,
  });

  factory NotificationsModelBody.fromJson(Map<String, dynamic> json) {
    return NotificationsModelBody(
      notifications: json['data'] != null
          ? List<NotificationModel>.from(
        (json['data'] as List).map(
              (x) => NotificationModel.fromJson(x as Map<String, dynamic>),
        ),
      )
          : null,
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  final List<NotificationModel>? notifications;
  final Meta? meta;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': notifications?.map((NotificationModel x) => x.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}

class NotificationModel {
  NotificationModel({
    this.id,
    this.title,
    this.content,
    this.actionUrl,
    this.reviewableType,
    this.reviewableId,
    this.reviewable,
    this.videoType,
    this.type,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.seen = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      content: json['content']?.toString(),
      actionUrl: json['actionUrl']?.toString(),
      reviewableType: json['reviewable_type']?.toString(),
      reviewableId: json['reviewable_id']?.toString(),
      reviewable: json['reviewable'] != null
          ? ArticleModel.fromJson(json['reviewable'] as Map<String, dynamic>)
          : null,
      videoType: json['video_type']?.toString(),
      type: json['type']?.toString(),
      image: _normalizeImageUrl(json['image']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : null,
      seen: json['seen'] == true,
    );
  }

  /// دالة مساعدة لتنظيف رابط الصورة من القيم الغلط زي:
  /// "", "https://", "https//", "https://https//..."
  static String? _normalizeImageUrl(dynamic raw) {
    if (raw == null) return null;

    final String url = raw.toString().trim();

    // قيم غير صالحة نعتبرها null
    if (url.isEmpty || url == 'https://' || url == 'https//') {
      return null;
    }

    // حالة مثل https://https//rasidweather.com/...
    if (url.startsWith('https://https//')) {
      return url.replaceFirst('https://https//', 'https://');
    }

    // حالة مثل https//rasidweather.com/...
    if (url.startsWith('https//')) {
      return 'https://${url.substring('https//'.length)}';
    }

    return url;
  }

  final String? id;
  final String? title;
  final String? content;
  final String? actionUrl;
  final String? reviewableType;
  final String? reviewableId;
  final ArticleModel? reviewable;
  final String? videoType;
  final String? type;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool seen;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? content,
    String? actionUrl,
    String? reviewableType,
    String? reviewableId,
    ArticleModel? reviewable,
    String? videoType,
    String? type,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? seen,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      actionUrl: actionUrl ?? this.actionUrl,
      reviewableType: reviewableType ?? this.reviewableType,
      reviewableId: reviewableId ?? this.reviewableId,
      reviewable: reviewable ?? this.reviewable,
      videoType: videoType ?? this.videoType,
      type: type ?? this.type,
      // نطبع الإيميج الجديدة (لو انبعتت) من خلال النورمالايزر
      image: image != null ? _normalizeImageUrl(image) : this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seen: seen ?? this.seen,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'actionUrl': actionUrl,
      'reviewable_type': reviewableType,
      'reviewable_id': reviewableId,
      'reviewable': reviewable?.toJson(),
      'video_type': videoType,
      'type': type,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'seen': seen,
    };
  }
}
