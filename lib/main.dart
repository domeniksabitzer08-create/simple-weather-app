import 'package:flutter/material.dart';
import 'package:simple_weather_app/constants/routes.dart';
import 'package:simple_weather_app/views/loading_view.dart';
import 'package:simple_weather_app/views/main_weather_view.dart';
import 'package:simple_weather_app/views/search_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: MainWeatherView(),
      routes: {
        mainWeatherRoute: (context) => MainWeatherView(),
        searchRoute: (context) => SearchView(),
      },
    );
  }
}
