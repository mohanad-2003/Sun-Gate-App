import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/core/services/location_service.dart';
import 'package:sun_gate_app/features/home/data/datasources/weathe_remote_data_souerce.dart';
import 'package:sun_gate_app/features/home/data/models/weather_model.dart';

final weatherProvider =
    StateNotifierProvider<WeatherNotifier, AsyncValue<WeatherModel>>((ref) {
      return WeatherNotifier();
    });

class WeatherNotifier extends StateNotifier<AsyncValue<WeatherModel>> {
  WeatherNotifier() : super(const AsyncLoading());

  Timer? _timer;

  Future<void> fetchWeather(String lang) async {
    try {
      final position = await LocationService.getLocation();

      final service = WeatherRemoteDataSource(Dio());

      final data = await service.getWeather(
        position.latitude,
        position.longitude,
        lang,
      );

      state = AsyncData(data);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void startAutoRefresh(String lang) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(minutes: 10), (_) {
      fetchWeather(lang);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
