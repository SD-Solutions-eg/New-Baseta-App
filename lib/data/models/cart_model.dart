import 'package:allin1/data/models/address_model.dart';
import 'package:allin1/data/models/image_model.dart';
import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  final AddressModel billingAddress;
  final List<CartItemModel> items;
  final int itemsCount;
  final CartTotalsModel totals;

  const CartModel({
    required this.billingAddress,
    required this.items,
    required this.itemsCount,
    required this.totals,
  });

  @override
  List<Object> get props {
    return [
      billingAddress,
      items,
      itemsCount,
      totals,
    ];
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      billingAddress: AddressModel.fromMap(
        (map['billing_address'] as Map<dynamic, dynamic>)
            .cast<String, dynamic>(),
      ),
      itemsCount: map['items_count'] as int,
      items: List<CartItemModel>.from(
        (map['items'] as List<dynamic>).map(
          (x) => CartItemModel.fromMap(
            (x as Map<dynamic, dynamic>).cast<String, dynamic>(),
          ),
        ),
      ),
      totals: CartTotalsModel.fromMap(
        (map['totals'] as Map<dynamic, dynamic>).cast<String, dynamic>(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'billing_address': billingAddress.toMap(isBilling: true),
      'items': items.map((x) => x.toMap()).toList(),
      'items_count': itemsCount,
      'totals': totals.toMap(),
    };
  }

  CartModel copyWith({
    required List<CartItemModel> items,
    required int itemsCount,
    required CartTotalsModel totals,
  }) {
    return CartModel(
      items: items,
      itemsCount: itemsCount,
      totals: totals,
      billingAddress: billingAddress,
    );
  }
}

class CartItemModel extends Equatable {
  final int id;
  final String name;
  final String price;
  final int quantity;
  final int adultNumber;
  final int childNumber;
  final String adultPrice;
  final String childPrice;
  final List<ProductImageModel> images;
  const CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.adultNumber,
    required this.childNumber,
    required this.adultPrice,
    required this.childPrice,
    required this.images,
  });

  @override
  List<Object> get props {
    return [
      id,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'adultNumber': adultNumber,
      'childNumber': childNumber,
      'adultPrice': adultPrice,
      'childPrice': childPrice,
      'images': images.map((x) => x.toMap()).toList(),
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as String,
      quantity: map['quantity'] as int,
      adultNumber: map['adultNumber'] as int,
      childNumber: map['childNumber'] as int,
      adultPrice: map['adultPrice'] as String,
      childPrice: map['childPrice'] as String,
      images: List<ProductImageModel>.from((map['images'] as List<dynamic>).map(
          (x) =>
              ProductImageModel.fromMap((x as Map<dynamic, dynamic>).cast()))),
    );
  }

  CartItemModel copyWith({
    int? id,
    String? name,
    String? price,
    int? quantity,
    int? adultNumber,
    int? childNumber,
    String? adultPrice,
    String? childPrice,
    List<ProductImageModel>? images,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      adultNumber: adultNumber ?? this.adultNumber,
      childNumber: childNumber ?? this.childNumber,
      adultPrice: adultPrice ?? this.adultPrice,
      childPrice: childPrice ?? this.childPrice,
      images: images ?? this.images,
    );
  }
}

class CartTotalsModel extends Equatable {
  final String totalItems;
  final String totalPrice;
  final String currency;
  const CartTotalsModel({
    required this.totalItems,
    required this.totalPrice,
    this.currency = 'USD',
  });

  @override
  List<Object> get props {
    return [
      totalItems,
      totalPrice,
      currency,
    ];
  }

  factory CartTotalsModel.fromMap(Map<String, dynamic> map) {
    return CartTotalsModel(
      totalItems: map['total_items'] as String,
      totalPrice: map['total_price'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_items': totalItems,
      'total_price': totalPrice,
      'currency_symbol': currency,
    };
  }

  CartTotalsModel copyWith({
    required String totalItems,
    required String totalPrice,
  }) {
    return CartTotalsModel(
      totalItems: totalItems,
      totalPrice: totalPrice,
      currency: currency,
    );
  }
}
