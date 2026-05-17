import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_engineer_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/create_reservation_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_company_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_engineer_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/dto/update_reservation_request_dto.dart';
import 'package:sun_gate_app/features/marketplace/data/models/company_model.dart';
import 'package:sun_gate_app/features/marketplace/data/models/engineer_model.dart';
import 'package:sun_gate_app/features/marketplace/data/models/product_model.dart';
import 'package:sun_gate_app/features/marketplace/data/models/reservation_model.dart';

class MarketPlaceRemoteDataSource {
  final Dio dio;

  MarketPlaceRemoteDataSource(this.dio);

  List<Map<String, dynamic>> _extractDocs(dynamic responseData) {
    final root = responseData is Map<String, dynamic>
        ? responseData
        : <String, dynamic>{};
    final data = root['data'];

    dynamic docs;

    if (data is Map<String, dynamic>) {
      docs =
          data['docs'] ??
          data['items'] ??
          data['products'] ??
          data['results'] ??
          data['rows'];
    } else if (data is List) {
      docs = data;
    }

    docs ??=
        root['docs'] ??
        root['items'] ??
        root['products'] ??
        root['results'] ??
        root['rows'];

    if (docs is! List) return const [];

    return docs
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<List<CompanyModel>> getCompanies() async {
    final response = await dio.get(ApiConstants.companies);
    debugPrint('COMPANIES RESPONSE: ${response.data}');
    final docs = _extractDocs(response.data);

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

  Future<List<EngineerModel>> getEngineers({
    int page = 1,
    int limit = 10,
    String? companyId,
  }) async {
    final endpoint = companyId != null && companyId.isNotEmpty
        ? ApiConstants.companyEngineers(companyId)
        : ApiConstants.engineers;
    final response = await dio.get(
      endpoint,
      queryParameters: {
        if (companyId == null || companyId.isEmpty) 'page': page,
        if (companyId == null || companyId.isEmpty) 'limit': limit,
      },
    );

    print('ENGINEERS RESPONSE: ${response.data}');

    final docs = _extractDocs(response.data);

    return docs.map((e) => EngineerModel.fromJson(e)).toList();
  }

  Future<EngineerModel?> getMyEngineer() async {
    final response = await dio.get(ApiConstants.myEngineer);

    final data = response.data['data'];
    if (data == null) return null;

    return EngineerModel.fromJson(data as Map<String, dynamic>);
  }

  Future<EngineerModel> createEngineer(CreateEngineerRequestDto request) async {
    final response = await dio.post(
      ApiConstants.engineers,
      data: request.toJson(),
    );

    return EngineerModel.fromJson(response.data['data']);
  }

  Future<EngineerModel> updateEngineer(UpdateEngineerRequestDto request) async {
    final response = await dio.patch(
      ApiConstants.myEngineer,
      data: request.toJson(),
    );

    return EngineerModel.fromJson(response.data['data']);
  }

  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 12,
    String? category,
    String? status,
  }) async {
    final response = await dio.get(
      ApiConstants.products,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (category != null && category.isNotEmpty) 'category': category,
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );

    debugPrint('PRODUCTS RESPONSE: ${response.data}');

    final docs = _extractDocs(response.data);

    return docs.map((e) => ProductModel.fromJson(e)).toList();
  }

  Future<ProductModel> getProductById(String productId) async {
    final response = await dio.get(ApiConstants.productById(productId));

    return ProductModel.fromJson(response.data['data']);
  }

  Future<ProductModel> createProduct(FormData formData) async {
    final response = await dio.post(
      ApiConstants.products,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return ProductModel.fromJson(response.data['data']);
  }

  Future<ProductModel> updateProduct({
    required String productId,
    required FormData formData,
  }) async {
    final response = await dio.patch(
      ApiConstants.productById(productId),
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return ProductModel.fromJson(response.data['data']);
  }

  Future<void> deleteProduct(String productId) async {
    await dio.delete(ApiConstants.productById(productId));
  }

  Future<ReservationModel> createReservation(
    CreateReservationRequestDto request,
  ) async {
    final response = await dio.post(
      ApiConstants.reservations,
      data: request.toJson(),
    );

    return ReservationModel.fromJson(response.data['data']);
  }

  Future<List<ReservationModel>> getMyReservations({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dio.get(
      ApiConstants.getMyReservations,
      queryParameters: {'page': page, 'limit': limit},
    );

    final docs = _extractDocs(response.data);

    return docs.map((e) => ReservationModel.fromJson(e)).toList();
  }

  Future<List<ReservationModel>> getSellerReservations({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await dio.get(
      ApiConstants.sellerReservations,
      queryParameters: {'page': page, 'limit': limit},
    );

    final docs = _extractDocs(response.data);

    return docs.map((e) => ReservationModel.fromJson(e)).toList();
  }

  Future<ReservationModel> updateReservation({
    required String reservationId,
    required UpdateReservationRequestDto request,
  }) async {
    final response = await dio.patch(
      ApiConstants.updateReservations(reservationId),
      data: request.toJson(),
    );

    return ReservationModel.fromJson(response.data['data']);
  }
}
