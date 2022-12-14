import 'package:equatable/equatable.dart';

class StateModel extends Equatable {
  final String name;
  final String code;
  const StateModel({
    required this.name,
    required this.code,
  });

  @override
  List<Object> get props => [name, code];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iso2': code,
    };
  }

  factory StateModel.fromMap(Map<String, dynamic> map) {
    return StateModel(
      name: (map['name'] as String).split(' Governorate').first,
      code: map['iso2'] as String,
    );
  }
}
