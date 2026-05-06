import 'package:sun_gate_app/features/home/data/models/product_model.dart';

abstract class HomeRepository {
  Future<List<ProductModel>> getProducts();
}