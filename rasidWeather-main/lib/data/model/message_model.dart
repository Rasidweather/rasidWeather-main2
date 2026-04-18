import '../../views/screens/inquiries_screen/components/chat.dart';

class MessageBodyModel {

  MessageBodyModel({this.data, this.meta});

  factory MessageBodyModel.fromJson(Map<String, dynamic> json) {
    return MessageBodyModel(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] != null
          ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
  List<MessageModel>? data;
  Meta? meta;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'data': data?.map((MessageModel e) => e.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}

class MessageModel {

  MessageModel({
    this.id,
    this.contactId,
    this.isSupportReply,
    this.content,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString(),
      contactId: json['contact_id']?.toString(),
      isSupportReply: json['is_support_reply'] is bool
          ? json['is_support_reply'] as bool
          : (json['is_support_reply'].toString() == 'true'),
      content: json['content']?.toString(),
      user: json['user'] != null
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }
  String? id;
  String? contactId;
  bool? isSupportReply;
  String? content;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;

  ChatMessageType get type =>
      (isSupportReply ?? false) ? ChatMessageType.received : ChatMessageType.sent;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'contact_id': contactId,
      'is_support_reply': isSupportReply,
      'content': content,
      'user': user?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class User {

  User({this.id, this.avatar, this.name, this.bio, this.isOnline, this.lastActivity});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      avatar: json['avatar'] != null
          ? Avatar.fromJson(json['avatar'] as Map<String, dynamic>)
          : null,
      name: json['name']?.toString(),
      bio: json['bio']?.toString(),
      isOnline: json['isOnline'] is int
          ? json['isOnline'] as int
          : int.tryParse(json['isOnline'].toString()),
      lastActivity: json['last_activity']?.toString(),
    );
  }
  String? id;
  Avatar? avatar;
  String? name;
  String? bio;
  int? isOnline;
  String? lastActivity;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar?.toJson(),
      'name': name,
      'bio': bio,
      'isOnline': isOnline,
      'last_activity': lastActivity,
    };
  }
}

class Avatar {

  Avatar({this.main, this.tiny, this.thumb, this.original});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      main: json['main']?.toString(),
      tiny: json['tiny']?.toString(),
      thumb: json['thumb']?.toString(),
      original: json['original']?.toString(),
    );
  }
  String? main;
  String? tiny;
  String? thumb;
  String? original;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'main': main,
      'tiny': tiny,
      'thumb': thumb,
      'original': original,
    };
  }
}

class Meta {

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] as int?,
      from: json['from'] as int?,
      lastPage: json['last_page'] as int?,
      path: json['path']?.toString(),
      perPage: json['per_page'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
    );
  }
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'current_page': currentPage,
      'from': from,
      'last_page': lastPage,
      'path': path,
      'per_page': perPage,
      'to': to,
      'total': total,
    };
  }
}

class Links {

  Links({this.url, this.label, this.active});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      url: json['url']?.toString(),
      label: json['label']?.toString(),
      active: json['active'] as bool?,
    );
  }
  String? url;
  String? label;
  bool? active;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'url': url,
      'label': label,
      'active': active,
    };
  }
}
