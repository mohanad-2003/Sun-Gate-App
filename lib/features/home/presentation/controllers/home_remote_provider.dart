import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/core/network/dio_provider.dart';
import 'package:sun_gate_app/features/home/data/datasources/home_remote_data_source.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return HomeRemoteDataSource(dio);
});