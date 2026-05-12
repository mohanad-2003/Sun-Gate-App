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
      action: AuthAction.login,
    );

    try {
      await repository.login(email: email, password: password);
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        action: AuthAction.login,
      );
    } catch (e) {
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (_shouldTryCompanyLogin(errorMessage)) {
        try {
          await repository.companyLogin(email: email, password: password);
          state = state.copyWith(
            isLoading: false,
            isSuccess: true,
            action: AuthAction.companyLogin,
          );
          return;
        } catch (companyError) {
          state = state.copyWith(
            isLoading: false,
            errorMessage: companyError.toString().replaceFirst(
              'Exception: ',
              '',
            ),
            isSuccess: false,
            action: AuthAction.companyLogin,
          );
          return;
        }
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
        isSuccess: false,
        action: AuthAction.login,
      );
    }
  }

  bool _shouldTryCompanyLogin(String errorMessage) {
    final normalized = errorMessage.toLowerCase();
    return normalized.contains('invalid email or password') ||
        normalized.contains('invalid credentials') ||
        normalized.contains('user not found') ||
        normalized.contains('email not found') ||
        normalized.contains('not found');
  }

  Future<void> companyLogin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      action: AuthAction.companyLogin,
    );

    try {
      await repository.companyLogin(email: email, password: password);
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        action: AuthAction.companyLogin,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        isSuccess: false,
        action: AuthAction.companyLogin,
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
      action: AuthAction.register,
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
        action: AuthAction.register,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
        action: AuthAction.register,
      );
    }
  }

  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      message: null,
      action: AuthAction.forgotPassword,
    );

    try {
      final message = await repository.forgotPassword(email: email);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: message,
        action: AuthAction.forgotPassword,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
        action: AuthAction.forgotPassword,
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
      action: AuthAction.resetPassword,
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
        action: AuthAction.resetPassword,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
        action: AuthAction.resetPassword,
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
      action: AuthAction.verifyEmail,
    );

    try {
      final message = await repository.verifyEmail(email: email, code: code);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: message,
        action: AuthAction.verifyEmail,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
        action: AuthAction.verifyEmail,
      );
    }
  }

  Future<void> verifyOtp({required String email, required String code}) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      errorMessage: null,
      message: null,
      resetToken: null,
      action: AuthAction.verifyOtp,
    );

    try {
      final token = await repository.verifyOtp(email: email, code: code);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        resetToken: token,
        action: AuthAction.verifyOtp,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        resetToken: null,
        action: AuthAction.verifyOtp,
      );
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
      action: AuthAction.googleLogin,
    );

    try {
      await repository.googleLogin(idToken: idToken);

      ref.read(profileControllerProvider.notifier).setGooglePhoto(photoUrl);

      await ref.read(profileControllerProvider.notifier).getMyProfile();

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        message: 'Google login successful',
        action: AuthAction.googleLogin,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        action: AuthAction.googleLogin,
      );
    }
  }

  Future<void> assignPassword({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      action: AuthAction.assignPassword,
    );

    try {
      final message = await repository.assignPassword(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        message: message,
        action: AuthAction.assignPassword,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        action: AuthAction.assignPassword,
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      message: null,
      isSuccess: false,
      action: AuthAction.logout,
    );

    try {
      await repository.logout();

      state = state.copyWith(
        isLoading: false,
        message: 'Logged out successfully',
        action: AuthAction.logout,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        action: AuthAction.logout,
      );
    }

    try {
      await repository.logout();
      state = state.copyWith(
        isLoading: false,
        message: 'Logged out Successfully',
        action: AuthAction.logout,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        action: AuthAction.logout,
      );
    }
  }

  Future<void> resendVerification({required String email}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      message: null,
      action: AuthAction.resendVerification,
    );

    try {
      final message = await repository.resendVerification(email: email);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: message,
        action: AuthAction.resendVerification,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
        action: AuthAction.resendVerification,
      );
    }
  }

  Future<void> companySendOtp({required String email}) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      message: null,
      action: AuthAction.companySendOtp,
    );

    try {
      final message = await repository.companySendOtp(email: email);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: message,
        action: AuthAction.companySendOtp,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
        action: AuthAction.companySendOtp,
      );
    }
  }

  Future<void> companyVerifyOtp({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      errorMessage: null,
      message: null,
      resetToken: null,
      action: AuthAction.companyVerifyOtp,
    );

    try {
      final token = await repository.companyVerifyOtp(email: email, otp: otp);

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        resetToken: token,
        action: AuthAction.companyVerifyOtp,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        resetToken: null,
        action: AuthAction.companyVerifyOtp,
      );
    }
  }

  Future<void> companyRegister({
    required String documentPath,
    required String logoPath,
    required String registrationToken,
    required String companyName,
    required String ownerName,
    required String email,
    required String location,
    required String establishmentDate,
    required bool acceptPrivacyPolicy,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
      message: null,
      action: AuthAction.companyRegister,
    );

    try {
      final result = await repository.companyRegister(
        documentPath: documentPath,
        logoPath: logoPath,
        registrationToken: registrationToken,
        companyName: companyName,
        ownerName: ownerName,
        email: email,
        location: location,
        establishmentDate: establishmentDate,
        acceptPrivacyPolicy: acceptPrivacyPolicy,
        password: password,
      );

      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        errorMessage: null,
        message: result.message,
        action: AuthAction.companyRegister,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        message: null,
        action: AuthAction.companyRegister,
      );
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      errorMessage: null,
      action: AuthAction.deleteAccount,
    );
    try {
      await repository.deleteAccount();
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        action: AuthAction.deleteAccount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
        action: AuthAction.deleteAccount,
      );
    }
  }
}
