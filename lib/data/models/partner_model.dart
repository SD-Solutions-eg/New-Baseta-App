import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/data/models/area_model.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:equatable/equatable.dart';

class PartnerModel extends Equatable {
  final int id;
  final String name;
  final AreaModel? area;
  final SectionModel? section;
  final bool featured;
  final String? avatarUrl;
  const PartnerModel({
    required this.id,
    required this.name,
    this.area,
    this.section,
    this.avatarUrl,
    required this.featured,
  });

  const PartnerModel.create({
    this.id = 0,
    this.name = '',
    this.area,
    this.section,
    this.avatarUrl,
    required this.featured,
  }) ;

  @override
  List<Object> get props {
    return [id];
  }

  factory PartnerModel.fromMap(Map<String, dynamic> map) {
    final acf = map['acf'];
    final featuredMedia = map['_embedded'][featuredMediaEmbedded] as List?;
    return PartnerModel(
      id: map['id'] as int,
      name: map['title'][renderedTxt] as String? ?? '',
      area: acf is Map && acf['area'] is Map
          ? AreaModel.fromMap(acf['area'] as Map<String, dynamic>)
          : null,
      section: acf is Map && acf['section'] is Map
          ? SectionModel.fromMap(acf['section'] as Map<String, dynamic>)
          : null,
      featured:
          // ignore: avoid_bool_literals_in_conditional_expressions
          acf is Map && acf['feature'] is bool ? acf['feature'] as bool : false,
      avatarUrl: featuredMedia != null &&
              featuredMedia.isNotEmpty &&
              featuredMedia.first is Map
          ? featuredMedia.first['source_url'] as String?
          : null,
    );
  }
}
