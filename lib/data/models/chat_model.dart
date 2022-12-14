import 'package:allin1/core/constants/constants.dart';
import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final int id;
  final String date;
  final String title;
  final List<ReplyModel> replies;

  const ChatModel({
    required this.id,
    required this.date,
    required this.title,
    required this.replies,
  });

  const ChatModel.createChat({
    required this.title,
    this.id = -1,
    this.date = '',
    this.replies = const [],
  });

  @override
  List<Object> get props => [id, date, title, replies];

  Map<String, dynamic> toMap() {
    return {
      'status': 'publish',
      'title': title,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    final embedded = map['_embedded'] as Map<String, dynamic>?;
    return ChatModel(
      id: map['id'] as int,
      date: map['date'] as String,
      title: map['title'] != null ? map['title'][renderedTxt] as String : '',
      replies: embedded != null
          ? List<ReplyModel>.from(
              (embedded['replies'].first as List).map(
                (x) => ReplyModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  @override
  String toString() {
    return 'ChatModel(id: $id, date: $date, title: $title, replies: $replies)';
  }

  ChatModel copyWith({
    int? id,
    String? date,
    String? title,
    List<ReplyModel>? replies,
  }) {
    return ChatModel(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      replies: replies ?? this.replies,
    );
  }
}

class ReplyModel extends Equatable {
  final int id;
  final int author;
  final String authorName;
  final String date;
  final String content;
  final String authorAvatar;
  final String? image;
  final String? voice;
  const ReplyModel({
    required this.id,
    required this.author,
    required this.authorName,
    required this.date,
    required this.content,
    required this.authorAvatar,
    this.image,
    this.voice,
  });
  const ReplyModel.create({
    required this.author,
    required this.authorName,
    required this.content,
    this.id = -1,
    this.date = '',
    this.authorAvatar = '',
    this.image,
    this.voice,
  });

  @override
  List<Object> get props {
    return [
      id,
      author,
      authorName,
      date,
      content,
    ];
  }

  Map<String, dynamic> toMap(int postId) {
    return {
      'author': author,
      'content': content,
      'post': postId,
    };
  }

  Map<String, dynamic> mediaToMap({
    required int postId,
    required int mediaId,
    required String mediaUrl,
    bool isImage = true,
  }) {
    return {
      'author': author,
      'content': content,
      'post': postId,
      'meta': {
        isImage ? 'image' : 'audio': mediaId,
        isImage ? 'image_url' : 'audio_url': mediaUrl,
      }
    };
  }

  factory ReplyModel.fromMap(Map<String, dynamic> map) {
    // final acf = map['acf'];
    final meta = map['meta'];

    // log('Meta: $meta');
    return ReplyModel(
      id: map['id'] as int,
      author: map['author'] as int,
      authorName: map['author_name'] as String,
      date: map['date'] as String,
      content: map['content'][renderedTxt] as String,
      authorAvatar: map['author_avatar_urls']['96'] as String,
      image: meta is Map && meta['image_url'] is String
          ? meta['image_url'] as String
          : null,
      voice: meta is Map && meta['audio_url'] is String
          ? meta['audio_url'] as String
          : null,
    );
  }
}
