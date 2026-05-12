import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/core/network/dio_provider.dart' as core_dio;
import 'package:sun_gate_app/features/marketplace/data/datasource/market_place_remote_datasource.dart';
import 'package:sun_gate_app/features/marketplace/data/repositories/market_place_repository_imp.dart';
import 'package:sun_gate_app/features/marketplace/domain/repositories/market_place_repository.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_state.dart';

/// Remote Data Source
final marketPlaceRemoteDataSourceProvider =
    Provider<MarketPlaceRemoteDataSource>((ref) {
      return MarketPlaceRemoteDataSource(ref.read(core_dio.dioProvider));
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
