import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/engineer_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/reservation_entity.dart';

class MarketPlaceState {
  static const _undefined = Object();

  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  final List<CompanyEntity> companies;
  final CompanyEntity? myCompany;

  final List<EngineerEntity> engineers;
  final EngineerEntity? myEngineer;
  final List<ProductEntity> products;
  final Set<String> ownedProductKeys;
  final List<ReservationEntity> myReservations;
  final List<ReservationEntity> sellerReservations;
  const MarketPlaceState({
    required this.isLoading,
    required this.isSaving,
    required this.errorMessage,
    required this.successMessage,
    required this.companies,
    required this.myCompany,
    required this.engineers,
    required this.myEngineer,
    required this.products,
    required this.ownedProductKeys,
    required this.myReservations,
    required this.sellerReservations,
  });

  factory MarketPlaceState.initial() {
    return const MarketPlaceState(
      isLoading: false,
      isSaving: false,
      errorMessage: null,
      successMessage: null,
      companies: [],
      myCompany: null,
      engineers: [],
      myEngineer: null,
      products: [],
      ownedProductKeys: {},
      myReservations: [],
      sellerReservations: [],
    );
  }

  /// First non-empty WhatsApp from linked engineers, else [company.engineerNumber].
  String engineerWhatsappFor(CompanyEntity? company) {
    final fromEngineers = engineers
        .map((engineer) => engineer.phoneWhatsapp?.trim() ?? '')
        .firstWhere((phone) => phone.isNotEmpty, orElse: () => '');
    if (fromEngineers.isNotEmpty) return fromEngineers;
    return company?.engineerNumber?.trim() ?? '';
  }

  MarketPlaceState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
    List<CompanyEntity>? companies,
    Object? myCompany = _undefined,
    List<EngineerEntity>? engineers,
    EngineerEntity? myEngineer,
    List<ProductEntity>? products,
    Set<String>? ownedProductKeys,
    List<ReservationEntity>? myReservations,
    List<ReservationEntity>? sellerReservations,
  }) {
    return MarketPlaceState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      successMessage: successMessage,
      companies: companies ?? this.companies,
      myCompany: myCompany == _undefined
          ? this.myCompany
          : myCompany as CompanyEntity?,
      engineers: engineers ?? this.engineers,
      myEngineer: myEngineer ?? this.myEngineer,
      products: products ?? this.products,
      ownedProductKeys: ownedProductKeys ?? this.ownedProductKeys,
      myReservations: myReservations ?? this.myReservations,
      sellerReservations: sellerReservations ?? this.sellerReservations,
    );
  }
}
