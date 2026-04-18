class ArticleModelBody {
  ArticleModelBody({
    this.data,
    this.meta,
  });

  factory ArticleModelBody.fromJson(Map<String, dynamic> json) {
    return ArticleModelBody(
      data: json['data'] == null
          ? <ArticleModel>[]
          : (json['data'] as List)
          .map((x) => ArticleModel.fromJson(x as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }

  final List<ArticleModel>? data;
  final Meta? meta;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data?.map((ArticleModel x) => x.toJson()).toList() ?? <dynamic>[],
      'meta': meta?.toJson(),
    };
  }
}

class ArticleModel {
  ArticleModel({
    this.id,
    this.mainImage,
    this.title,
    this.description,
    this.source,
    this.videoType,
    this.videoUrl,
    this.views,
    this.author,
    this.countLikes,
    this.countComments,
    this.isFeatured = false,
    this.isPremium,
    this.hasFavorited,
    this.isLiked,
    this.categories,
    this.createdAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id']?.toString(),
      mainImage: json['main_image'] != null
          ? MainImage.fromJson(json['main_image'] as Map<String, dynamic>)
          : null,
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      source: json['source']?.toString(),
      videoType: json['video_type']?.toString(),
      videoUrl: json['video_url']?.toString(),
      views: json['views']?.toString(),
      author: json['author'] != null
          ? Author.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      countLikes: json['count_likes']?.toString(),
      countComments: json['count_comments']?.toString(),
      isFeatured: _parseBooleanField(json['is_featured']),
      isPremium: _parseBooleanField(json['is_premium']),
      hasFavorited: _parseBooleanField(json['has_favorited']),
      isLiked: _parseBooleanField(json['is_liked']),
      categories: json['categories'] == null
          ? <Category>[]
          : (json['categories'] as List)
          .map((x) => Category.fromJson(x as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : null,
    );
  }

  static bool _parseBooleanField(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final String v = value.toLowerCase();
      return v == 'true' || v == '1';
    }
    return false;
  }

  final String? id;
  final MainImage? mainImage;
  final String? title;
  final String? description;
  final String? source;
  final String? videoType;
  final String? videoUrl;
  final String? views;
  final Author? author;
  final String? countLikes;
  final String? countComments;
  final bool isFeatured;
  final bool? isPremium;
  bool? hasFavorited;
  bool? isLiked;
  final List<Category>? categories;
  final DateTime? createdAt;

  String get contentType => videoType != null ? 'video' : 'image';

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'main_image': mainImage?.toJson(),
      'title': title,
      'description': description,
      'source': source,
      'video_type': videoType,
      'video_url': videoUrl,
      'views': views,
      'author': author?.toJson(),
      'count_likes': countLikes,
      'count_comments': countComments,
      'is_featured': isFeatured,
      'is_premium': isPremium,
      'has_favorited': hasFavorited,
      'is_liked': isLiked,
      'categories': categories?.map((Category x) => x.toJson()).toList() ?? <dynamic>[],
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class Author {
  Author({
    this.id,
    this.avatar,
    this.name,
    this.bio,
    this.isOnline,
    this.lastActivity,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) => v == null ? null : int.tryParse(v.toString());

    return Author(
      id: json['id']?.toString(),
      avatar: json['avatar'] != null
          ? MainImage.fromJson(json['avatar'] as Map<String, dynamic>)
          : null,
      name: json['name']?.toString(),
      bio: json['bio']?.toString(),
      isOnline: toInt(json['isOnline']),
      lastActivity: json['last_activity'] != null
          ? DateTime.parse(json['last_activity'].toString())
          : null,
    );
  }

  final String? id;
  final MainImage? avatar;
  final String? name;
  final String? bio;
  final int? isOnline;
  final DateTime? lastActivity;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar?.toJson(),
      'name': name,
      'bio': bio,
      'isOnline': isOnline,
      'last_activity': lastActivity?.toIso8601String(),
    };
  }
}

class MainImage {
  MainImage({
    this.main,
    this.tiny,
    this.thumb,
    this.original,
  });

  factory MainImage.fromJson(Map<String, dynamic> json) {
    return MainImage(
      main: _normalizeImageUrl(json['main']),
      tiny: _normalizeImageUrl(json['tiny']),
      thumb: _normalizeImageUrl(json['thumb']),
      original: _normalizeImageUrl(json['original']),
    );
  }

  /// نفس منطق التنظيف اللي استخدمناه في NotificationModel
  static String? _normalizeImageUrl(dynamic raw) {
    if (raw == null) return null;

    final String url = raw.toString().trim();

    // قيم غير صالحة نعتبرها null
    if (url.isEmpty ||
        url == 'null' ||
        url == 'https://' ||
        url == 'https//') {
      return null;
    }

    // حالة مثل: https://https//rasidweather.com/...
    if (url.startsWith('https://https//')) {
      return url.replaceFirst('https://https//', 'https://');
    }

    // حالة مثل: https//rasidweather.com/...
    if (url.startsWith('https//')) {
      return 'https://${url.substring('https//'.length)}';
    }

    return url;
  }

  final String? main;
  final String? tiny;
  final String? thumb;
  final String? original;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'main': main,
      'tiny': tiny,
      'thumb': thumb,
      'original': original,
    };
  }
}

class Category {
  Category({
    this.id,
    this.title,
    this.description,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString(),
      title: json['title']?.toString(),
      description: json['description'],
      image: json['image'] != null
          ? MainImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
    );
  }

  final String? id;
  final String? title;
  final dynamic description;
  final MainImage? image;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'image': image?.toJson(),
    };
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

  factory Meta.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic v) =>
        v == null ? null : int.tryParse(v.toString());

    return Meta(
      total: toInt(json['total']),
      perPage: toInt(json['per_page']),
      currentPage: toInt(json['current_page']),
      lastPage: toInt(json['last_page']),
      from: toInt(json['from']),
      to: toInt(json['to']),
    );
  }

  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final int? from;
  final int? to;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
      'from': from,
      'to': to,
    };
  }
}
