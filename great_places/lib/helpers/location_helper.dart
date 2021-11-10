import 'dart:convert';

import "./config.dart";
import "package:http/http.dart" as http;

class LocationHelper {
  static String generateLocationPreviewImageURL(
          {required double latitude, required double longitude}) =>
      "https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=${Config.GOOGLE_MAPS_API_KEY}";

  static Future<String> getPlaceAddress(
      double latitude, double longitude) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Config.GOOGLE_MAPS_API_KEY}";
    final res = await http.get(Uri.parse(url));
    final results = json.decode(res.body)["results"];
    if (results == null || results.isEmpty) return "";
    return results[0]["formatted_address"] ?? "";
  }
}
