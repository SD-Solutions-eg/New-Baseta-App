import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final String address;
  final double lat;
  final double lng;
  final int zoom;
  final String placeId;
  final String city;
  final String country;
  final String countryCode;

  const LocationModel({
    required this.address,
    required this.lat,
    required this.lng,
    required this.zoom,
    required this.placeId,
    required this.city,
    required this.country,
    required this.countryCode,
  });

  const LocationModel.create({
    this.address = '',
    this.lat = 30.0444,
    this.lng = 31.2357,
    this.zoom = 16,
    this.placeId = '',
    this.city = 'Cairo',
    this.country = 'Egypt',
    this.countryCode = 'EG',
  });

  @override
  List<Object> get props {
    return [lat, lng];
  }

  Map<String, dynamic> toMap(
      {bool customerLocation = false, bool isLiveLocation = false}) {
    if (customerLocation) {
      return {
        'address': address,
        'lat': lat,
        'lng': lng,
        'zoom': zoom,
        'place_id': placeId,
        'city': city,
        'country': country,
        'country_short': countryCode,
      };
    } else {
      return {
        'location': {
          'address': address,
          'lat': lat,
          'lng': lng,
          'zoom': zoom,
          'place_id': placeId,
          'city': city,
          'country': country,
          'country_short': countryCode,
        }
      };
    }
  }

  Map<String, dynamic> locationsToMap(List<LocationModel> locations) {
    return {
      "fields": {
        "locations": locations.map((e) => e.toMap()).toList(),
      }
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      address: map['address'] as String? ?? '',
      lat: map['lat'] as double? ?? 30.0444,
      lng: map['lng'] as double? ?? 31.2357,
      zoom: map['zoom'] as int? ?? 16,
      placeId: map['place_id'] as String? ?? '',
      city: map['city'] as String? ?? '',
      country: map['country'] as String? ?? 'Egypt',
      countryCode: map['country_short'] as String? ?? 'EG',
    );
  }

  LocationModel copyWith({
    String? address,
    double? lat,
    double? lng,
    int? zoom,
    String? placeId,
    String? city,
    String? country,
    String? countryCode,
  }) {
    return LocationModel(
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      zoom: zoom ?? this.zoom,
      placeId: placeId ?? this.placeId,
      city: city ?? this.city,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  String toString() {
    return 'LocationModel(address: $address, lat: $lat, lng: $lng, zoom: $zoom, placeId: $placeId, city: $city, country: $country, countryCode: $countryCode)';
  }
}
