import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/features/marketplace/domain/repositories/market_place_repository.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_state.dart';
import 'package:sun_gate_app/features/marketplace/presentation/provider/market_place_provider.dart';

final marketPlaceControllerProvider =
    StateNotifierProvider<MarketPlaceController, MarketPlaceState>((ref) {
      final repository = ref.read(marketPlaceRepositoryProvider);

      return MarketPlaceController(repository: repository);
    });

class MarketPlaceController extends StateNotifier<MarketPlaceState> {
  final MarketPlaceRepository repository;

  MarketPlaceController({required this.repository})
    : super(MarketPlaceState.initial()) {
    getCompanies();
    getProducts();
  }

  Future<void> getCompanies() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final companies = await repository.getCompanies();

      state = state.copyWith(isLoading: false, companies: companies);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> getMyCompany() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final company = await repository.getMyCompany();

      state = state.copyWith(isLoading: false, myCompany: company);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> getProducts() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final products = await repository.getProducts();
      debugPrint('✅ PRODUCTS COUNT: ${products.length}'); // ← أضف هاي

      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      debugPrint('❌ PRODUCTS ERROR: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}
