import 'package:allin1/core/constants/constants.dart';
import 'package:equatable/equatable.dart';

class SectionModel extends Equatable {
  final int id;
  final String title;
  final String content;
  final String thumbnail;
  final String fullImage;
  const SectionModel({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnail,
    required this.fullImage,
  });
  const SectionModel.create({
    this.id = 0,
    this.title = '',
    this.content = '',
    this.thumbnail = '',
    this.fullImage = '',
  });

  @override
  List<Object> get props => [id];

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    Map<String, dynamic>? mediaSizes;
    final embedded = map['_embedded'] as Map?;
    if (embedded != null) {
      final featuredMedia = embedded['wp:featuredmedia'] as List?;
      mediaSizes = featuredMedia != null && featuredMedia.isNotEmpty
          ? featuredMedia.first['media_details']['sizes']
              as Map<String, dynamic>?
          : null;
    }
    return SectionModel(
      id: map['id'] as int? ?? map['ID'] as int? ?? 0,
      title: map['title'] is Map
          ? map['title'][renderedTxt] as String? ?? ''
          : map['post_title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      thumbnail: mediaSizes is Map
          ? mediaSizes!['shop_thumbnail']['source_url'] as String? ?? ''
          : '',
      fullImage: mediaSizes is Map
          ? mediaSizes!['full']['source_url'] as String? ?? ''
          : '',
    );
  }

  @override
  String toString() {
    return 'SectionModel(id: $id, title: $title, content: $content, thumbnail: $thumbnail, fullImage: $fullImage)';
  }

  SectionModel copyWith({
    int? id,
    String? title,
    String? content,
    String? thumbnail,
    String? fullImage,
  }) {
    return SectionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      thumbnail: thumbnail ?? this.thumbnail,
      fullImage: fullImage ?? this.fullImage,
    );
  }
}
