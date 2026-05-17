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
    final merged = <String, AdminAccountModel>{};

    try {
      final users = await _fetchAllAdminUserAccounts(limit: safeLimit);
      for (final account in users) {
        merged[account.id] = account;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode != 404 && e.response?.statusCode != 405) {
        // Keep going — engineers/companies may still be available.
      }
    }

    await _mergeEngineerAccounts(merged, limit: safeLimit);
    await _mergeCompanyAccounts(merged);

    if (merged.isEmpty) {
      throw Exception('No accounts found');
    }

    return merged.values.toList()
      ..sort((a, b) => a.fullName.compareTo(b.fullName));
  }

  Future<List<AdminAccountModel>> _fetchAllAdminUserAccounts({
    int limit = 50,
  }) async {
    final safeLimit = _safeLimit(limit);
    final accounts = <AdminAccountModel>[];
    var page = 1;
    var hasNext = true;

    while (hasNext && page <= 20) {
      final response = await dio.get(
        ApiConstants.adminAccounts,
        queryParameters: {'page': page, 'limit': safeLimit},
      );
      final docs = _extractDocs(response.data);
      accounts.addAll(docs.map(AdminAccountModel.fromJson));

      final data = response.data is Map<String, dynamic>
          ? response.data['data']
          : null;
      if (data is Map<String, dynamic>) {
        hasNext = data['hasNextPage'] == true;
      } else {
        hasNext = docs.length >= safeLimit;
      }
      page++;
    }

    return accounts;
  }

  Future<void> _mergeEngineerAccounts(
    Map<String, AdminAccountModel> merged, {
    int limit = 50,
  }) async {
    final safeLimit = _safeLimit(limit);

    try {
      final response = await dio.get(
        ApiConstants.engineers,
        queryParameters: {'page': 1, 'limit': safeLimit},
      );
      for (final doc in _extractDocs(response.data)) {
        final userId = doc['userId']?.toString() ?? '';
        if (userId.isEmpty) continue;

        final user = doc['user'];
        final userMap = user is Map<String, dynamic>
            ? user
            : user is Map
            ? Map<String, dynamic>.from(user)
            : doc;

        merged[userId] = AdminAccountModel.fromJson({
          ...userMap,
          '_id': userId,
          'role': userMap['role']?.toString() ?? 'engineer',
          'phoneWhatsapp':
              doc['phoneWhatsapp']?.toString() ??
              userMap['phoneWhatsapp']?.toString(),
          'accountStatus':
              userMap['accountStatus']?.toString() ?? 'active',
        });
      }
    } catch (_) {}
  }

  Future<void> _mergeCompanyAccounts(Map<String, AdminAccountModel> merged) async {
    try {
      final requests = await getCompanyRequests(limit: 100);
      for (final request in requests) {
        final userId = request.userId?.trim() ?? '';
        if (userId.isEmpty) continue;

        final status = request.isActive
            ? 'active'
            : request.isRejected
            ? 'suspended'
            : 'pending';

        merged[userId] = AdminAccountModel(
          id: userId,
          fullName: request.ownerName.isNotEmpty
              ? request.ownerName
              : request.companyName,
          email: request.email,
          role: 'company',
          accountStatus: status,
          phoneWhatsapp: request.phone.isNotEmpty ? request.phone : null,
          location: request.location.isNotEmpty ? request.location : null,
        );
      }
    } catch (_) {}

    try {
      final response = await dio.get(
        ApiConstants.companies,
        queryParameters: {'page': 1, 'limit': 50},
      );
      for (final doc in _extractDocs(response.data)) {
        final userId = doc['userId']?.toString() ?? '';
        if (userId.isEmpty || merged.containsKey(userId)) continue;

        merged[userId] = AdminAccountModel.fromJson({
          ...doc,
          '_id': userId,
          'role': 'company',
          'fullName':
              doc['ownerName']?.toString() ??
              doc['companyName']?.toString() ??
              'Company',
          'email': doc['email']?.toString() ?? '',
          'accountStatus': doc['status']?.toString() ?? 'active',
        });
      }
    } catch (_) {}
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
