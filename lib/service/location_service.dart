import 'dart:convert';
import 'dart:developer' show log;

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:simple_weather_app/models/city_model.dart';

class LocationService {
  static final BASE_URL = "https://photon.komoot.io/api/";
  static final BASE_REVERSE_URL = "https://photon.komoot.io/reverse";
  static final LIMIT = 10;

  Future<List<City>> getCities(String search) async {
    final response = await makeCall(search);

    List<City> cities = [];

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)["features"];
      for (int i = 0; i < json.length; i++) {
        cities.add(City.fromJson(json[i]));
      }
      return cities;
    }
    return [];
  }

  Future<City> getCity(String search) async {
    final response = await makeCall(search, limit: 1);
    final List<dynamic> json = jsonDecode(response.body)["features"];
    return City.fromJson(json[0]);
  }

  Future<http.Response> makeCall(String search, {int? limit}) async {
    limit = limit ?? LIMIT;
    final request = Uri.parse(
      "$BASE_URL?q=$search&limit=$limit&osm_tag=place&lang=en",
    );
    final response = await http.get(
      request,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );
    return response;
  }

  Future<http.Response> makeReverseCall(Map<String, double> cords) async {
    final lon = cords["longitude"];
    final lat = cords["latitude"];

    final request = Uri.parse(
      "$BASE_REVERSE_URL?lon=$lon&lat=$lat",
    );
    final response = await http.get(
      request,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );
    return response;
  }

  Future<City> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition();
    final cords = {
      "latitude": position.latitude,
      "longitude": position.longitude,
    };
    final response = await makeReverseCall(cords);
    final List<dynamic> json = jsonDecode(response.body)["features"];
    return City.fromJson(json[0]);
  }
}
