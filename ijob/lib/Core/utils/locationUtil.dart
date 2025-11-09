import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ijob/Core/utils/stringReplacer.dart';

const googleApikey = "AIzaSyCdbBzSe4VFGc8JVqWIjusUaUIwmH2EmFs";

class Locationutil {
  static String generationLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$googleApikey';
  }

  //pega o endereço se baseando na latitude longitude
  static Future<String> getAdressFromLatLng(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApikey';
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body)['results'][0]['formatted_address'];
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
