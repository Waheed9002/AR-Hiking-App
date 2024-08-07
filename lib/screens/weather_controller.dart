import 'dart:ui';

import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hiking/screens/weatherService.dart';
import 'package:hiking/screens/weather_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/weather.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WeatherController extends GetxController {
  final String apiKey = 'd0cd2b8d0b6da1474e655bbb1e57abb0'; // Replace with your API key
  WeatherFactory ? wf;
  final webcontroller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..setBackgroundColor(const Color(0x00000000))
    ..enableZoom(true)
    ..loadRequest(Uri.parse('https://openweathermap.org/')).obs;
  var hourlyWeather = <HourlyWeather>[].obs;
  var currentWeather = Rx<Weather?>(null);
  var tomorrowWeather = Rx<Weather?>(null);
  var isLoading = true.obs;
  var locationError = ''.obs;
  final WeatherService weatherService = WeatherService();
  @override
  void onInit() {
    super.onInit();
    wf = WeatherFactory(apiKey);
    getCurrentLocationWeather();
  }

  Future<void> checkPermissions() async {
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        locationError.value = 'Location permission denied';
        return;
      }
    }
  }

  Future<void> getCurrentLocationWeather() async {
    await checkPermissions();
    if (locationError.isNotEmpty) return;

    isLoading.value = true;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double lon = position.longitude;

      // Fetch today's weather
      currentWeather.value = await wf!.currentWeatherByLocation(lat, lon);
print(currentWeather.value!.toJson());
      // Fetch tomorrow's weather
      List<Weather> forecast = await wf!.fiveDayForecastByLocation(lat, lon);
      tomorrowWeather.value = forecast.isNotEmpty ? forecast[1] : null;

      var hourlyData = await weatherService.fetchHourlyWeather(lat, lon);
      hourlyWeather.value = hourlyData.map((data) => HourlyWeather.fromJson(data)).toList();
print(hourlyWeather.value);
    } catch (e) {
      locationError.value = 'Failed to get location or weather data: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
