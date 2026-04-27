import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';

class MarketPlaceState {
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;
  final List<CompanyEntity> companies;
  final CompanyEntity? myCompany;

  const MarketPlaceState({
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
    this.companies = const [],
    this.myCompany,
  });

  factory MarketPlaceState.initial() => const MarketPlaceState();

  MarketPlaceState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
    List<CompanyEntity>? companies,
    CompanyEntity? myCompany,
  }) {
    return MarketPlaceState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      successMessage: successMessage,
      companies: companies ?? this.companies,
      myCompany: myCompany ?? this.myCompany,
    );
  }
}