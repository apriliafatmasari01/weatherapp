import 'package:flutter/material.dart';

class WeatherInfo extends StatelessWidget {
  final String weatherInfo;

  WeatherInfo({required this.weatherInfo});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          weatherInfo,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
