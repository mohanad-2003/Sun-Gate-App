import 'package:sun_gate_app/features/home/data/datasources/home_local_data_source.dart';
import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';
import 'package:sun_gate_app/features/home/domain/repositories/home_repository.dart';
import 'package:sun_gate_app/features/marketplace/data/models/company_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource localDataSource;

  HomeRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CategoryItemModel>> getCategories() {
    return localDataSource.getCategories();
  }

  // @override
  // Future<List<CompanyModel>> getPopularCompanies() {
  //   return localDataSource.getPopularCompanies();
  // }

  @override
  Future<List<ProductModel>> getPopularProducts() {
    return localDataSource.getPopularProducts();
  }
}
