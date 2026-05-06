import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_remote_provider.dart';
import 'package:sun_gate_app/features/marketplace/data/models/company_model.dart';

class HomeState {
  final bool isLoading;
  final List<CategoryItemModel> categories;
  final List<ProductModel> products;
  final List<CompanyModel> companies;

  const HomeState({
    this.isLoading = false,
    this.categories = const [],
    this.products = const [],
    this.companies = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    List<CategoryItemModel>? categories,
    List<ProductModel>? products,
    List<CompanyModel>? companies,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      companies: companies ?? this.companies,
    );
  }
}

class HomeController extends StateNotifier<HomeState> {
  final HomeRemoteDataSource remote;

  HomeController(this.remote)
    : super(
        HomeState(
          categories: [
            CategoryItemModel(
              id: '1',
              titleKey: 'categoryBatteries',
              imagePath: 'assets/images/battery.jpg',
            ),
            CategoryItemModel(
              id: '2',
              titleKey: 'categoryInverters',
              imagePath: 'assets/images/inverter.jpg',
            ),
            CategoryItemModel(
              id: '3',
              titleKey: 'categoryPanels',
              imagePath: 'assets/images/panels.jpg',
            ),
            CategoryItemModel(
              id: '4',
              titleKey: 'categorySuppliers',
              imagePath: 'assets/images/suppliers.jpg',
            ),
          ],
        ),
      );

  Future<void> loadProducts() async {
    state = state.copyWith(isLoading: true);

    try {
      final products = await remote.getProducts();

      state = state.copyWith(isLoading: false, products: products);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      print("PRODUCTS ERROR: $e");
    }
  }
}

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    final remote = ref.read(homeRemoteDataSourceProvider);
    return HomeController(remote);
  },
);
