import 'package:equatable/equatable.dart';

class PageModel extends Equatable {
  final String content;
  final PageImageModel? image;

  const PageModel({
    required this.content,
    required this.image,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [content];

  factory PageModel.fromMap(Map<String, dynamic> map, String pageName) {
    return PageModel(
      content: map[pageName] as String,
      image: PageImageModel.fromMap(map['image'] as Map<String, dynamic>),
    );
  }
}

class PageImageModel extends Equatable {
  final int id;
  final String url;

  const PageImageModel({
    required this.id,
    required this.url,
  });

  @override
  List<Object> get props => [id, url];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
    };
  }

  factory PageImageModel.fromMap(Map<String, dynamic> map) {
    return PageImageModel(
      id: map['id'] as int? ?? -1,
      url: map['url'] as String? ?? '',
    );
  }
}
