// weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = '1f82cddb9dc8bd4683011c61b5a1d434';
  final String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather?lat=-7.5754887&lon=110.8243272&appid=1f82cddb9dc8bd4683011c61b5a1d434';

  Future<WeatherModel> fetchWeather(String city) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal Menampilkan data');
    }
  }
}
