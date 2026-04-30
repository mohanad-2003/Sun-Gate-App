import 'package:sun_gate_app/features/home/data/models/hourly_weather_model.dart';

class WeatherModel {
  final double temp;
  final int humidity;
  final double wind;
  final String condition;
  final String cityName;
  final List<HourlyWeather> hourly;
  const WeatherModel({
    required this.temp,
    required this.humidity,
    required this.wind,
    required this.condition,
    required this.cityName,
    required this.hourly,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temp: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      wind: json['wind']['speed'].toDouble(),
      condition: json['weather'][0]['main'],
      cityName: json['cityName'],
      hourly: json['hourly'],
    );
  }
}
