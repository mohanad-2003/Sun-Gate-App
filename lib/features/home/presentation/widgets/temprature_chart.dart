import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/home/data/models/hourly_weather_model.dart';

class TemperatureChart extends StatelessWidget {
  final List<HourlyWeather> hourly;

  const TemperatureChart({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(hourly.length, (index) {
                return FlSpot(
                  index.toDouble(),
                  hourly[index].precipitation.toDouble(),
                );
              }),
              isCurved: true,
              color: Colors.orange,
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
