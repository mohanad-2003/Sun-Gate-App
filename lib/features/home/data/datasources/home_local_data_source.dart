import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';
import 'package:sun_gate_app/features/home/data/models/company_model.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';

abstract class HomeLocalDataSource {
  Future<List<CategoryItemModel>> getCategories();
  Future<List<CompanyModel>> getPopularCompanies();
  Future<List<ProductModel>> getPopularProducts();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<List<CategoryItemModel>> getCategories() async {
    return [
      CategoryItemModel(
        id: '1',
        title: 'Batteries',
        imagePath: 'assets/images/battery.jpg',
      ),
      CategoryItemModel(
        id: '2',
        title: 'Inverters',
        imagePath: 'assets/images/inverter.jpg',
      ),
      CategoryItemModel(
        id: '3',
        title: 'Panels',
        imagePath: 'assets/images/panels.jpg',
      ),
      CategoryItemModel(
        id: '4',
        title: 'Suppliers',
        imagePath: 'assets/images/suppliers.jpg',
      ),
    ];
  }

  @override
  Future<List<CompanyModel>> getPopularCompanies() async {
    return const [
      CompanyModel(
        id: '1',
        name: 'luminance Solar',
        imagePath: 'assets/images/company_luminis.jpg',
        Description: 'Expert installation of high-efficiency panels',
        tags: ['Batteries', 'Panels'],
      ),
      CompanyModel(
        id: '2',
        name: 'VoltGuard Com',
        imagePath: 'assets/images/company_sungrid.jpg',
        Description: 'Advanced battery and inverter management',
        tags: ['Batteries', 'Inverter'],
      ),
    ];
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    return const [];
  }
}
