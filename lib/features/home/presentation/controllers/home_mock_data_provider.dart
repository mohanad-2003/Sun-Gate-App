import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:sun_gate_app/features/home/data/models/user_model.dart';
import 'package:sun_gate_app/features/home/data/repositories/home_repositores_imp.dart';
import 'package:sun_gate_app/features/home/domain/repositories/home_repository.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_state.dart';

final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSourceImpl();
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    localDataSource: ref.read(homeLocalDataSourceProvider),
  );
});

final userProvider = StateProvider<UserModel?>((ref) => null);
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    return HomeController(repository: ref.read(homeRepositoryProvider))
      ..loadHomeData();
  },
);

class HomeController extends StateNotifier<HomeState> {
  final HomeRepository repository;

  HomeController({required this.repository}) : super(HomeState.initial());

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final categories = await repository.getCategories();
      final companies = await repository.getPopularCompanies();
      final products = await repository.getPopularProducts();

      state = state.copyWith(
        isLoading: false,
        categories: categories,
        companies: companies,
        products: products,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
