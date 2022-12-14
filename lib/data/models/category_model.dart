// ignore_for_file: avoid_dynamic_calls

import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final int id;
  final String name;
  final String image;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    final acf = map['acf'] as Map<String, dynamic>;
    return CategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
      image: acf['image']['url'] as String,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      image,
    ];
  }

  @override
  bool get stringify => true;
}
