import 'package:dio/dio.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import 'package:sun_gate_app/features/admin/data/dto/confirm_company_payment_dto.dart';
import 'package:sun_gate_app/features/admin/data/dto/reject_company_request_dto.dart';
import 'package:sun_gate_app/features/admin/data/models/admin_account_model.dart';
import 'package:sun_gate_app/features/admin/data/models/admin_article_model.dart';
import 'package:sun_gate_app/features/admin/data/models/admin_company_request_model.dart';
import 'package:sun_gate_app/features/marketplace/data/models/product_model.dart';

class AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSource(this.dio);

  static const int _maxPageLimit = 50;
  static const int _maxCompanyRequestsLimit = 100;

  int _safeLimit(int limit) => limit.clamp(1, _maxPageLimit);

  int _safeCompanyRequestsLimit(int limit) =>
      limit.clamp(1, _maxCompanyRequestsLimit);

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
          data['requests'] ??
          data['users'] ??
          data['accounts'] ??
          data['results'] ??
          data['rows'];
    } else if (data is List) {
      docs = data;
    }

    docs ??=
        root['docs'] ??
        root['items'] ??
        root['requests'] ??
        root['users'] ??
        root['results'] ??
        root['rows'];

    if (docs is! List) return const [];

    return docs
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  String _errorMessage(DioException error, String fallback) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? fallback;
    }
    return fallback;
  }

  Future<List<AdminCompanyRequestModel>> getCompanyRequests({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.adminCompanyRequests,
        queryParameters: {
          'page': page,
          'limit': _safeCompanyRequestsLimit(limit),
          if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
        },
      );
      return _extractDocs(response.data)
          .map(AdminCompanyRequestModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to load company requests'));
    }
  }

  Future<AdminCompanyRequestModel> approveCompanyRequest(String requestId) async {
    try {
      final response = await dio.patch(
        ApiConstants.adminApproveCompanyRequest(requestId),
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return AdminCompanyRequestModel.fromJson(data);
      }
      throw Exception('Invalid approve response');
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to approve company request'));
    }
  }

  Future<AdminCompanyRequestModel> confirmCompanyPayment({
    required String requestId,
    required ConfirmCompanyPaymentDto request,
  }) async {
    try {
      final response = await dio.patch(
        ApiConstants.adminConfirmCompanyPayment(requestId),
        data: request.toJson(),
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return AdminCompanyRequestModel.fromJson(data);
      }
      throw Exception('Invalid confirm-payment response');
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to confirm payment'));
    }
  }

  Future<AdminCompanyRequestModel> rejectCompanyRequest({
    required String requestId,
    RejectCompanyRequestDto request = const RejectCompanyRequestDto(),
  }) async {
    try {
      final response = await dio.patch(
        ApiConstants.adminRejectCompanyRequest(requestId),
        data: request.toJson(),
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return AdminCompanyRequestModel.fromJson(data);
      }
      throw Exception('Invalid reject response');
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to reject company request'));
    }
  }

  Future<List<AdminAccountModel>> getAccounts({
    int page = 1,
    int limit = 50,
  }) async {
    final safeLimit = _safeLimit(limit);
    try {
      final response = await dio.get(
        ApiConstants.adminUsers,
        queryParameters: {'page': page, 'limit': safeLimit},
      );
      final accounts = _extractDocs(response.data)
          .map(AdminAccountModel.fromJson)
          .toList();
      if (accounts.isNotEmpty) return accounts;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != null && status != 404 && status != 405) {
        throw Exception(_errorMessage(e, 'Failed to load accounts'));
      }
    }

    return _loadAccountsFromAvailableSources(limit: safeLimit);
  }

  /// Backend exposes account actions per userId only — not a list endpoint.
  /// Build the admin user list from engineers + pending company requests.
  Future<List<AdminAccountModel>> _loadAccountsFromAvailableSources({
    int limit = 50,
  }) async {
    final safeLimit = _safeLimit(limit);
    final accounts = <AdminAccountModel>[];
    final seenIds = <String>{};

    try {
      final response = await dio.get(
        ApiConstants.engineers,
        queryParameters: {'page': 1, 'limit': safeLimit},
      );
      for (final doc in _extractDocs(response.data)) {
        final userId = doc['userId']?.toString() ?? '';
        if (userId.isEmpty || !seenIds.add(userId)) continue;

        final user = doc['user'];
        final userMap = user is Map<String, dynamic> ? user : doc;

        accounts.add(
          AdminAccountModel.fromJson({
            ...userMap,
            '_id': userId,
            'role': userMap['role']?.toString() ?? 'engineer',
            'phoneWhatsapp':
                doc['phoneWhatsapp']?.toString() ??
                userMap['phoneWhatsapp']?.toString(),
          }),
        );
      }
    } catch (_) {}

    try {
      final requests = await getCompanyRequests();
      for (final request in requests) {
        final userId = request.userId?.trim() ?? '';
        if (userId.isEmpty || !seenIds.add(userId)) continue;

        accounts.add(
          AdminAccountModel(
            id: userId,
            fullName: request.ownerName.isNotEmpty
                ? request.ownerName
                : request.companyName,
            email: request.email,
            role: 'company',
            accountStatus: request.isActive
                ? 'active'
                : request.isRejected
                ? 'suspended'
                : 'suspended',
          ),
        );
      }
    } catch (_) {}

    return accounts;
  }

  Future<void> activateAccount(String userId) async {
    try {
      await dio.patch(ApiConstants.adminActivateAccount(userId));
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to activate account'));
    }
  }

  Future<void> suspendAccount(String userId) async {
    try {
      await dio.patch(ApiConstants.adminSuspendAccount(userId));
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to suspend account'));
    }
  }

  Future<void> deleteAccount(String userId) async {
    try {
      await dio.delete(ApiConstants.adminDeleteAccount(userId));
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to delete account'));
    }
  }

  Future<List<ProductModel>> getProducts({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.products,
        queryParameters: {'page': page, 'limit': _safeLimit(limit)},
      );
      return _extractDocs(response.data).map(ProductModel.fromJson).toList();
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to load products'));
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await dio.delete(ApiConstants.productById(productId));
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to delete product'));
    }
  }

  Future<List<AdminArticleModel>> getArticles({
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.articles,
        queryParameters: {'page': page, 'limit': _safeLimit(limit)},
      );
      return _extractDocs(response.data).map(AdminArticleModel.fromJson).toList();
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to load articles'));
    }
  }

  Future<AdminArticleModel> createArticle({
    required String title,
    required String body,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.articles,
        data: {
          'title': title,
          'data': {'body': body},
        },
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return AdminArticleModel.fromJson(data);
      }
      throw Exception('Invalid article response');
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to create article'));
    }
  }

  Future<AdminArticleModel> updateArticle({
    required String articleId,
    required String title,
    required String body,
  }) async {
    try {
      final response = await dio.patch(
        ApiConstants.articleById(articleId),
        data: {
          'title': title,
          'data': {'body': body},
        },
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return AdminArticleModel.fromJson(data);
      }
      throw Exception('Invalid article response');
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to update article'));
    }
  }

  Future<void> deleteArticle(String articleId) async {
    try {
      await dio.delete(ApiConstants.articleById(articleId));
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to delete article'));
    }
  }

  Future<int> countCompanies() async {
    final response = await dio.get(
      ApiConstants.companies,
      queryParameters: {'page': 1, 'limit': 1},
    );
    return _readTotal(response.data);
  }

  Future<int> countEngineers() async {
    final response = await dio.get(
      ApiConstants.engineers,
      queryParameters: {'page': 1, 'limit': 1},
    );
    return _readTotal(response.data);
  }

  Future<int> countProducts() async {
    final response = await dio.get(
      ApiConstants.products,
      queryParameters: {'page': 1, 'limit': 1},
    );
    return _readTotal(response.data);
  }

  int _readTotal(dynamic responseData) {
    final root = responseData is Map<String, dynamic>
        ? responseData
        : <String, dynamic>{};
    final data = root['data'];
    if (data is Map<String, dynamic>) {
      return (data['totalDocs'] as num?)?.toInt() ??
          (data['total'] as num?)?.toInt() ??
          (data['count'] as num?)?.toInt() ??
          _extractDocs(responseData).length;
    }
    return _extractDocs(responseData).length;
  }
}
