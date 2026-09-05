class Weather {
  final String weather;
  final double temperature;

  Weather({
    required this.weather,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      weather: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
    );
  }
}
