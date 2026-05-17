import 'package:sun_gate_app/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:sun_gate_app/features/admin/data/dto/confirm_company_payment_dto.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_account_entity.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_article_entity.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_company_request_entity.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_dashboard_stats_entity.dart';
import 'package:sun_gate_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AdminDashboardStatsEntity> getDashboardStats() async {
    var requests = const <AdminCompanyRequestEntity>[];
    var accounts = const <AdminAccountEntity>[];
    var companiesCount = 0;
    var productsCount = 0;
    var engineersCount = 0;

    try {
      requests = await remoteDataSource.getCompanyRequests();
    } catch (_) {}

    try {
      accounts = await remoteDataSource.getAccounts(limit: 50);
    } catch (_) {}

    try {
      companiesCount = await remoteDataSource.countCompanies();
    } catch (_) {}

    try {
      productsCount = await remoteDataSource.countProducts();
    } catch (_) {}

    try {
      engineersCount = await remoteDataSource.countEngineers();
    } catch (_) {}

    final usersCount = accounts
        .where((account) => account.role.toLowerCase() == 'user')
        .length;

    return AdminDashboardStatsEntity(
      usersCount: usersCount > 0 ? usersCount : accounts.length,
      companiesCount: companiesCount > 0
          ? companiesCount
          : accounts.where((a) => a.role.toLowerCase() == 'company').length,
      productsCount: productsCount,
      pendingRequestsCount: requests.where((r) => r.isPending).length,
      engineersCount: engineersCount > 0
          ? engineersCount
          : accounts.where((a) => a.role.toLowerCase() == 'engineer').length,
    );
  }

  @override
  Future<List<AdminCompanyRequestEntity>> getCompanyRequests() {
    return remoteDataSource.getCompanyRequests();
  }

  @override
  Future<void> confirmCompanyPayment({
    required String requestId,
    required String plan,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return remoteDataSource.confirmCompanyPayment(
      requestId: requestId,
      request: ConfirmCompanyPaymentDto(
        plan: plan,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  Future<void> rejectCompanyRequest(String requestId) {
    return remoteDataSource.rejectCompanyRequest(requestId);
  }

  @override
  Future<List<AdminAccountEntity>> getAccounts({int page = 1, int limit = 50}) {
    return remoteDataSource.getAccounts(page: page, limit: limit);
  }

  @override
  Future<void> activateAccount(String userId) {
    return remoteDataSource.activateAccount(userId);
  }

  @override
  Future<void> suspendAccount(String userId) {
    return remoteDataSource.suspendAccount(userId);
  }

  @override
  Future<void> deleteAccount(String userId) {
    return remoteDataSource.deleteAccount(userId);
  }

  @override
  Future<List<ProductEntity>> getProducts({int page = 1, int limit = 50}) {
    return remoteDataSource.getProducts(page: page, limit: limit);
  }

  @override
  Future<void> deleteProduct(String productId) {
    return remoteDataSource.deleteProduct(productId);
  }

  @override
  Future<List<AdminArticleEntity>> getArticles({int page = 1, int limit = 50}) {
    return remoteDataSource.getArticles(page: page, limit: limit);
  }

  @override
  Future<AdminArticleEntity> createArticle({
    required String title,
    required String body,
  }) {
    return remoteDataSource.createArticle(title: title, body: body);
  }

  @override
  Future<AdminArticleEntity> updateArticle({
    required String articleId,
    required String title,
    required String body,
  }) {
    return remoteDataSource.updateArticle(
      articleId: articleId,
      title: title,
      body: body,
    );
  }

  @override
  Future<void> deleteArticle(String articleId) {
    return remoteDataSource.deleteArticle(articleId);
  }
}
