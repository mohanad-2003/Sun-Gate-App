import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_gate_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sun_gate_app/features/auth/data/providers/auth_data_providers.dart';

final splashControllerProvider = Provider<SplashController>((ref) {
  return SplashController(
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});

enum SplashNavigationTarget { onboarding, authenticated, unauthenticated }

class SplashController {
  final AuthLocalDataSource localDataSource;

  SplashController({required this.localDataSource});

  Future<SplashNavigationTarget> getNavigationTarget() async {
    final prefs = await SharedPreferences.getInstance();

    final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('is_first_launch', false);
      return SplashNavigationTarget.onboarding;
    }

    final token = await localDataSource.getAccessToken();

    if (token != null && token.isNotEmpty) {
      return SplashNavigationTarget.authenticated;
    }

    return SplashNavigationTarget.unauthenticated;
  }
}
