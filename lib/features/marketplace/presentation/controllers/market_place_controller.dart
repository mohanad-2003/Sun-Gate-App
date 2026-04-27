import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/core/network/dio_provider.dart';
import 'package:sun_gate_app/features/marketplace/data/datasource/market_place_remote_datasource.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/repositories/market_place_repository_imp.dart';
import 'package:sun_gate_app/features/marketplace/domain/repositories/market_place_repository.dart';
import 'market_place_state.dart';

final marketPlaceRemoteProvider = Provider<MarketPlaceRemoteDataSource>((ref) {
  return MarketPlaceRemoteDataSource(ref.read(dioProvider));
});

final marketPlaceRepositoryProvider = Provider<MarketPlaceRepository>((ref) {
  return MarketPlaceRepositoryImpl(
    remoteDataSource: ref.read(marketPlaceRemoteProvider),
  );
});

final marketPlaceControllerProvider =
    StateNotifierProvider<MarketPlaceController, MarketPlaceState>((ref) {
  return MarketPlaceController(
    repository: ref.read(marketPlaceRepositoryProvider),
  );
});

class MarketPlaceController extends StateNotifier<MarketPlaceState> {
  final MarketPlaceRepository repository;

  MarketPlaceController({required this.repository})
      : super(MarketPlaceState.initial());

  Future<void> getCompanies() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final companies = await repository.getCompanies();

      state = state.copyWith(
        isLoading: false,
        companies: companies,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> getMyCompany() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final company = await repository.getMyCompany();

      state = state.copyWith(
        isLoading: false,
        myCompany: company,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> createCompany({
    required String ownerName,
    required String address,
    required String phone,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final company = await repository.createCompany(
        CreateCompanyRequestDto(
          ownerName: ownerName,
          address: address,
          phone: phone,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        myCompany: company,
        successMessage: 'Company created successfully',
      );

      await getCompanies();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> updateCompany({
    required String companyId,
    String? ownerName,
    String? address,
    String? phone,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final company = await repository.updateCompany(
        companyId: companyId,
        request: UpdateCompanyRequestDto(
          ownerName: ownerName,
          address: address,
          phone: phone,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        myCompany: company,
        successMessage: 'Company updated successfully',
      );

      await getCompanies();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> uploadCompanyLogo({
    required String companyId,
    required String filePath,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final company = await repository.uploadCompanyLogo(
        companyId: companyId,
        filePath: filePath,
      );

      state = state.copyWith(
        isSaving: false,
        myCompany: company,
        successMessage: 'Company logo updated successfully',
      );

      await getCompanies();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}