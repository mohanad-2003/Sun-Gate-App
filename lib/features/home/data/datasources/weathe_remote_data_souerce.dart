import 'package:dio/dio.dart';
import 'package:sun_gate_app/features/home/data/models/hourly_weather_model.dart';
import 'package:sun_gate_app/features/home/data/models/weather_model.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(this.dio);

  Future<WeatherModel> getWeather(double lat, double lon) async {
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/forecast',
      queryParameters: {
        'lat': 31.5017,
        'lon': 34.4666,
        'appid': '0070208a29b941b5f2e54c6f61c61e0d',
        'units': 'metric',
      },
    );

    final data = response.data;

    final current = data['list'][0];

    final temp = current['main']['temp'].toDouble();
    final humidity = current['main']['humidity'];
    final wind = current['wind']['speed'].toDouble();
    final condition = current['weather'][0]['main'];
    final cityName = data['city']['name'];

    final List<HourlyWeather> hourly = [];

    for (int i = 0; i < 6; i++) {
      final item = data['list'][i];

      final time = item['dt_txt'].toString().substring(11, 16);
      final rain = ((item['pop'] ?? 0) * 100).toInt();

      hourly.add(HourlyWeather(time: time, precipitation: rain));
    }

    return WeatherModel(
      temp: temp,
      humidity: humidity,
      wind: wind,
      condition: condition,
      cityName: cityName,
      hourly: hourly,
    );
  }
}
