import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/auth/data/datasources/auth_local_data_source.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl();
});
