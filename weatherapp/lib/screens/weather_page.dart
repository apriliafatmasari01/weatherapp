import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String _cityName = '';
  String _weatherInfo = 'Masukkan nama kota untuk mendapat informasi.';
  String _temperature = '';
  String _weatherIcon = '';
  List<String> _hourlyTimes = [];
  List<String> _hourlyTemps = [];
  List<String> _hourlyWeatherIcons = [];
  final String apiKey = '1f82cddb9dc8bd4683011c61b5a1d434';

  Future<void> _fetchWeather() async {
    if (_cityName.isEmpty) {
      setState(() {
        _weatherInfo = 'Masukkan nama kota yang sesuai';
      });
      return;
    }

    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$_cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final temperature = data['list'][0]['main']['temp'];
      final weatherDescription = data['list'][0]['weather'][0]['description'];
      final iconCode = data['list'][0]['weather'][0]['icon'];

      _hourlyTimes.clear();
      _hourlyTemps.clear();
      _hourlyWeatherIcons.clear();
      for (int i = 0; i < 12; i++) {
        final hourData = data['list'][i];
        final hourTemp = hourData['main']['temp'];
        final hourTime =
            DateFormat('HH:mm').format(DateTime.parse(hourData['dt_txt']));
        final hourIcon = hourData['weather'][0]['icon'];
        _hourlyTimes.add(hourTime);
        _hourlyTemps.add('$hourTemp°C');
        _hourlyWeatherIcons
            .add('http://openweathermap.org/img/wn/$hourIcon@2x.png');
      }

      setState(() {
        _weatherInfo = '$_cityName: $weatherDescription';
        _temperature = '$temperature°C';
        _weatherIcon = 'http://openweathermap.org/img/wn/$iconCode@2x.png';
      });
    } else {
      setState(() {
        _weatherInfo = 'Error. Coba lagi';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.indigo[500]!,
        elevation: 5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[500]!, Colors.blue[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 8,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Masukkan nama kota',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon:
                        Icon(Icons.location_city, color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    _cityName = value;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchWeather,
                  child: Text('Tampilkan cuaca'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                if (_weatherInfo.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _weatherIcon.isNotEmpty
                              ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/loading.gif',
                                  image: _weatherIcon,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.cloud,
                                  size: 60, color: Colors.white70),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        _temperature,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _weatherInfo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 15),
                Text(
                  'Cuaca Setiap Jam',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _hourlyTimes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white.withOpacity(0.8),
                        elevation: 8,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FadeInImage.assetNetwork(
                                placeholder: 'assets/loading.gif',
                                image: _hourlyWeatherIcons[index],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${_hourlyTimes[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${_hourlyTemps[index]}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
