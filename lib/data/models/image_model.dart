// ignore_for_file: avoid_dynamic_calls

import 'package:equatable/equatable.dart';

class ProductImageModel extends Equatable {
  final int id;
  final String srcUrl;
  final String? thumbnail;

  const ProductImageModel({
    required this.id,
    required this.srcUrl,
    this.thumbnail,
  });

  @override
  List<Object> get props => [
        id,
        srcUrl,
      ];

  factory ProductImageModel.fromMap(Map<String, dynamic> map) {
    return ProductImageModel(
      id: map['id'] as int,
      srcUrl: map['url'] as String? ?? '',
      thumbnail: map['sizes']['thumbnail'] as String?,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': srcUrl,
      'sizes': {'thumbnail': thumbnail},
    };
  }
}
