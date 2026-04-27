import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/models/company_model.dart';

class MarketPlaceRemoteDataSource {
  final Dio dio;

  MarketPlaceRemoteDataSource(this.dio);

  Future<List<CompanyModel>> getCompanies() async {
    final response = await dio.get(ApiConstants.companies);
    debugPrint('COMPANIES RESPONSE: ${response.data}');
    final data = response.data['data'];
    final List docs = data is Map<String, dynamic>
        ? data['docs'] ?? []
        : data ?? [];

    return docs.map((e) => CompanyModel.fromJson(e)).toList();
  }

  Future<CompanyModel?> getMyCompany() async {
    final response = await dio.get(ApiConstants.myCompany);

    final data = response.data['data'];

    if (data == null || data is! Map<String, dynamic>) return null;

    return CompanyModel.fromJson(data);
  }

  Future<CompanyModel> createCompany(CreateCompanyRequestDto request) async {
    final response = await dio.post(
      ApiConstants.companies,
      data: request.toJson(),
    );

    return CompanyModel.fromJson(response.data['data']);
  }

  Future<CompanyModel> updateCompany({
    required String companyId,
    required UpdateCompanyRequestDto request,
  }) async {
    final response = await dio.patch(
      ApiConstants.updateCompany(companyId),
      data: request.toJson(),
    );

    return CompanyModel.fromJson(response.data['data']);
  }

  Future<CompanyModel> uploadCompanyLogo({
    required String companyId,
    required String filePath,
  }) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });

    final response = await dio.post(
      ApiConstants.uploadCompanyLogo(companyId),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return CompanyModel.fromJson(response.data['data']);
  }
}
