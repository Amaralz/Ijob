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
}
