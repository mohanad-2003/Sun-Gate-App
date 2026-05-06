import 'package:sun_gate_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:sun_gate_app/features/home/data/models/product_model.dart';
import 'package:sun_gate_app/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ProductModel>> getProducts() {
    return remoteDataSource.getProducts();
  }
}