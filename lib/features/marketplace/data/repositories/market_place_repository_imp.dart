import 'package:sun_gate_app/features/marketplace/data/datasource/market_place_remote_datasource.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';
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
}