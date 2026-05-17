import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/core/network/dio_provider.dart';
import 'package:sun_gate_app/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:sun_gate_app/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:sun_gate_app/features/admin/domain/repositories/admin_repository.dart';

final adminRemoteDataSourceProvider = Provider<AdminRemoteDataSource>((ref) {
  return AdminRemoteDataSource(ref.read(dioProvider));
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(
    remoteDataSource: ref.read(adminRemoteDataSourceProvider),
  );
});
