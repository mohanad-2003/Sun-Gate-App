import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';
import 'package:sun_gate_app/features/home/data/models/company_model.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';

class HomeState {
  final bool isLoading;
  final String? errorMessage;
  final List<CategoryItemModel> categories;
  final List<CompanyModel> companies;
  final List<ProductModel> products;

  const HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.categories = const [],
    this.companies = const [],
    this.products = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<CategoryItemModel>? categories,
    List<CompanyModel>? companies,
    List<ProductModel>? products,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      categories: categories ?? this.categories,
      companies: companies ?? this.companies,
      products: products ?? this.products,
    );
  }

  factory HomeState.initial() => const HomeState();
}