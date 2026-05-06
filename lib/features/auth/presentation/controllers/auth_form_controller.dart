import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/core/network/dio_provider.dart';
import 'package:sun_gate_app/core/services/google_auth_services.dart';
import 'package:sun_gate_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sun_gate_app/features/auth/data/providers/auth_data_providers.dart';
import 'package:sun_gate_app/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:sun_gate_app/features/auth/domain/repositories/auth_reqository.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';
import 'auth_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dio: ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});
final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});

final authControllerProvider =
    StateNotifierProvider<AuthFormController, AuthState>((ref) {
      return AuthFormController(repository: ref.read(authRepositoryProvider));
    });

class AuthFormController extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthFormController({required this.repository}) : super(AuthState.initial());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    try {
      await repository.login(email: email, password: password);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        isSuccess: false,
      );
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String birthDate,
    String? location,
    String? gender,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      message: null,
    );

    try {
      final result = await repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        birthDate: birthDate,
        gender: gender,
        location: location,
      );

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: result.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
      );
    }
  }

  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      message: null,
    );

    try {
      final message = await repository.forgotPassword(email: email);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
      );
    }
  }

  Future<void> resetPassword({
    required String password,
    required String passwordResetToken,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      message: null,
    );

    try {
      final message = await repository.resetPassword(
        password: password,
        passwordResetToken: passwordResetToken,
      );

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
      );
    }
  }

  Future<void> verifyEmail({
    required String email,
    required String code,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      message: null,
    );

    try {
      final message = await repository.verifyEmail(email: email, code: code);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
      );
    }
  }

  Future<void> verifyOtp({required String email, required String code}) async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await repository.verifyOtp(email: email, code: code);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        resetToken: token,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> googleLogin({
    required String idToken,
    required WidgetRef ref,
    required String? photoUrl,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );

    try {
      await repository.googleLogin(idToken: idToken);

      ref.read(profileControllerProvider.notifier).setGooglePhoto(photoUrl);

      await ref.read(profileControllerProvider.notifier).getMyProfile();

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        message: 'Google login successful',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> assignPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final message = await repository.assignPassword(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        message: message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, errorMessage: null, message: null);

    try {
      await repository.logout();

      state = state.copyWith(
        isLoading: false,
        message: 'Logged out successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }

    try {
      await repository.logout();
      state = state.copyWith(
        isLoading: false,
        message: 'Logged out Successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> resendVerification({required String email}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      message: null,
    );

    try {
      final message = await repository.resendVerification(email: email);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
      );
    }
  }
}
