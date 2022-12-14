import 'package:allin1/core/constants/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class RatingModel extends Equatable {
  final int id;
  final String date;
  final String review;
  final int captainId;
  final int rating;
  const RatingModel({
    required this.id,
    required this.date,
    required this.review,
    required this.captainId,
    required this.rating,
  });
  const RatingModel.upload({
    this.id = -1,
    this.date = '',
    required this.review,
    required this.captainId,
    required this.rating,
  });

  @override
  List<Object> get props {
    return [id];
  }

  Map<String, dynamic> toMap() {
    return {
      "status": "publish",
      "title": DateTime.now().toString(),
      "content": review,
      "fields": {
        "user": captainId,
        "rating": rating.toString(),
      }
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    final acf = map['acf'] as Map<String, dynamic>;
    return RatingModel(
      id: map['id'] as int,
      date: map['date'] as String,
      review: Bidi.stripHtmlIfNeeded(map['content'][renderedTxt] as String),
      captainId: acf['user']['ID'] as int,
      rating: int.parse(acf['rating'] as String? ?? '1'),
    );
  }
}
