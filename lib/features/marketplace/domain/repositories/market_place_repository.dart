import 'package:dio/dio.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_reservation_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_reservation_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/engineer_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/reservation_entity.dart';

abstract class MarketPlaceRepository {
  Future<List<CompanyEntity>> getCompanies();

  Future<CompanyEntity?> getMyCompany();

  Future<CompanyEntity> createCompany(CreateCompanyRequestDto request);

  Future<List<EngineerEntity>> getEngineers({String? companyId});
  Future<EngineerEntity?> getMyEngineer();
  Future<List<ProductEntity>> getProducts({String? status});
  Future<ProductEntity> getProductById(String productId);
  Future<ProductEntity> createProduct(FormData formData);
  Future<EngineerEntity> createEngineer({
    required String companyId,
    required int yearsOfExperience,
    required String certificate,
  });

  Future<EngineerEntity> updateEngineer({
    required int yearOfExperience,
    required String certificate,
    required double rating,
  });

  Future<CompanyEntity> updateCompany({
    required String companyId,
    required UpdateCompanyRequestDto request,
  });

  Future<CompanyEntity> uploadCompanyLogo({
    required String companyId,
    required String filePath,
  });
  Future<ProductEntity> updateProduct({
    required String productId,
    required FormData formData,
  });
  Future<void> deleteProduct(String productId);
  Future<ReservationEntity> createReservation(
    CreateReservationRequestDto request,
  );

  Future<List<ReservationEntity>> getMyReservations();

  Future<List<ReservationEntity>> getSellerReservations();

  Future<ReservationEntity> updateReservation({
    required String reservationId,
    required UpdateReservationRequestDto request,
  });
}
