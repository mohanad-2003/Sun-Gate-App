import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';
import 'package:sun_gate_app/features/home/data/models/company_model.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';

abstract class HomeRepository {
  Future<List<CategoryItemModel>> getCategories();
  Future<List<CompanyModel>> getPopularCompanies();
  Future<List<ProductModel>> getPopularProducts();
}