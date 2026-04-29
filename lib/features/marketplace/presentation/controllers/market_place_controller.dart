import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_reservation_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_reservation_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/domain/repositories/market_place_repository.dart';
import 'package:sun_gate_app/features/marketplace/presentation/provider/market_place_provider.dart';
import 'market_place_state.dart';

class MarketPlaceController extends StateNotifier<MarketPlaceState> {
  final MarketPlaceRepository repository;

  MarketPlaceController({required this.repository})
    : super(MarketPlaceState.initial());
  final marketPlaceControllerProvider =
      StateNotifierProvider<MarketPlaceController, MarketPlaceState>((ref) {
        final repository = ref.read(marketPlaceRepositoryProvider);
        return MarketPlaceController(repository: repository);
      });
  // ================== Companies ==================

  Future<void> getCompanies() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

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
    state = state.copyWith(isLoading: true, errorMessage: null);

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

  // ================== Engineers ==================

  Future<void> loadEngineers({String? companyId}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

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

  // ================== Products ==================

  Future<void> getProducts() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

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

  // ================== Reservations ==================

  Future<void> createReservation({
    required String productId,
    required String expiresAt,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await repository.createReservation(
        CreateReservationRequestDto(productId: productId, expiresAt: expiresAt),
      );

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Reservation created successfully',
      );

      await getMyReservations();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> getMyReservations() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final reservations = await repository.getMyReservations();

      state = state.copyWith(isLoading: false, myReservations: reservations);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> getSellerReservations() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final reservations = await repository.getSellerReservations();

      state = state.copyWith(
        isLoading: false,
        sellerReservations: reservations,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> updateReservation({
    required String reservationId,
    required String status,
    required String finalDecision,
  }) async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      await repository.updateReservation(
        reservationId: reservationId,
        request: UpdateReservationRequestDto(
          status: status,
          finalDecision: finalDecision,
        ),
      );

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Reservation updated successfully',
      );

      await getSellerReservations();
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}
