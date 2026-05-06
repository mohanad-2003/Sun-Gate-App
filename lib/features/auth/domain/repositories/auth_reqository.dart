import 'package:sun_gate_app/features/auth/domain/entities/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login({required String email, required String password});

  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String birthDate,
    required String? location,
    required String? gender,
  });

  Future<String> forgotPassword({required String email});

  Future<String> resendVerification({required String email});

  Future<String> verifyEmail({required String email, required String code});
  Future<String> verifyOtp({required String email, required String code});

  Future<String> assignPassword({
    required String email,
    required String password,
  });

  Future<String> resetPassword({
    required String password,
    required String passwordResetToken,
  });

  Future<AuthResult> googleLogin({required String idToken});

  Future<void> logout();
}