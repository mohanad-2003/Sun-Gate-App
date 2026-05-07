import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/core/network/dio_provider.dart';
import 'package:sun_gate_app/features/marketplace/data/datasource/market_place_remote_datasource.dart';
import 'package:sun_gate_app/features/marketplace/data/repositories/market_place_repository_imp.dart';
import 'package:sun_gate_app/features/marketplace/domain/repositories/market_place_repository.dart';

final marketPlaceRemoteDataSourceProvider =
    Provider<MarketPlaceRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return MarketPlaceRemoteDataSource(dio);
});

final marketPlaceRepositoryProvider = Provider<MarketPlaceRepository>((ref) {
  final remoteDataSource = ref.read(marketPlaceRemoteDataSourceProvider);

  return MarketPlaceRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );
});