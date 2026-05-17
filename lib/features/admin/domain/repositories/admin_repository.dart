import 'package:sun_gate_app/features/admin/domain/entities/admin_account_entity.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_article_entity.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_company_request_entity.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_dashboard_stats_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';

abstract class AdminRepository {
  Future<AdminDashboardStatsEntity> getDashboardStats();
  Future<List<AdminCompanyRequestEntity>> getCompanyRequests();
  Future<void> confirmCompanyPayment({
    required String requestId,
    required String plan,
    required DateTime startDate,
    required DateTime endDate,
  });
  Future<void> rejectCompanyRequest(String requestId);
  Future<List<AdminAccountEntity>> getAccounts({int page = 1, int limit = 50});
  Future<void> activateAccount(String userId);
  Future<void> suspendAccount(String userId);
  Future<void> deleteAccount(String userId);
  Future<List<ProductEntity>> getProducts({int page = 1, int limit = 50});
  Future<void> deleteProduct(String productId);
  Future<List<AdminArticleEntity>> getArticles({int page = 1, int limit = 50});
  Future<AdminArticleEntity> createArticle({
    required String title,
    required String body,
  });
  Future<AdminArticleEntity> updateArticle({
    required String articleId,
    required String title,
    required String body,
  });
  Future<void> deleteArticle(String articleId);
}
