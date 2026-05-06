import 'package:dio/dio.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';

class HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSource(this.dio);

  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get(
      ApiConstants.products,
      queryParameters: {
        'page': 1,
        'limit': 12,
        // 'status': 'active', // عطلها مؤقتًا
      },
    );

    print('PRODUCTS RESPONSE: ${response.data}');

    final data = response.data['data'];

    final docs = data is Map<String, dynamic> ? data['docs'] : data;

    print('PRODUCTS DOCS: $docs');

    if (docs is! List) {
      return [];
    }

    return docs
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
