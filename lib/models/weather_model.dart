class Weather {
  final String locationName;
  final String weather;
  final double temperature;

  Weather({
    required this.locationName,
    required this.weather,
    required this.temperature,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      locationName: json["name"],
      weather: json['weather'][0]['main'],
      temperature: json['main']['temp'].toDouble(),
    );
  }
}
