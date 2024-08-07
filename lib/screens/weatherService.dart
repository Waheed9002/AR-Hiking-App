import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'd0cd2b8d0b6da1474e655bbb1e57abb0';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';
  Future<List<Map<String, dynamic>>> fetchHourlyWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse('$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['list'] as List).map((hourlyData) => hourlyData as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load hourly weather data');
    }
  }
}
