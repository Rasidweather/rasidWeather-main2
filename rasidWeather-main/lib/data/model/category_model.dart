class CategoryModel {

  CategoryModel({
    this.id,
    this.title,
    this.description,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'].toString(),
        title: json['title'].toString(),
        description: json['description'].toString(),
        image: json['image'] == null ? null : Image.fromJson(json['image'] as Map<String, dynamic>),
      );
  final String? id;
  final String? title;
  final String? description;
  final Image? image;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'description': description,
        'image': image?.toJson(),
      };
}

class Image {

  Image({
    this.main,
    this.tiny,
    this.thumb,
    this.original,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
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
