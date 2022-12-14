// ignore_for_file: avoid_dynamic_calls

import 'package:equatable/equatable.dart';

class ContactUsModel extends Equatable {
  final String email;
  final Location? location;
  final String mobile;
  final List<SocialMediaModel> socialMedia;
  final String telegram;
  final String whatsApp;
  const ContactUsModel({
    required this.email,
    required this.location,
    required this.mobile,
    required this.socialMedia,
    required this.telegram,
    required this.whatsApp,
  });

  @override
  List<Object> get props {
    return [
      email,
      mobile,
      socialMedia,
      telegram,
      whatsApp,
    ];
  }

  factory ContactUsModel.fromMap(Map<String, dynamic> acf) {
    final map = acf['acf'];
    return ContactUsModel(
      email: map['email'] as String,
      location: map['location'] != null
          ? Location.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      mobile: map['mobile'] as String,
      socialMedia: map['social_networks'] is bool
          ? []
          : List<SocialMediaModel>.from(
              (map['social_networks'] as List<dynamic>).map(
                (x) => SocialMediaModel.fromMap(x as Map<String, dynamic>),
              ),
            ),
      telegram: map['telegram'] as String,
      whatsApp: map['whatsapp'] as String,
    );
  }
}

class Location extends Equatable {
  final String address;
  final double lat;
  final double lng;
  final int zoom;
  final String? placeId;
  final String? city;
  final String? state;
  final String? country;
  final String? countryCode;

  const Location({
    required this.address,
    required this.lat,
    required this.lng,
    required this.zoom,
    required this.placeId,
    required this.city,
    required this.state,
    required this.country,
    required this.countryCode,
  });

  @override
  List<Object> get props {
    return [
      address,
      lat,
      lng,
      zoom,
    ];
  }

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      address: map['address'] as String,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
      zoom: map['zoom'] as int? ?? 15,
      placeId: map['place_id'] as String?,
      city: map['city'] as String?,
      state: map['state'] as String?,
      country: map['country'] as String?,
      countryCode: map['country_short'] as String?,
    );
  }
}

class SocialMediaModel extends Equatable {
  final int id;
  final String title;
  final String iconUrl;
  final String link;

  const SocialMediaModel({
    required this.id,
    required this.title,
    required this.iconUrl,
    required this.link,
  });

  @override
  List<Object> get props => [id, title, iconUrl, link];

  factory SocialMediaModel.fromMap(Map<String, dynamic> map) {
    final iconMap = map['icon'] as Map<String, dynamic>;
    return SocialMediaModel(
      id: iconMap['id'] as int,
      title: iconMap['title'] as String,
      iconUrl: iconMap['url'] as String,
      link: map['url'] as String,
    );
  }
}
