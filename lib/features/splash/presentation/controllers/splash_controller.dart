import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sun_gate_app/features/auth/data/providers/auth_data_providers.dart';

final splashControllerProvider = Provider<SplashController>((ref) {
  return SplashController(
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});

class SplashController {
  final AuthLocalDataSource localDataSource;
  SplashController({required this.localDataSource});

  Future<bool> hasAccessToken() async {
    final token = await localDataSource.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
