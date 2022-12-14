import 'package:equatable/equatable.dart';

class AboutModel extends Equatable {
  final int id;
  final String content;
  final String title;
  final String link;

  const AboutModel({
    required this.id,
    required this.content,
    required this.title,
    required this.link,
  });

  @override
  List<Object> get props => [id];

  factory AboutModel.fromMap(Map<String, dynamic> map) {
    final about = map['about'] as Map<String, dynamic>;
    return AboutModel(
      id: about['ID'] as int,
      content: about['post_content'] as String,
      title: about['post_title'] as String,
      link: about['guid'] as String,
    );
  }
}
