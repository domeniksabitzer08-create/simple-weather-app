class City {
  final String name;
  final String state;
  final String country;
  City({required this.name, required this.state, required this.country});

  factory City.fromJson(Map<String, dynamic> json) {
    String newState = "";
    if (json["state"] != null) {
      newState = json["state"];
    }
    return City(
      name: json["name"],
      country: json["country"],
      state: newState,
    );
  }
}
