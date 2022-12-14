import 'package:equatable/equatable.dart';

class CityModel extends Equatable {
  final int id;
  final int count;
  final String name;
  const CityModel({
    required this.id,
    required this.count,
    required this.name,
  });

  @override
  List<Object> get props => [id, count, name];

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'] as int,
      count: map['count'] as int,
      name: map['name'] as String? ?? '',
    );
  }

  CityModel copyWith({
    int? id,
    int? count,
    String? name,
  }) {
    return CityModel(
      id: id ?? this.id,
      count: count ?? this.count,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'CityModel(id: $id, count: $count, name: $name)';
}
