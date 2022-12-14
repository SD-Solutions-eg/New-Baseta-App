import 'package:equatable/equatable.dart';

class OrderCouponModel extends Equatable {
  final String code;
  final String discount;
  final String discountTax;
  const OrderCouponModel({
    required this.code,
    required this.discount,
    required this.discountTax,
  });

  @override
  List<Object> get props => [code, discount, discountTax];

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'discount': discount,
      'discount_tax': discountTax,
    };
  }
}
