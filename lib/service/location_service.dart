import 'dart:convert';
import 'dart:developer' show log;

import 'package:http/http.dart' as http;
import 'package:simple_weather_app/models/city_model.dart';

class LocationService {
  static final BASE_URL = "https://photon.komoot.io/api/";
  static final LIMIT = 10;

  Future<List<City>> getCities(String search) async {
    final request = Uri.parse(
      "$BASE_URL?q=$search&limit=$LIMIT&osm_tag=place",
    );
    final response = await http.get(
      request,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    );
    List<City> cities = [];
    log(request.toString());
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body)["features"];
      for (int i = 0; i < json.length; i++) {
        cities.add(City.fromJson(json[i]["properties"]));
      }
      return cities;
    }
    return [];
  }
}
