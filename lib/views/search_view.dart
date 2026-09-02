import 'package:flutter/material.dart';
import 'package:simple_weather_app/models/city_model.dart';
import 'package:simple_weather_app/service/weather_service.dart';
import 'package:simple_weather_app/views/main_weather_view.dart';

class SearchView extends StatefulWidget {
  const new({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final WeatherService _weatherService = WeatherService(
    apiKey: "379b9339779c3d7ff6bac58ad5b0504b",
  );

  void _fetchCities() async {
    final newCities = await _weatherService.getCities("Wolfsberg");
    setState(() {
      cities = newCities;
    });
  }

  List<City> cities = [];
  @override
  Widget build(BuildContext context) {
    _fetchCities();
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
      child: Container(
        height: 70,
        width: 300,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 130, 143, 168),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Align(
                alignment: AlignmentGeometry.center,
                child: AppText(
                  text: _city.name,
                  size: 30,
                ),
              ),
            ),
            Expanded(child: AppText(text: "${_city.state}, ${_city.country}")),
          ],
        ),
      ),
    );
  }
}
