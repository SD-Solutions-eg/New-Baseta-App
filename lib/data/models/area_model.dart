import 'package:allin1/core/constants/constants.dart';
import 'package:equatable/equatable.dart';

class AreaModel extends Equatable {
  final int id;
  final String name;
  final String deliveryPrice;
  final int cityId;
  const AreaModel( {
    required this.id,
    required this.name,
    required this.cityId,
    required this.deliveryPrice,
  });

  @override
  List<Object> get props => [id, name, cityId];

  factory AreaModel.fromMap(Map<String, dynamic> map) {
    return AreaModel(
      id: map['id'] as int? ?? map['ID'] as int? ?? 0,
      name: map['title'] is Map
          ? map['title'][renderedTxt] as String? ?? ''
          : map['post_title'] as String? ?? '',
      cityId: map['city'] is List ? map['city'].first as int : -1,
      deliveryPrice:map['acf'] is Map? map['acf']['delivery_price'] as String? ?? '0':'0',
    );
  }

  AreaModel copyWith({
    int? id,
    String? name,
    int? cityId,
    String? deliveryPrice,
  }) {
    return AreaModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cityId: cityId ?? this.cityId,
      deliveryPrice: deliveryPrice?? this.deliveryPrice,
    );
  }

  @override
  String toString() => 'AreaModel(id: $id, name: $name, cityId: $cityId)';
}
