import 'package:sun_gate_app/features/home/data/models/category_item_model.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';

abstract class HomeLocalDataSource {
  Future<List<CategoryItemModel>> getCategories();
  // Future<List<CompanyModel>> getPopularCompanies();
  Future<List<ProductModel>> getPopularProducts();
}

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  @override
  Future<List<CategoryItemModel>> getCategories() async {
    return [
      CategoryItemModel(
        id: '1',
        titleKey: 'Batteries',
        imagePath: 'assets/images/battery.jpg',
      ),
      CategoryItemModel(
        id: '2',
        titleKey: 'Inverters',
        imagePath: 'assets/images/inverter.jpg',
      ),
      CategoryItemModel(
        id: '3',
        titleKey: 'Panels',
        imagePath: 'assets/images/panels.jpg',
      ),
      CategoryItemModel(
        id: '4',
        titleKey: 'Suppliers',
        imagePath: 'assets/images/suppliers.jpg',
      ),
    ];
  }

  // @override
  // Future<List<CompanyModel>> getPopularCompanies() async {
  //   return const [
  //     CompanyModel(
  //       id: '1',
  //       nameKey: 'luminance Solar',
  //       coverImagePath: 'assets/images/company_luminis.jpg',
  //       descriptionKey: 'Expert installation of high-efficiency panels',
  //       tagKeys: ['Batteries', 'Panels'],
  //       locationKey: '',
  //       logoPath: '',
  //       rating: 2,
  //       reviewCount: 4,
  //       shortDescriptionKey: '',
  //     ),
  //     CompanyModel(
  //       id: '2',
  //       nameKey: 'VoltGuard Com',
  //       coverImagePath: 'assets/images/company_sungrid.jpg',
  //       descriptionKey: 'Advanced battery and inverter management',
  //       tagKeys: ['Batteries', 'Inverter'],
  //       locationKey: '',
  //       logoPath: '',
  //       rating: 3,
  //       reviewCount: 4,
  //       shortDescriptionKey: '',
  //     ),
  //   ];
  // }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    return const [];
  }
}
