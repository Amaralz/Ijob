import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  final String _route;
  final String _number;
  final String _neighborhood;
  final String _locality;
  final String _administrativeArea;
  final String _country;
  final double? _lat;
  final double? _long;

  const Address(
    this._route,
    this._number,
    this._neighborhood,
    this._locality,
    this._administrativeArea,
    this._country,
    this._lat,
    this._long,
  );

  //enviar
  Map<String, dynamic> toJson() {
    return {
      "route": _route,
      "number": _number,
      "neighborhood": _neighborhood,
      "locality": _locality,
      "administrativeArea": _administrativeArea,
      "country": _country,
      "lat": _lat,
      "long": _long,
    };
  }

  //receber
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      map['route'] ?? '',
      map['number'] ?? '',
      map['neighborhood'] ?? '',
      map['locality'] ?? '',
      map['administrativeArea'] ?? '',
      map['country'] ?? '',
      (map['lat'] as num?)?.toDouble() ?? 0.0,
      (map['long'] as num?)?.toDouble() ?? 0.0,
    );
  }

  LatLng get latilong {
    return LatLng(_lat!, _long!);
  }

  String get locality {
    return _locality;
  }

  String get neighborhood {
    return _neighborhood;
  }

  String get route {
    return _route;
  }

  String get number {
    return _number;
  }

  String get country {
    return _country;
  }

  String get state {
    return _administrativeArea;
  }
}
