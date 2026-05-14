import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';
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

  Future<CompanyEntity?> getMyCompany() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final company = await repository.getMyCompany();
      state = state.copyWith(isLoading: false, myCompany: company);
      return company;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        myCompany: null,
        errorMessage: null,
      );
      return null;
    }
  }

  Future<void> getEngineers({String? companyId}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final engineers = await repository.getEngineers(companyId: companyId);
      state = state.copyWith(isLoading: false, engineers: engineers);
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

      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> updateCompany(UpdateCompanyRequestDto request) async {
    if (state.myCompany == null) return false;

    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final updatedCompany = await repository.updateCompany(
        companyId: state.myCompany!.id,
        request: request,
      );
      state = state.copyWith(
        isSaving: false,
        myCompany: updatedCompany,
        successMessage: 'Company updated successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<bool> createProduct(FormData formData) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      await repository.createProduct(formData);
      await getProducts();
      state = state.copyWith(
        isSaving: false,
        successMessage: 'Product created successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}
