class City {
  final String name;
  final String county;
  final String state;
  final String country;
  City({
    required this.name,
    required this.state,
    required this.country,
    required this.county,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json["name"] ?? "",
      county: json["county"] ?? "",
      state: json["state"] ?? "",
      country: json["country"] ?? "",
    );
  }
}
