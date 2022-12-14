import 'package:allin1/core/constants/constants.dart';
import 'package:equatable/equatable.dart';

class SlideshowModel extends Equatable {
  final int id;
  final String title;
  final String? subtitle;
  final SlideshowImageModel slideshowImage;
  const SlideshowModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.slideshowImage,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      slideshowImage,
    ];
  }

  factory SlideshowModel.fromMap(Map<String, dynamic> map) {
    return SlideshowModel(
      id: map['id'] as int,
      title: (map['title'] as Map<String, dynamic>)[renderedTxt] as String,
      subtitle:
          (map['content'] as Map<String, dynamic>)[renderedTxt] as String?,
      slideshowImage:
          SlideshowImageModel.fromMap(map['_embedded'] as Map<String, dynamic>),
    );
  }

  SlideshowModel copyWith({
    int? id,
    String? title,
    String? subtitle,
    SlideshowImageModel? slideshowImage,
  }) {
    return SlideshowModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      slideshowImage: slideshowImage ?? this.slideshowImage,
    );
  }
}

class SlideshowImageModel extends Equatable {
  final String imageUrl;
  const SlideshowImageModel({
    required this.imageUrl,
  });

  @override
  List<Object> get props => [imageUrl];

  factory SlideshowImageModel.fromMap(Map<String, dynamic> map) {
    final featuredMedia =
        (map['wp:featuredmedia'] as List<dynamic>)[0] as Map<String, dynamic>;
    final shopSingle =
        ((featuredMedia['media_details'] as Map<String, dynamic>)['sizes']
            as Map<String, dynamic>)['full'] as Map<String, dynamic>;

    return SlideshowImageModel(
      imageUrl: shopSingle['source_url'] as String,
    );
  }
}
