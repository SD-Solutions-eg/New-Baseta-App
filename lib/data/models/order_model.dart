import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/data/models/area_model.dart';
import 'package:allin1/data/models/chat_model.dart';
import 'package:allin1/data/models/delivery_review_model.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/logic/bloc/firebaseAuth/firebase_auth_bloc.dart';
import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final int orderId;
  final OrderStatus status;
  final String currency;
  final String dateCreated;
  // final String shippingTotal;
  final String price;
  final String serviceFee;
  final String discount;
  final String deliveryMobile;
  final bool? giftCoupon;
  final String customerMobile;
  final OrderUserModel? customer;
  final LocationModel? customerLocation;
  final LocationModel? deliveryLocation;
  final int orderKey;
  final String? image;
  final String paymentMethod;
  final String paymentMethodTitle;
  final String orderContent;
  final List<OrderPackageModel> orderPackages;
  final OrderUserModel? partner;
  final OrderUserModel? delivery;
  final SectionModel? section;
  final AreaModel? area;
  final DeliveryReviewModel? review;
  final String? rating;
  final String? comment;
  final List<ReplyModel> comments;

  const OrderModel({
    this.orderId = 0,
    this.status = OrderStatus.pendingReview,
    this.currency = 'EGP',
    this.dateCreated = '',
    this.giftCoupon = false,
    required this.customerMobile,
    // this.shippingTotal = '0',
    required this.price,
    required this.serviceFee,
    required this.discount,
    required this.deliveryMobile,
    required this.customer,
    required this.customerLocation,
    required this.orderPackages,
    required this.partner,
    required this.section,
    required this.area,
    this.image,
    this.delivery,
    this.review,
    this.rating,
    this.comment,
    this.deliveryLocation,
    this.orderKey = 0,
    this.paymentMethod = 'cod',
    this.paymentMethodTitle = 'Cash on delivery',
    this.orderContent = '',
    this.comments = const [],
  });

  const OrderModel.create({
    this.orderId = 0,
    this.status = OrderStatus.pendingReview,
    this.currency = 'EGP',
    this.dateCreated = '',
    // this.shippingTotal = '0',
    this.giftCoupon = false,
    this.price = '0',
    this.serviceFee = '0',
    this.discount = '0',
    this.deliveryMobile = '01000000000',
    required this.customerMobile,
    required this.customer,
    required this.customerLocation,
    required this.partner,
    required this.orderContent,
    required this.area,
    this.image,
    this.review,
    this.delivery,
    this.rating,
    this.comment,
    this.deliveryLocation,
    required this.section,
    this.orderPackages = const [],
    this.orderKey = 0,
    this.paymentMethod = 'cod',
    this.paymentMethodTitle = 'Cash on delivery',
    this.comments = const [],
  });

  @override
  List<Object> get props {
    return [orderId];
  }

  Map<String, dynamic> toMap(int? imageId) {
    return {
      'status': 'publish',
      'content': orderContent,
      'fields': {
        'status': 'pending_review',
        'section': section?.id ?? 0,
        'area': area?.id,
        'partner': partner?.id ?? 0,
        'image': imageId,
        'customer': customer?.id,
        'customer_mobile': customerMobile,
        'location_customer': customerLocation?.toMap(customerLocation: true),
      }
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final role = FirebaseAuthBloc.currentUser!.role;
    final acf = map['acf'];
    final embedded = map['_embedded'] as Map<String, dynamic>?;
    final status = acf['status'] as String?;
    final orderStatus = status is String
        ? role == UserType.customer && status == 'assign_delivery'
            ? OrderStatus.assigningDelivery
            : status == 'pending_review'
                ? OrderStatus.pendingReview
                : status == 'assign_delivery'
                    ? OrderStatus.assigningDelivery
                    : status == 'on_way'
                        ? OrderStatus.onWay
                        : status == 'waiting'
                            ? OrderStatus.waiting
                            : status == 'pending_payment'
                                ? OrderStatus.pendingPayment
                                : status == 'delivered'
                                    ? OrderStatus.delivered
                                    : status == 'delivery_cancelled'
                                        ? OrderStatus.cancelled
                                        : status == 'customer_cancelled'
                                            ? OrderStatus.cancelled
                                            : OrderStatus.pendingReview
        : OrderStatus.pendingReview;
    return OrderModel(
      orderId: map['id'] as int,
      dateCreated: map['date'] as String,
      orderKey: map['id'] as int,
      discount: '${map['discount']}',
      deliveryMobile: map['delivery_mobile'] as String? ?? '',
      status: orderStatus,
      price: acf['price'] as String? ?? '0',
      serviceFee: acf['service_fees'] as String? ?? '0',
      customerMobile: acf['customer_mobile'] as String? ?? '',
      section: acf['section'] is Map
          ? SectionModel.fromMap(acf['section'] as Map<String, dynamic>)
          : null,
      area: acf['area'] is Map
          ? AreaModel.fromMap(acf['area'] as Map<String, dynamic>)
          : null,
      review: acf['review'] is Map
          ? DeliveryReviewModel.fromMap(acf['review'] as Map<String, dynamic>)
          : null,
      partner: acf['partner'] is Map
          ? OrderUserModel.fromMap(acf['partner'] as Map<String, dynamic>)
          : null,
      delivery: acf['delivery'] is Map
          ? OrderUserModel.fromMap(acf['delivery'] as Map<String, dynamic>)
          : null,
      customer: acf['customer'] is Map
          ? OrderUserModel.fromMap(acf['customer'] as Map<String, dynamic>)
          : null,
      customerLocation: acf is Map && acf['location_customer'] is Map
          ? LocationModel.fromMap(
              acf['location_customer'] as Map<String, dynamic>)
          : null,
      deliveryLocation: acf is Map && acf['location_delivery'] is Map
          ? LocationModel.fromMap(
              acf['location_delivery'] as Map<String, dynamic>)
          : null,
      orderContent: map['content']['raw'] as String? ??
          map['content'][renderedTxt] as String? ??
          '',
      orderPackages: const [],
      image: acf is Map && acf['image'] is Map
          ? acf['image']['url'] as String?
          : null,
      comments: embedded != null
          ? List<ReplyModel>.from(
              (embedded['replies'].first as List).map(
                (x) => ReplyModel.fromMap(x as Map<String, dynamic>),
              ),
            ).toList()
          : [],
      giftCoupon: map['coupon'] is Map && map['coupon']['type'] == 'free_gift',
    );
  }

  OrderModel copyWith({
    int? orderId,
    OrderStatus? status,
    String? currency,
    String? dateCreated,
    String? shippingTotal,
    String? price,
    String? serviceFee,
    String? discount,
    String? deliveryMobile,
    OrderUserModel? customer,
    LocationModel? customerLocation,
    LocationModel? deliveryLocation,
    int? orderKey,
    String? paymentMethod,
    String? paymentMethodTitle,
    String? orderContent,
    String? customerMobile,
    List<OrderPackageModel>? orderPackages,
    OrderUserModel? partner,
    OrderUserModel? delivery,
    SectionModel? section,
    AreaModel? area,
    DeliveryReviewModel? review,
    String? image,
    bool? giftCoupon,
    List<ReplyModel>? comments,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      discount: discount ?? this.discount,
      deliveryMobile: deliveryMobile ?? this.deliveryMobile,
      dateCreated: dateCreated ?? this.dateCreated,
      // shippingTotal: shippingTotal ?? this.shippingTotal,
      price: price ?? this.price,
      serviceFee: serviceFee ?? this.serviceFee,
      customer: customer ?? this.customer,
      customerMobile: customerMobile ?? this.customerMobile,
      customerLocation: customerLocation ?? this.customerLocation,
      orderKey: orderKey ?? this.orderKey,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodTitle: paymentMethodTitle ?? this.paymentMethodTitle,
      orderContent: orderContent ?? this.orderContent,
      orderPackages: orderPackages ?? this.orderPackages,
      partner: partner ?? this.partner,
      delivery: delivery ?? this.delivery,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      section: section ?? this.section,
      area: area ?? this.area,
      review: review ?? this.review,
      image: image ?? this.image,
      comments: comments ?? this.comments,
      giftCoupon: giftCoupon ?? this.giftCoupon,
    );
  }

  @override
  String toString() {
    return 'OrderModel(orderId: $orderId, status: $status, currency: $currency, dateCreated: $dateCreated, price: $price, customer: $customer, customerLocation: $customerLocation, deliveryLocation: $deliveryLocation, orderKey: $orderKey, image: $image, paymentMethod: $paymentMethod, paymentMethodTitle: $paymentMethodTitle, orderContent: $orderContent, orderPackages: $orderPackages, partner: $partner, delivery: $delivery, section: $section, area: $area, comments: $comments)';
  }
}

class OrderPackageModel extends Equatable {
  final int id;
  final String name;
  final int productId;
  final String adultNumber;
  final String childNumber;
  final String subtotalTax;
  final String subtotal;
  final String total;
  final String totalTax;
  final String? sku;
  final String adultPrice;
  final String childPrice;
  const OrderPackageModel({
    required this.id,
    required this.name,
    required this.productId,
    required this.adultNumber,
    required this.childNumber,
    this.subtotalTax = '0',
    required this.subtotal,
    required this.total,
    this.totalTax = '0',
    this.sku,
    required this.adultPrice,
    required this.childPrice,
  });

  @override
  List<Object> get props {
    return [
      id,
      name,
      productId,
      adultNumber,
      subtotal,
      subtotalTax,
      total,
      totalTax,
      sku ?? 'Null',
      adultPrice,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      "package": {"ID": id},
      "adult_price": adultPrice,
      "adult_number": adultNumber,
      "child_price": childPrice,
      "child_number": childNumber,
      "total_price": total,
    };
  }

  factory OrderPackageModel.fromMap(Map<String, dynamic> map) {
    final package = map['package'] as Map<String, dynamic>;
    return OrderPackageModel(
      id: package['ID'] as int,
      name: package['post_title'] as String,
      productId: package['ID'] as int,
      subtotal: map['total_price'] as String,
      total: map['total_price'] as String,
      adultPrice: map['adult_price'] as String,
      adultNumber: map['adult_number'] as String,
      childPrice: map['child_price'] as String,
      childNumber: map['child_number'] as String,
    );
  }
}

class OrderUserModel extends Equatable {
  final int id;
  final String name;
  final String username;

  const OrderUserModel({
    required this.id,
    required this.name,
    required this.username,
  });

  @override
  List<Object> get props => [id, name];

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory OrderUserModel.fromMap(Map<String, dynamic> map) {
    final fullName =
        '${map['user_firstname'] as String? ?? ''} ${map['user_lastname'] as String? ?? ''}';
    return OrderUserModel(
      id: map['ID'] as int,
      name: fullName.trim().isNotEmpty
          ? fullName
          : map['display_name'] as String? ??
              map['post_title'] as String? ??
              '',
      username:
          map['nickname'] as String? ?? map['user_nickname'] as String? ?? '',
    );
  }
}
