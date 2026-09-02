import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_weather_app/constants/design.dart';
import 'package:simple_weather_app/constants/weather_animations_cases.dart';
import 'package:simple_weather_app/models/weather_model.dart';
import 'package:simple_weather_app/service/weather_service.dart';
import 'package:simple_weather_app/views/loading_view.dart';

class MainWeatherView extends StatefulWidget {
  const MainWeatherView({super.key});

  @override
  State<MainWeatherView> createState() => _MainWeatherViewState();
}

class _MainWeatherViewState extends State<MainWeatherView> {
  final WeatherService _weatherService = WeatherService(
    apiKey: "379b9339779c3d7ff6bac58ad5b0504b",
  );

  Weather? _weather;

  // for updating the weather
  late Timer _timer;

  void _fetchCurrentWeather() async {
    // get current location
    String location = await _weatherService.getCurrentLocation();
    // get weather
    _weather = await _weatherService.getWeather(location);
    setState(() {
      _weather = _weather;
    });
  }

  String getWeatherAnimation(String weather) {
    weather = weather.toLowerCase();
    if (sunnyWeatherNames.contains(weather)) return sunnyAnimationPath;
    if (rainyWeatherNames.contains(weather)) return rainyAnimationPath;
    if (cloudyWeatherNames.contains(weather)) return cloudyAnimationPath;
    if (stormWeatherNames.contains(weather)) {
      return stormAnimationPath;
    } else {
      log("No animation for this weather: $weather | using sunny");
      return sunnyAnimationPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? location = _weather?.locationName;
    String? weather = _weather?.weather;
    double? temp = _weather?.temperature;
    if (_weather == null) {
      return LoadingView();
    }
    return Scaffold(
      backgroundColor: backgroundColorDarkMode,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 115, horizontal: 10),
        child: Center(
          child: Column(
            children: [
              AppText(
                text: location ?? "",
                size: 30,
              ),
              Time(),
              Expanded(
                flex: 10,
                child: Align(
                  alignment: AlignmentGeometry.center,
                  child: Lottie.asset(getWeatherAnimation(weather!)),
                ),
              ),
              Expanded(
                flex: 1,
                child: AppText(text: "$temp C°"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _fetchCurrentWeather();
    _timer = Timer.periodic(
      Duration(seconds: 10),
      (timer) => _fetchCurrentWeather(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

class AppText extends StatelessWidget {
  final String _text;
  final double? _size;
  final Color? _fontColor;

  const AppText({super.key, required this._text, this._size, this._fontColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        fontSize: _size,
        color: _fontColor ?? fontColorDarkMode,
      ),
    );
  }
}

class Time extends StatefulWidget {
  const new({super.key});

  @override
  State<Time> createState() => _TimeState();
}

class _TimeState extends State<Time> {
  DateTime _time = DateTime.now();
  late Timer _timer;
  @override
  Widget build(BuildContext context) {
    final timeFormatted = DateFormat('HH:mm').format(_time);
    return AppText(
      text: timeFormatted,
      size: 18,
    );
  }

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        _time = DateTime.now();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
