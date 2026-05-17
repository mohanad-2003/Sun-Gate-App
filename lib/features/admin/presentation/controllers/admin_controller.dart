import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/features/admin/data/provider/admin_data_provider.dart';
import 'package:sun_gate_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_state.dart';

final adminControllerProvider =
    StateNotifierProvider<AdminController, AdminState>((ref) {
      return AdminController(repository: ref.read(adminRepositoryProvider));
    });

class AdminController extends StateNotifier<AdminState> {
  final AdminRepository repository;

  AdminController({required this.repository}) : super(AdminState.initial());

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final stats = await repository.getDashboardStats();
      state = state.copyWith(isLoading: false, stats: stats);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );
    }
  }

  Future<void> loadCompanyRequests() async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final requests = await repository.getCompanyRequests();
      state = state.copyWith(isLoading: false, companyRequests: requests);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );
    }
  }

  Future<void> loadAccounts() async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final accounts = await repository.getAccounts(limit: 50);
      state = state.copyWith(isLoading: false, accounts: accounts);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );
    }
  }

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final products = await repository.getProducts(limit: 50);
      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );
    }
  }

  Future<void> loadArticles() async {
    state = state.copyWith(isLoading: true, clearMessages: true);
    try {
      final articles = await repository.getArticles(limit: 50);
      state = state.copyWith(isLoading: false, articles: articles);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _friendlyError(e),
      );
    }
  }

  Future<bool> confirmCompanyRequest({
    required String requestId,
    required String plan,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = state.copyWith(isSaving: true, clearMessages: true);
    try {
      await repository.confirmCompanyPayment(
        requestId: requestId,
        plan: plan,
        startDate: startDate,
        endDate: endDate,
      );
      await loadCompanyRequests();
      await loadDashboard();
      state = state.copyWith(
        isSaving: false,
        successMessage: 'Company approved successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  Future<bool> rejectCompanyRequest(String requestId) async {
    state = state.copyWith(isSaving: true, clearMessages: true);
    try {
      await repository.rejectCompanyRequest(requestId);
      await loadCompanyRequests();
      await loadDashboard();
      state = state.copyWith(
        isSaving: false,
        successMessage: 'Request rejected',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  Future<bool> activateAccount(String userId) async {
    return _runAccountAction(
      () => repository.activateAccount(userId),
      'Account activated',
    );
  }

  Future<bool> suspendAccount(String userId) async {
    return _runAccountAction(
      () => repository.suspendAccount(userId),
      'Account suspended',
    );
  }

  Future<bool> deleteAccount(String userId) async {
    return _runAccountAction(
      () => repository.deleteAccount(userId),
      'Account deleted',
    );
  }

  Future<bool> deleteProduct(String productId) async {
    state = state.copyWith(isSaving: true, clearMessages: true);
    try {
      await repository.deleteProduct(productId);
      await loadProducts();
      state = state.copyWith(
        isSaving: false,
        successMessage: 'Product deleted',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  Future<bool> saveArticle({
    String? articleId,
    required String title,
    required String body,
  }) async {
    state = state.copyWith(isSaving: true, clearMessages: true);
    try {
      if (articleId == null || articleId.isEmpty) {
        await repository.createArticle(title: title, body: body);
      } else {
        await repository.updateArticle(
          articleId: articleId,
          title: title,
          body: body,
        );
      }
      await loadArticles();
      state = state.copyWith(
        isSaving: false,
        successMessage: 'Content saved',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  Future<bool> deleteArticle(String articleId) async {
    state = state.copyWith(isSaving: true, clearMessages: true);
    try {
      await repository.deleteArticle(articleId);
      await loadArticles();
      state = state.copyWith(
        isSaving: false,
        successMessage: 'Article deleted',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }

  String _friendlyError(Object error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    if (message.contains('404')) {
      return 'This admin API is not available on the server yet.';
    }
    if (message.contains('401') || message.contains('403')) {
      return 'You do not have permission for this action.';
    }
    return message;
  }

  Future<bool> _runAccountAction(
    Future<void> Function() action,
    String successMessage,
  ) async {
    state = state.copyWith(isSaving: true, clearMessages: true);
    try {
      await action();
      await loadAccounts();
      state = state.copyWith(
        isSaving: false,
        successMessage: successMessage,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: _friendlyError(e),
      );
      return false;
    }
  }
}
