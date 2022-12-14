class NotificationModel {
  NotificationModel({
    required this.id,
    required this.subject,
    required this.message,
    required this.type,
    required this.target,
    required this.date,
    required this.priority,
    required this.visibility,
  });
  late final int id;
  late final String subject;
  late final String message;
  late final String type;
  late final String target;
  late final String date;
  late final String priority;
  late final String visibility;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    subject = json['subject'] as String;
    message = json['message'] as String;
    type = json['type'] as String;
    target = json['target'] as String;
    date = json['date'] as String;
    priority = json['priority'] as String;
    visibility = json['visibility'] as String;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['subject'] = subject;
    data['message'] = message;
    data['type'] = type;
    data['target'] = target;
    data['date'] = date;
    data['priority'] = priority;
    data['visibility'] = visibility;
    return data;
  }
}
