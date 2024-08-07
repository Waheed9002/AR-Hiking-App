import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiking/screens/weather_controller.dart';
import 'package:hiking/screens/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/weather.dart';

class WeatherView extends GetView<WeatherController> {
  final WeatherController weatherController = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20)),
        title: Text(
          'Weather Forecast',
          style: GoogleFonts.lato(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Obx(() {
        if (weatherController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (weatherController.locationError.isNotEmpty) {
          return Center(child: Text(weatherController.locationError.value));
        }

        var currentWeather = weatherController.currentWeather.value;
        var tomorrowWeather = weatherController.tomorrowWeather.value;

        if (currentWeather == null || tomorrowWeather == null) {
          return Center(child: Text('Failed to load weather data'));
        }

        String iconUrl =
            'http://openweathermap.org/img/wn/${currentWeather.weatherIcon}@2x.png';
        String iconUrl2 =
            'http://openweathermap.org/img/wn/${tomorrowWeather.weatherIcon}@2x.png';

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueGrey],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildWeatherCard(currentWeather, iconUrl),
                  SizedBox(height: 20),
                  buildHourlyWeather(weatherController),
                  SizedBox(height: 30),
                  WeatherCard(
                    iconurl: iconUrl2,
                    title: 'Tomorrow',
                    weather: tomorrowWeather,
                  ),
                  SizedBox(height: 20),
                  buildMoreDetailsButton(context),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildWeatherCard(Weather currentWeather, String iconUrl) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${currentWeather.areaName}, ${currentWeather.country}',
              style: GoogleFonts.lato(
                fontSize: 33,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/clouds.png", width: 120),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${currentWeather.temperature?.celsius?.toStringAsFixed(1) ?? 'N/A'}°',
                  style: GoogleFonts.lato(
                    fontSize: 65,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '${currentWeather.weatherMain}',
                    style: GoogleFonts.lato(
                      fontSize: 27,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${DateFormat('EEE').format(DateTime.now())}  ${currentWeather.tempMin!.celsius!.toStringAsFixed(1)}° / ${currentWeather.tempMax!.celsius!.toStringAsFixed(1)}°",
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  "Air Quality: ${currentWeather.windSpeed} - ${categorizeAirQuality(currentWeather.windSpeed!)}",
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                currentWeather.weatherDescription!,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHourlyWeather(WeatherController weatherController) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Hourly Forecast',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: weatherController.hourlyWeather.value
                    .take(5)
                    .map((hourlyWeather) =>
                    buildHourlyWeatherWidget(hourlyWeather))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHourlyWeatherWidget(HourlyWeather hourlyWeather) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hoursAgoOrFromNow(hourlyWeather.dt),
            style: GoogleFonts.lato(
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Image.network(
            'http://openweathermap.org/img/wn/${hourlyWeather.weatherIcon}@2x.png',
            width: 30,
          ),
          SizedBox(height: 10),
          Text(
            '${hourlyWeather.temperature.toStringAsFixed(0)}°',
            style: GoogleFonts.lato(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String hoursAgoOrFromNow(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime).inHours;

    if (difference == 0) {
      return 'Now';
    } else if (difference > 0) {
      return '$difference hour${difference > 1 ? 's' : ''} ago';
    } else {
      final futureDifference = dateTime.difference(now).inHours;
      return '$futureDifference hour${futureDifference > 1 ? 's' : ''} ';
    }
  }

  String categorizeAirQuality(double value) {
    if (value < 20.0) {
      return 'Low';
    } else if (value >= 20.0 && value <= 40.0) {
      return 'Good';
    } else {
      return 'Speedy';
    }
  }

  Widget buildMoreDetailsButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          launchURL('https://openweathermap.org/');
        },
        child: Text(
          'More Details',
          style: GoogleFonts.lato(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class WeatherCard extends StatelessWidget {
  final String title;
  final String iconurl;
  final Weather weather;

  WeatherCard({required this.title, required this.iconurl, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(iconurl, width: 100),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${weather.temperature?.celsius?.toStringAsFixed(1) ?? 'N/A'}°',
                  style: GoogleFonts.lato(
                    fontSize: 50,
                    fontWeight: FontWeight.normal,
                    color: Colors.black87,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    '${weather.weatherMain}',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${DateFormat('EEE').format(DateTime.now().add(Duration(days: 1)))}  ${weather.tempMin!.celsius!.toStringAsFixed(1)}° / ${weather.tempMax!.celsius!.toStringAsFixed(1)}°",
                  style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
