import 'dart:math';

import 'package:allin1/core/constants/app_config.dart';
import 'package:equatable/equatable.dart';

class PayPalOrderModel extends Equatable {
  final String intent;
  final Map<String, String> payer;
  final List<TransactionModel> transactions;
  final String noteToPayer;
  final Map<String, String> redirectUrls;
  const PayPalOrderModel({
    required this.transactions,
    this.intent = 'sale',
    this.payer = const {'payment_method': 'paypal'},
    this.noteToPayer = 'Contact us for any questions on your order.',
    this.redirectUrls = const {
      'return_url': 'https://success',
      'cancel_url': 'https://cancel'
    },
  });

  @override
  List<Object> get props {
    return [
      intent,
      payer,
      transactions,
      noteToPayer,
      redirectUrls,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'intent': intent,
      'payer': payer,
      'transactions': transactions.map((x) => x.toMap()).toList(),
      'note_to_payer': noteToPayer,
      'redirect_urls': redirectUrls,
    };
  }
}

class TransactionModel extends Equatable {
  final AmountModel amount;
  final String description;
  final String custom;
  final String invoiceNumber;
  final Map<String, String> paymentOption;
  final String softDescriptor;
  final List<PaypalItemModel> items;
  // final PaypalShippingAddressModel shippingAddress;
  const TransactionModel({
    required this.amount,
    this.description = 'This is the payment transaction description.',
    this.custom = '-',
    this.invoiceNumber = '',
    this.paymentOption = const {
      'allowed_payment_method': 'INSTANT_FUNDING_SOURCE'
    },
    this.softDescriptor = appName,
    required this.items,
  });

  @override
  List<Object> get props {
    return [
      amount,
      description,
      custom,
      invoiceNumber,
      paymentOption,
      softDescriptor,
      items,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount.toMap(),
      'description': description,
      'custom': custom,
      'invoice_number': Random().nextInt(999999).toString(),
      'payment_options': paymentOption,
      'soft_descriptor': softDescriptor,
      'item_list': {
        'items': items.map((e) => e.toMap()).toList(),
      },
    };
  }
}

class AmountModel extends Equatable {
  final String total;
  final String currency;
  final DetailsModel details;
  const AmountModel({
    required this.total,
    required this.currency,
    required this.details,
  });

  @override
  List<Object> get props => [total, currency, details];

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'currency': currency,
      'details': details.toMap(),
    };
  }
}

class DetailsModel extends Equatable {
  final String subtotal;
  final String tax;
  final String shipping;
  final String handlingFee;
  final String shippingDiscount;
  final String insurance;

  const DetailsModel({
    required this.subtotal,
    required this.tax,
    required this.shipping,
    this.handlingFee = '0.00',
    required this.shippingDiscount,
    this.insurance = '0.00',
  });

  @override
  List<Object> get props {
    return [
      subtotal,
      tax,
      shipping,
      handlingFee,
      shippingDiscount,
      insurance,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'handling_fee': handlingFee,
      'shipping_discount': shippingDiscount,
      'insurance': insurance,
    };
  }
}

class PaypalItemModel extends Equatable {
  final String name;
  final String description;
  final String quantity;
  final String price;
  final String tax;
  final String sku;
  final String currency;
  const PaypalItemModel({
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.tax,
    required this.sku,
    required this.currency,
  });

  @override
  List<Object> get props {
    return [
      name,
      description,
      quantity,
      price,
      tax,
      sku,
      currency,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'tax': tax,
      'sku': sku,
      'currency': currency,
    };
  }
}

class PaypalShippingAddressModel extends Equatable {
  final String recipientName;
  final String line1;
  final String line2;
  final String city;
  final String countryCode;
  final String postCode;
  final String phone;
  final String state;
  const PaypalShippingAddressModel({
    required this.recipientName,
    required this.line1,
    required this.line2,
    required this.city,
    required this.countryCode,
    required this.postCode,
    required this.phone,
    required this.state,
  });

  @override
  List<Object> get props {
    return [
      recipientName,
      line1,
      line2,
      city,
      countryCode,
      postCode,
      phone,
      state,
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'recipient_name': recipientName,
      'line1': line1,
      'line2': line2,
      'city': city,
      'country_code': countryCode,
      'postal_code': postCode,
      'phone': phone,
      'state': state,
    };
  }
}
