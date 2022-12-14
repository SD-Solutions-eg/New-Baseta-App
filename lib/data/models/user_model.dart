import 'package:allin1/core/constants/constants.dart';
import 'package:allin1/core/constants/enums.dart';
import 'package:allin1/data/models/area_model.dart';
import 'package:allin1/data/models/location_model.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String username;
  final String avatarUrl;
  final String firstName;
  final String lastName;
  final String email;
  final UserType role;
  final String? partnerArea;
  final UserDataModel userData;

  const UserModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.partnerArea,
    required this.role,
    required this.userData,
  });

  @override
  List<Object> get props {
    return [id, username];
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final role = map['roles'].first;
    return UserModel(
      id: map['id'] as int,
      username: map['username'] as String? ?? map['name'] as String,
      avatarUrl: map['simple_local_avatar'] is Map
          ? map['simple_local_avatar']['full'] as String
          : (map['avatar_urls'] as Map<String, dynamic>)['96'] as String,
      email: map['email'] as String? ?? '',
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      role: role == 'delivery'
          ? UserType.delivery
          : role == 'customer'
              ? UserType.customer
              : role == 'partner'
                  ? UserType.partner
                  : UserType.customer,
      partnerArea: map['acf'] is Map && map['acf']['area'] is Map
          ? map['acf']['area']['post_title'] as String?
          : null,
      userData: const UserDataModel.create(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'avatar_urls': {'96': avatarUrl},
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? avatarUrl,
    String? firstName,
    String? lastName,
    String? email,
    UserType? role,
    UserDataModel? userData,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      partnerArea: partnerArea,
      role: role ?? this.role,
      userData: userData ?? this.userData,
    );
  }
}

class UserDataModel extends Equatable {
  final int dataId;
  final int author;
  final String fullName;
  final String mobile;
  final String address;
  final LocationModel? mainLocation;
  final List<LocationModel> locations;
  final AreaModel? area;
  const UserDataModel({
    required this.dataId,
    required this.author,
    required this.fullName,
    required this.mobile,
    required this.address,
    this.mainLocation,
    required this.locations,
    this.area,
  });
  const UserDataModel.create({
    this.dataId = 0,
    this.author = 0,
    this.fullName = '',
    this.mobile = '',
    this.address = '',
    this.mainLocation,
    this.locations = const [],
    this.area,
  });

  @override
  List<Object> get props {
    return [dataId];
  }

  Map<String, dynamic> toMap() {
    return {
      'fields': {
        'mobile': mobile,
        'address': address,
        'main_location': mainLocation?.toMap(),
        'locations': locations.map((x) => x.toMap()).toList(),
        'area': area?.id,
      }
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    // log('User Data Map: $map');
    final acf = map['acf'];
    // log('User Locations: ${acf['locations']}');
    return UserDataModel(
      dataId: map['id'] as int,
      author: map['author'] as int,
      fullName: map['title'][renderedTxt] as String? ?? '',
      mobile: acf is Map ? acf['mobile'] as String? ?? '' : '',
      address: acf is Map ? acf['address'] as String? ?? '' : '',
      mainLocation: acf is Map && acf['main_location'] is Map
          ? LocationModel.fromMap(acf['main_location'] as Map<String, dynamic>)
          : null,
      area: acf is Map && acf['area'] is Map
          ? AreaModel.fromMap(acf['area'] as Map<String, dynamic>)
          : null,
      locations: acf is Map && acf['locations'] is List
          ? List<LocationModel>.from(
              (acf['locations'] as List).map(
                (e) {
                  if (e is Map) {
                    return LocationModel.fromMap(
                      e['location'] as Map<String, dynamic>,
                    );
                  }
                },
              ),
            ).toList()
          : [],
    );
  }

  UserDataModel copyWith({
    String? mobile,
    String? address,
    LocationModel? mainLocation,
    List<LocationModel>? locations,
    AreaModel? area,
  }) {
    return UserDataModel(
      dataId: dataId,
      author: author,
      fullName: fullName,
      mobile: mobile ?? this.mobile,
      address: address ?? this.address,
      mainLocation: mainLocation ?? this.mainLocation,
      locations: locations ?? this.locations,
      area: area ?? this.area,
    );
  }

  @override
  String toString() {
    return 'UserDataModel(ID: $dataId,auth: $author, fullName: $fullName, mobile: $mobile, address: $address, mainLocation: $mainLocation, locations: $locations, area: $area)';
  }
}
