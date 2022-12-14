import 'package:equatable/equatable.dart';

class ContactFormModel extends Equatable {
  final String name;
  final String email;
  final String subject;
  final String message;

  const ContactFormModel({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  @override
  List<Object> get props => [name, email, subject, message];

  Map<String, dynamic> toMap() {
    return {
      'your-name': name,
      'your-email': email,
      'your-subject': subject,
      'your-message': message,
    };
  }
}
