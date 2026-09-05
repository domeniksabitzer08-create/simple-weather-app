class City {
  final String name;
  final String county;
  final String state;
  final String country;
  final Map<String, double> coordinates;
  City({
    required this.name,
    required this.state,
    required this.country,
    required this.county,
    required this.coordinates,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json["properties"]["name"] ?? "",
      county: json["properties"]["county"] ?? "",
      state: json["properties"]["state"] ?? "",
      country: json["properties"]["country"] ?? "",
      coordinates: {
        "longitude": json["geometry"]["coordinates"][0],
        "latitude": json["geometry"]["coordinates"][1],
      },
    );
  }
}
