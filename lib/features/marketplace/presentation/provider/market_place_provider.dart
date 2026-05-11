import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import 'package:sun_gate_app/features/marketplace/data/datasource/market_place_remote_datasource.dart';
import 'package:sun_gate_app/features/marketplace/data/repositories/market_place_repository_imp.dart';
import 'package:sun_gate_app/features/marketplace/domain/repositories/market_place_repository.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:dio/dio.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_state.dart';

/// Dio
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
});

/// Remote Data Source
final marketPlaceRemoteDataSourceProvider =
    Provider<MarketPlaceRemoteDataSource>((ref) {
      return MarketPlaceRemoteDataSource(ref.read(dioProvider));
    });

/// Repository
final marketPlaceRepositoryProvider = Provider<MarketPlaceRepository>((ref) {
  return MarketPlaceRepositoryImpl(
    remoteDataSource: ref.read(marketPlaceRemoteDataSourceProvider),
  );
});

/// Controller
final marketPlaceControllerProvider =
    StateNotifierProvider<MarketPlaceController, MarketPlaceState>((ref) {
      return MarketPlaceController(
        repository: ref.read(marketPlaceRepositoryProvider),
      );
    });
