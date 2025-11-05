class Address {
  final String route;
  final String number;
  final String neighborhood;
  final String locality;
  final String administrativeArea;
  final String country;
  final double? lat;
  final double? long;

  const Address({
    required this.route,
    required this.number,
    required this.neighborhood,
    required this.locality,
    required this.administrativeArea,
    required this.country,
    this.lat,
    this.long,
  });

  //enviar
  Map<String, dynamic> toJson() {
    return {
      "route": route,
      "number": number,
      "neighborhood": neighborhood,
      "locality": locality,
      "administrativeArea": administrativeArea,
      "country": country,
      "lat": lat,
      "long": long,
    };
  }

  //receber
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      route: map['route'] ?? '',
      number: map['number'] ?? '',
      neighborhood: map['neighborhood'] ?? '',
      locality: map['locality'] ?? '',
      administrativeArea: map['administrativeArea'] ?? '',
      country: map['country'] ?? '',
      lat: (map['lat'] as num?)?.toDouble() ?? 0.0,
      long: (map['long'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
