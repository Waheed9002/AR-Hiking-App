// File: weather_info.dart
import 'package:flutter/material.dart';

class WeatherInfo extends StatelessWidget {
  const WeatherInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Information'),
      ),
      body: const Center(
        child: Text(
          'Weather details will be displayed here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
