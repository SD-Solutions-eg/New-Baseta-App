import 'package:equatable/equatable.dart';

class FAQCategoryModel extends Equatable {
  final int id;
  // final int count;
  final String name;
  // final String description;
  const FAQCategoryModel({
    required this.id,
    // required this.count,
    required this.name,
    // required this.description,
  });

  @override
  List<Object> get props => [name];

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'count': count,
  //     'name': name,
  //     'description': description,
  //   };
  // }

  factory FAQCategoryModel.fromMap(Map<String, dynamic> map) {
    return FAQCategoryModel(
      id: map['id'] as int,
      // count: map['count'] as int,
      name: map['name'] as String,
      // description: map['description'] as String,
    );
  }
}
