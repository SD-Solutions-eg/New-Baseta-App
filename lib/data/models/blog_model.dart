// ignore_for_file: avoid_dynamic_calls

import 'package:allin1/core/constants/constants.dart';
import 'package:equatable/equatable.dart';

class BlogModel extends Equatable {
  final int id;
  final String title;
  final String content;
  final String thumbnail;
  final String fullImg;
  const BlogModel({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnail,
    required this.fullImg,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      content,
      thumbnail,
      fullImg,
    ];
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    final featuredMedia = map['_embedded']['wp:featuredmedia'] as List<dynamic>;
    final sizes =
        featuredMedia.first['media_details']['sizes'] as Map<String, dynamic>;
    return BlogModel(
      id: map['id'] as int,
      title: (map['title'] as Map<String, dynamic>)[renderedTxt] as String,
      content: (map['content'] as Map<String, dynamic>)[renderedTxt] as String,
      thumbnail: sizes['thumbnail']['source_url'] as String? ?? '',
      fullImg: sizes['full']['source_url'] as String? ?? '',
    );
  }

  BlogModel copyWith({
    int? id,
    String? title,
    String? content,
    String? thumbnail,
    String? fullImg,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      thumbnail: thumbnail ?? this.thumbnail,
      fullImg: fullImg ?? this.fullImg,
    );
  }
}
