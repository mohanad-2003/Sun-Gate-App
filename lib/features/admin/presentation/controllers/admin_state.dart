import 'package:sun_gate_app/features/admin/domain/entities/admin_account_entity.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_article_entity.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_company_request_entity.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_dashboard_stats_entity.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';

class AdminState {
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;
  final AdminDashboardStatsEntity stats;
  final List<AdminCompanyRequestEntity> companyRequests;
  final List<AdminAccountEntity> accounts;
  final List<ProductEntity> products;
  final List<AdminArticleEntity> articles;

  const AdminState({
    required this.isLoading,
    required this.isSaving,
    this.errorMessage,
    this.successMessage,
    required this.stats,
    required this.companyRequests,
    required this.accounts,
    required this.products,
    required this.articles,
  });

  factory AdminState.initial() {
    return const AdminState(
      isLoading: false,
      isSaving: false,
      stats: AdminDashboardStatsEntity.empty,
      companyRequests: [],
      accounts: [],
      products: [],
      articles: [],
    );
  }

  AdminState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
    AdminDashboardStatsEntity? stats,
    List<AdminCompanyRequestEntity>? companyRequests,
    List<AdminAccountEntity>? accounts,
    List<ProductEntity>? products,
    List<AdminArticleEntity>? articles,
    bool clearMessages = false,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
      successMessage:
          clearMessages ? null : successMessage ?? this.successMessage,
      stats: stats ?? this.stats,
      companyRequests: companyRequests ?? this.companyRequests,
      accounts: accounts ?? this.accounts,
      products: products ?? this.products,
      articles: articles ?? this.articles,
    );
  }
}
