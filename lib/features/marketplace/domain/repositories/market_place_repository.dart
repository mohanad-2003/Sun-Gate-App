import 'package:sun_gate_app/features/marketplace/data/dto/create_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';

abstract class MarketPlaceRepository {
  Future<List<CompanyEntity>> getCompanies();

  Future<CompanyEntity?> getMyCompany();

  Future<CompanyEntity> createCompany(CreateCompanyRequestDto request);

  Future<CompanyEntity> updateCompany({
    required String companyId,
    required UpdateCompanyRequestDto request,
  });

  Future<CompanyEntity> uploadCompanyLogo({
    required String companyId,
    required String filePath,
  });
}
