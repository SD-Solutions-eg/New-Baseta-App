// ignore_for_file: avoid_dynamic_calls

import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/data/models/image_model.dart';
import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String link;
  final String type;
  final String status;
  final String description;
  final String shortDescription;
  final String? sku;
  final String price;
  final String adultPrice;
  final String salePrice;
  final bool onSale;
  final List<int> categories;
  final List<ProductImageModel> images;
  final String dives;
  final String policy;
  final String childPrice;
  final String startDate;
  final String endDate;
  final String duration;

  const ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.link,
    required this.type,
    required this.status,
    required this.description,
    required this.shortDescription,
    required this.sku,
    required this.price,
    required this.adultPrice,
    required this.salePrice,
    required this.onSale,
    required this.categories,
    required this.images,
    required this.dives,
    required this.policy,
    required this.childPrice,
    required this.startDate,
    required this.endDate,
    required this.duration,
  });

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [id, name];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'permalink': link,
      'type': type,
      'status': status,
      'description': description,
      'short_description': shortDescription,
      'sku': sku,
      'price': price,
      'regular_price': adultPrice,
      'sale_price': salePrice,
      'on_sale': onSale,
      'price_child': childPrice,
      'start_date': startDate,
      'end_date': endDate,
      'duration': duration,
      'categories': categories,
      'images': images.map((x) => x.toMap()).toList(),
      'acf': {'dives': dives, 'policy': policy},
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final acf = map['acf'] as Map<String, dynamic>? ?? {};

    return ProductModel(
      id: map['id'] as int,
      name: map['title'][renderedTxt] as String,
      slug: map['slug'] as String? ?? '',
      link: map['permalink'] as String? ?? '',
      type: map['type'] as String? ?? '',
      status: map['status'] as String? ?? '',
      description: map['content'][renderedTxt] as String? ?? '',
      shortDescription: map['short_description'] as String? ?? '',
      sku: map['sku'] as String? ?? 'Null',
      price: acf['price_adult'] as String,
      adultPrice: acf['price_adult'] as String,
      childPrice: acf['price_child'] as String? ?? '',
      salePrice: acf['sale_price'] as String? ?? '',
      startDate: acf['start_date'] as String? ?? '',
      endDate: acf['end_date'] as String? ?? '',
      duration: acf['duration'] as String? ?? '',
      onSale: map['on_sale'] as bool? ?? false,
      categories: (map['package_cat'] as List<dynamic>).cast(),
      images: List<ProductImageModel>.from(
        (acf['gallery'] as List<dynamic>? ?? []).map(
          (x) => ProductImageModel.fromMap(
            (x as Map<dynamic, dynamic>).cast<String, dynamic>(),
          ),
        ),
      ),
      dives: acf['dives'] as String? ?? '2',
      policy: acf['policy'] as String? ?? 'Adult only - no child',
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? slug,
    String? link,
    String? dateCreated,
    String? dateModified,
    String? type,
    String? status,
    bool? featured,
    String? catalogVisibility,
    String? description,
    String? shortDescription,
    String? sku,
    String? price,
    String? adultPrice,
    String? salePrice,
    bool? onSale,
    bool? reviewAllowed,
    String? averageRating,
    int? ratingCount,
    List<int>? categories,
    List<ProductImageModel>? images,
    List<int>? variations,
    String? stockStatus,
    int? totalSales,
    List<int>? relatedIds,
    bool? purchasable,
    int? stockQuantity,
    String? dives,
    String? policy,
    String? priceChild,
    String? startDate,
    String? endDate,
    String? duration,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      link: link ?? this.link,
      type: type ?? this.type,
      status: status ?? this.status,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      sku: sku ?? this.sku,
      price: price ?? this.price,
      adultPrice: adultPrice ?? this.adultPrice,
      salePrice: salePrice ?? this.salePrice,
      onSale: onSale ?? this.onSale,
      categories: categories ?? this.categories,
      images: images ?? this.images,
      dives: dives ?? this.dives,
      policy: policy ?? this.policy,
      childPrice: priceChild ?? childPrice,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      duration: duration ?? this.duration,
    );
  }
}
