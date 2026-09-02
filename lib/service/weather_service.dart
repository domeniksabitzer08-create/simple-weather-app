import 'dart:convert';
import 'dart:core';
import 'dart:developer' show log;
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:simple_weather_app/models/city_model.dart';
import 'package:simple_weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  static const BASE_URL_CITIES = "http://api.openweathermap.org/geo/1.0/direct";
  static const LIMIT_AUTOCOMPLETION = 5;
  final String apiKey;
  final Geocoding _geocoding = Geocoding();

  WeatherService({required this.apiKey});

  Future<Weather> getWeather(String locationName) async {
    final request = Uri.parse(
      "$BASE_URL?q=$locationName&appid=$apiKey&units=metric",
    );
    log(request.toString());
    final response = await http.get(
      Uri.parse("$BASE_URL?q=$locationName&appid=$apiKey&units=metric"),
    );
    if (response.statusCode == 200) {
      log("Got response");
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<String> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    String? city = placemarks[0].locality;
    // if the locatlity is null take the sublocality
    city ??= placemarks[0].subLocality;
    if (city != null) {
      city = fromatLocationName(city);
      return city;
    }
    return "";
  }

  String fromatLocationName(String name) {
    List<String> nameList = name.split("");
    String newName = "";
    if (nameList.contains('-')) {
      final idx = nameList.indexOf('-');
      nameList.insert(idx, " ");
      nameList.insert(idx + 2, " ");
    } else {
      return name;
    }

    for (int i = 0; i < nameList.length; i++) {
      newName += nameList[i];
    }
    log("formatted location name: $newName");
    return newName;
  }

  Future<List<City>> getCities(String search) async {
    final request = Uri.parse(
      "$BASE_URL_CITIES?q=$search&limit=$LIMIT_AUTOCOMPLETION&appid=$apiKey",
    );
    final response = await http.get(request);
    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      final List<City> cities = [];
      for (int i = 0; i < json.length; i++) {
        cities.add(City.fromJson(json[i]));
      }
      return cities;
    }
    return [
      City(
        name: "No city found",
        state: "No city found",
        country: "No city found",
      ),
    ];
  }
}
