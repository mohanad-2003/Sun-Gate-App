import 'package:dio/dio.dart';
import 'package:sun_gate_app/features/home/data/models/hourly_weather_model.dart';
import 'package:sun_gate_app/features/home/data/models/weather_model.dart';

class WeatherRemoteDataSource {
  final Dio dio;

  WeatherRemoteDataSource(this.dio);

  Future<WeatherModel> getWeather(double lat, double lon, String lang) async {
    final response = await dio.get(
      'https://api.openweathermap.org/data/2.5/forecast',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': '0070208a29b941b5f2e54c6f61c61e0d',
        'units': 'metric',
        'lang': lang,
      },
    );

    final data = response.data;
    final current = data['list'][0];

    final temp = current['main']['temp'].toDouble();
    final humidity = current['main']['humidity'];
    final wind = current['wind']['speed'].toDouble();
    

    final mainCondition = current['weather'][0]['main'];
    final description = current['weather'][0]['description'];
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
      condition: description,
      mainCondition: mainCondition,
      cityName: cityName,
      hourly: hourly,
    );
  }
}
