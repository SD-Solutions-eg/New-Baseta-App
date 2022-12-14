class SMSResponseModel {
  SMSResponseModel({
    required this.type,
    required this.msg,
    required this.error,
  });
  late final String type;
  late final String msg;
  late final Error error;

  SMSResponseModel.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String;
    if (json.containsKey('error')) {
      msg = json['error']['msg'] as String;
    } else {
      msg = json['msg'] as String;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type;
    data['msg'] = msg;
    data['error'] = error.toJson();
    return data;
  }
}

class Error {
  Error({
    required this.msg,
    required this.number,
  });
  late final String msg;
  late final int number;

  Error.fromJson(Map<String, dynamic> json) {
    msg = json['msg'] as String;
    number = json['number'] as int;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['number'] = number;
    return data;
  }
}
