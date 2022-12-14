import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String firstName;
  final String lastName;
  final String company;
  final String address1;
  final String? address2;
  final String city;
  final String postcode;
  final String country;
  final String state;
  final String phone;
  final String? email;

  const AddressModel({
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.address1,
    this.address2,
    required this.city,
    required this.postcode,
    required this.country,
    required this.state,
    required this.phone,
    this.email,
  });

  @override
  List<Object> get props {
    return [
      firstName,
      lastName,
      company,
      address1,
      city,
      postcode,
      country,
      state,
    ];
  }

  Map<String, dynamic> toMap({required bool isBilling}) {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'company': company,
      'address_1': address1,
      'address_2': address2 ?? '',
      'city': city,
      'postcode': postcode,
      'country': country,
      'state': state,
      'phone': phone,
      if (isBilling) 'email': email,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      company: map['company'] as String,
      address1: map['address_1'] as String,
      address2: map['address_2'] as String?,
      city: map['city'] as String,
      postcode: map['postcode'] as String,
      country: map['country'] as String? ?? 'EG',
      state: map['state'] as String? ?? 'EGC',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String?,
    );
  }

  AddressModel copyWith({
    String? firstName,
    String? lastName,
    String? company,
    String? address1,
    String? address2,
    String? city,
    String? postcode,
    String? country,
    String? state,
    String? phone,
    String? email,
  }) {
    return AddressModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      company: company ?? this.company,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      state: state ?? this.state,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  @override
  bool get stringify => true;
}
