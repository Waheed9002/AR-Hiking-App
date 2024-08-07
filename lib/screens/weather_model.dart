class HourlyWeather {
  final DateTime dt;
  final double temperature;
  final String weatherIcon;
  final String weatherDescription;

  HourlyWeather({
    required this.dt,
    required this.temperature,
    required this.weatherIcon,
    required this.weatherDescription,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      dt: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['main']['temp'].toDouble(),
      weatherIcon: json['weather'][0]['icon'],
      weatherDescription: json['weather'][0]['description'],
    );
  }
}