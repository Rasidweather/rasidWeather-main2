import 'article_model.dart';

class ArticleHomeModel {
  ArticleHomeModel({
    this.name,
    this.type,
    this.list,
  });

  factory ArticleHomeModel.fromJson(Map<String, dynamic> json) {
    return ArticleHomeModel(
      name: json['name']?.toString(),
      type: json['type']?.toString(),
      list: json['list'] != null
          ? ListClass.fromJson(json['list'] as Map<String, dynamic>)
          : null,
    );
  }

  final String? name;
  final String? type;
  final ListClass? list;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'list': list?.toJson(),
    };
  }
}

class ListClass {
  ListClass({
    this.data,
    this.meta,
  });

  factory ListClass.fromJson(Map<String, dynamic> json) {
    return ListClass(
      data: json['data'] == null
          ? <ArticleModel>[]
          : (json['data'] as List)
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
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
