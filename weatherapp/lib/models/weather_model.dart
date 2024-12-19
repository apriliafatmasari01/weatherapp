class WeatherModel {
  final String city;
  final String condition;
  final double temperature;

  WeatherModel({
    required this.city,
    required this.condition,
    required this.temperature,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      condition: json['weather'][0]['description'],
      temperature: json['main']['temp'],
    );
  }
}
