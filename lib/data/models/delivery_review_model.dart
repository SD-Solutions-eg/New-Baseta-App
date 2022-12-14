import 'dart:convert';

import 'package:equatable/equatable.dart';

class DeliveryReviewModel extends Equatable {

  final String comment;
  final String rating;
  const DeliveryReviewModel({
    required this.comment,
    required this.rating,
  });



  DeliveryReviewModel copyWith({
    String? comment,
    String? rating,
  }) {
    return DeliveryReviewModel(
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'comment': comment});
    result.addAll({'rating': rating});

    return result;
  }

  factory DeliveryReviewModel.fromMap(Map<String, dynamic> map) {
    return DeliveryReviewModel(
      comment: map['comment'] as String? ?? '',
      rating: map['rating'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());


  @override
  String toString() => 'DeliveryReviewModel(comment: $comment, rating: $rating)';

  @override
  List<Object> get props => [comment, rating];
}
