class CommentsModelBody {

  CommentsModelBody({
    this.data,
    this.links,
    this.meta,
  });

  factory CommentsModelBody.fromJson(Map<String, dynamic> json) => CommentsModelBody(
        data: json['data'] == null
            ? <CommentModel>[]
        ///        List<CommentModel>.from((apiResponse.response!.data['body'] as Iterable).map((x) => ChartModel.fromJson(x as Map<String, dynamic>)));
            : List<CommentModel>.from((json['data']! as Iterable).map((x) => CommentModel.fromJson(x as Map<String, dynamic>))),
        links: json['links'] == null ? null : Links.fromJson(json['links'] as Map<String, dynamic>),
        meta: json['meta'] == null ? null : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      );
  final List<CommentModel>? data;
  final Links? links;
  final Meta? meta;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data == null ? <CommentModel>[] : List<dynamic>.from(data!.map((CommentModel x) => x.toJson())),
        'links': links?.toJson(),
        'meta': meta?.toJson(),
      };
}

class CommentModel {

  CommentModel({
    this.id,
    this.content,
    this.user,
    this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'].toString(),
        content: json['content'].toString(),
        user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'].toString()),
      );
  final String? id;
  final String? content;
  final User? user;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'content': content,
        'user': user?.toJson(),
        'created_at': createdAt?.toIso8601String(),
      };
}

class User {

  User({
    this.id,
    this.avatar,
    this.name,
    this.bio,
    this.isOnline,
    this.lastActivity,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'].toString(),
        avatar: json['avatar'] == null ? null : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
        name: json['name'].toString(),
        bio: json['bio'].toString(),
        isOnline: json['isOnline'] as int,
        lastActivity: json['last_activity'] == null ? null : DateTime.parse(json['last_activity'].toString()),
      );
  final String? id;
  final Avatar? avatar;
  final String? name;
  final String? bio;
  final int? isOnline;
  final DateTime? lastActivity;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'avatar': avatar?.toJson(),
        'name': name,
        'bio': bio,
        'isOnline': isOnline,
        'last_activity': lastActivity?.toIso8601String(),
      };
}

class Avatar {

  Avatar({
    this.main,
    this.tiny,
    this.thumb,
    this.original,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        main: json['main'].toString(),
        tiny: json['tiny'].toString(),
        thumb: json['thumb'].toString(),
        original: json['original'].toString(),
      );
  final String? main;
  final String? tiny;
  final String? thumb;
  final String? original;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'main': main,
        'tiny': tiny,
        'thumb': thumb,
        'original': original,
      };
}

class Links {

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json['first'].toString(),
        last: json['last'].toString(),
        prev: json['prev'],
        next: json['next'],
      );
  final String? first;
  final String? last;
  final dynamic prev;
  final dynamic next;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'first': first,
        'last': last,
        'prev': prev,
        'next': next,
      };
}

class Meta {

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json['current_page'] as int,
        from: json['from'] == null ? null : json['from'] as int,
        lastPage: json['last_page'] as int,
        links: json['links'] == null
            ? <Link>[]
            : List<Link>.from((json['links']! as Iterable).map((x) => Link.fromJson(x as Map<String, dynamic>))),
        path: json['path'].toString(),
        perPage: json['per_page'] as int,
        to: json['to'] == null ? null : json['to'] as int,
        total: json['total'] as int,
      );
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'current_page': currentPage,
        'from': from,
        'last_page': lastPage,
        'links': links == null ? <Link>[] : List<dynamic>.from(links!.map((Link x) => x.toJson())),
        'path': path,
        'per_page': perPage,
        'to': to,
        'total': total,
      };
}

class Link {

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json['url'].toString(),
        label: json['label'].toString(),
        active: json['active'] as bool,
      );
  final String? url;
  final String? label;
  final bool? active;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'url': url,
        'label': label,
        'active': active,
      };
}
