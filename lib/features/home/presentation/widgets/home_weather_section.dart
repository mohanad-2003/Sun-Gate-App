import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/home/data/models/hourly_weather_model.dart';

class HomeWeatherSection extends StatelessWidget {
  final double temp;
  final int humidity;
  final double wind;
  final String condition;
  final String cityName;
  final List<HourlyWeather> hourly;

  const HomeWeatherSection({
    super.key,
    required this.temp,
    required this.humidity,
    required this.wind,
    required this.condition,
    required this.cityName,
    required this.hourly,
  });

  IconData _getWeatherIcon() {
    switch (condition.toLowerCase()) {
      case 'rain':
        return Icons.grain;
      case 'clouds':
        return Icons.cloud;
      case 'clear':
        return Icons.wb_sunny;
      default:
        return Icons.wb_cloudy;
    }
  }

  Color _getWeatherColor() {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Colors.orangeAccent;
      case 'clouds':
        return Colors.white70;
      case 'rain':
        return Colors.blueAccent;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherColor = _getWeatherColor();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),

              borderRadius: BorderRadius.circular(24),

              border: Border.all(color: Colors.white.withOpacity(0.15)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  TOP
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(_getWeatherIcon(), color: weatherColor, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          "${temp.toStringAsFixed(0)}°",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          cityName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          condition,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // DETAILS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Humidity: $humidity%",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    Text(
                      "Wind: ${wind.toStringAsFixed(1)} km/h",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Divider(color: Colors.white.withOpacity(0.2)),

                const SizedBox(height: 12),

                /// HOURLY
                SizedBox(
                  height: 75,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hourly.length,
                    itemBuilder: (context, index) {
                      final item = hourly[index];

                      return Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.time,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Icon(
                              Icons.water_drop,
                              color: item.precipitation > 50
                                  ? Colors.blueAccent
                                  : Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${item.precipitation}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
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
