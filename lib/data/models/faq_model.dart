import 'package:allin1/core/constants/constants.dart';
import 'package:equatable/equatable.dart';

class FAQModel extends Equatable {
  final int id;
  final String question;
  final String answer;
  final List<int> categoriesId;
  const FAQModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoriesId,
  });

  @override
  List<Object> get props => [id, question, answer];

  factory FAQModel.fromMap(Map<String, dynamic> map) {
    return FAQModel(
      id: map['id'] as int,
      question: (map['title'] as Map<String, dynamic>)[renderedTxt] as String,
      answer: (map['content'] as Map<String, dynamic>)[renderedTxt] as String,
      categoriesId: List<int>.from(map['faq_cat'] as List<dynamic>? ?? []),
    );
  }
}
