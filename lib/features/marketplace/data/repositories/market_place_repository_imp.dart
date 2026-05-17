import 'package:dio/dio.dart';
import 'package:sun_gate_app/features/marketplace/data/datasource/market_place_remote_datasource.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_engineer_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_reservation_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_engineer_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_reservation_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/engineer_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/reservation_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/repositories/market_place_repository.dart';

class MarketPlaceRepositoryImpl implements MarketPlaceRepository {
  final MarketPlaceRemoteDataSource remoteDataSource;

  MarketPlaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CompanyEntity>> getCompanies() {
    return remoteDataSource.getCompanies();
  }

  @override
  Future<CompanyEntity?> getMyCompany() {
    return remoteDataSource.getMyCompany();
  }

  @override
  Future<CompanyEntity> createCompany(CreateCompanyRequestDto request) {
    return remoteDataSource.createCompany(request);
  }

  @override
  Future<CompanyEntity> updateCompany({
    required String companyId,
    required UpdateCompanyRequestDto request,
  }) {
    return remoteDataSource.updateCompany(
      companyId: companyId,
      request: request,
    );
  }

  @override
  Future<CompanyEntity> uploadCompanyLogo({
    required String companyId,
    required String filePath,
  }) {
    return remoteDataSource.uploadCompanyLogo(
      companyId: companyId,
      filePath: filePath,
    );
  }

  @override
  Future<List<EngineerEntity>> getEngineers({String? companyId}) {
    return remoteDataSource.getEngineers(companyId: companyId);
  }

  @override
  Future<EngineerEntity?> getMyEngineer() {
    return remoteDataSource.getMyEngineer();
  }

  @override
  Future<EngineerEntity> createEngineer({
    required String companyId,
    required int yearsOfExperience,
    required String certificate,
  }) {
    final request = CreateEngineerRequestDto(
      companyId: companyId,
      yearsOfExperience: yearsOfExperience,
      certificate: certificate,
    );

    return remoteDataSource.createEngineer(request);
  }

  @override
  Future<EngineerEntity> updateEngineer({
    required int yearOfExperience,
    required String certificate,
    required double rating,
  }) {
    final request = UpdateEngineerRequestDto(
      yearsOfExperience: yearOfExperience,
      certificate: certificate,
      rating: rating,
    );

    return remoteDataSource.updateEngineer(request);
  }

  @override
  Future<List<ProductEntity>> getProducts({String? status}) {
    return remoteDataSource.getProducts(status: status).then(
      (value) => value.cast<ProductEntity>(),
    );
  }

  @override
  Future<ProductEntity> getProductById(String productId) {
    return remoteDataSource
        .getProductById(productId)
        .then((value) => value as ProductEntity);
  }

  @override
  Future<ProductEntity> createProduct(FormData formData) {
    return remoteDataSource
        .createProduct(formData)
        .then((value) => value as ProductEntity);
  }

  @override
  Future<ProductEntity> updateProduct({
    required String productId,
    required FormData formData,
  }) {
    return remoteDataSource
        .updateProduct(productId: productId, formData: formData)
        .then((value) => value as ProductEntity);
  }

  @override
  Future<void> deleteProduct(String productId) {
    return remoteDataSource.deleteProduct(productId);
  }

  @override
  Future<ReservationEntity> createReservation(
    CreateReservationRequestDto request,
  ) {
    return remoteDataSource.createReservation(request);
  }

  @override
  Future<List<ReservationEntity>> getMyReservations() {
    return remoteDataSource.getMyReservations();
  }

  @override
  Future<List<ReservationEntity>> getSellerReservations() {
    return remoteDataSource.getSellerReservations();
  }

  @override
  Future<ReservationEntity> updateReservation({
    required String reservationId,
    required UpdateReservationRequestDto request,
  }) {
    return remoteDataSource.updateReservation(
      reservationId: reservationId,
      request: request,
    );
  }
}
