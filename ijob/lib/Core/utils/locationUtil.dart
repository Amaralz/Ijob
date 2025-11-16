import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ijob/Core/Entities/address.dart';
import 'package:ijob/Core/utils/stringReplacer.dart';

const googleApikey = "AIzaSyCdbBzSe4VFGc8JVqWIjusUaUIwmH2EmFs";

class Locationutil {
  static String generationLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$googleApikey';
  }

  String _findComponent(List<dynamic> components, String type) {
    try {
      final component = components.firstWhere(
        (comp) => comp['types'].contains(type),
        orElse: () => null,
      );

      if (component != null) {
        return component['long_name'];
      }
    } catch (error) {
      throw "Erro ao tentar encontrar componente";
    }
    return '';
  }

  //pega o endereço se baseando na latitude longitude
  Future<Address?> getAdressFromLatLng(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApikey&language=pt-BR';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data["status"] == 'OK') {
      final result = data['results'][0];
      final List<dynamic> components = result['address_components'];

      final number = _findComponent(components, 'street_number');
      final route = _findComponent(components, 'route');
      final neighborhood = _findComponent(components, 'political');
      final locality = _findComponent(
        components,
        'administrative_area_level_2',
      );
      final administrativeArea = _findComponent(
        components,
        'administrative_area_level_1',
      );

      final country = _findComponent(components, 'country');

      final Address endereco = Address(
        route,
        number,
        neighborhood,
        locality,
        administrativeArea,
        country,
        position.latitude,
        position.longitude,
      );

      return endereco;
    } else {
      return null;
    }
  }

  //pega a latitude e longitude baseando no endereço
  static Future<LatLng> getLatLngFromAdress(
    String route,
    String number,
    String neighborhood,
    String locality,
    String administrativeArea,
    String country,
  ) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?components=route:${Stringreplacer.toUrl(route)}|street_number:${Stringreplacer.toUrl(number)}|sublocality:${Stringreplacer.toUrl(neighborhood)}|locality:${Stringreplacer.toUrl(locality)}|administrative_area_level_1:${Stringreplacer.toUrl(administrativeArea)}|country:${Stringreplacer.toUrl(country)}&key=$googleApikey';
    final response = await http.get(Uri.parse(url));
    var locationMap = jsonDecode(
      response.body,
    )['results'][0]['geometry']['location'];
    LatLng coord = LatLng(locationMap['lat'], locationMap['lng']);
    return coord;
  }
}
