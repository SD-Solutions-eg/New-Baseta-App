import 'package:equatable/equatable.dart';

class ReviewModel extends Equatable {
  final int id;
  final String date;
  final int productId;
  final String status;
  final String username;
  final String email;
  final String review;
  final int rating;
  final bool isVerified;
  final String avatarUrl;

  const ReviewModel({
    required this.productId,
    required this.username,
    required this.email,
    required this.review,
    required this.rating,
    this.id = 0,
    this.date = '',
    this.status = '',
    this.isVerified = false,
    this.avatarUrl = '',
  });

  @override
  List<Object> get props {
    return [
      id,
      date,
      productId,
      status,
      username,
      email,
      review,
      rating,
      isVerified,
      avatarUrl,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'reviewer': username,
      'reviewer_email': email,
      'review': review,
      'rating': rating,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] as int,
      date: map['date_created'] as String,
      productId: map['product_id'] as int,
      status: map['status'] as String,
      username: map['reviewer'] as String,
      email: map['reviewer_email'] as String,
      review: map['review'] as String,
      rating: map['rating'] as int,
      isVerified: map['verified'] as bool,
      avatarUrl:
          (map['reviewer_avatar_urls'] as Map<String, dynamic>)['48'] as String,
    );
  }
}
