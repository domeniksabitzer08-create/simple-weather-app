import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:simple_weather_app/models/city_model.dart';
import 'package:simple_weather_app/service/location_service.dart';
import 'package:simple_weather_app/service/weather_service.dart';
import 'package:simple_weather_app/views/main_weather_view.dart';

class SearchView extends StatefulWidget {
  const new({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final LocationService _locationService = LocationService();

  void _fetchCities(String value) async {
    log("Make call value: $value");
    final newCities = await _locationService.getCities(value);
    log("These cities were found: $newCities");
    if (mounted) {
      setState(() {
        cities = newCities;
      });
    }
  }

  final _apiCallCooldown = 2;

  List<City> cities = [];

  late Timer _timer;
  bool _canMakeCall = true;
  String _textFiedValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.directional(
              start: 30,
              end: 30,
              top: 50,
            ),
            child: TextField(
              onChanged: (value) {
                _textFiedValue = value;
                _canMakeCall = true;
              },
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return LocationLabel(
                  city: cities[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _timer = Timer.periodic(
      Duration(seconds: _apiCallCooldown),
      (Timer timer) {
        if (_canMakeCall) {
          _fetchCities(_textFiedValue);
          _canMakeCall = false;
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class LocationLabel extends StatelessWidget {
  final City _city;
  const LocationLabel({super.key, required this._city});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(
        vertical: 5,
        horizontal: 10,
      ),

      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, _city.name);
        },
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            const Color.fromARGB(255, 35, 117, 183),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Align(
                alignment: AlignmentGeometry.center,
                child: AppText(
                  text: _city.name,
                  size: 30,
                ),
              ),
            ),
            AppText(text: "${_city.state}, ${_city.country}"),
          ],
        ),
      ),
    );
  }
}
