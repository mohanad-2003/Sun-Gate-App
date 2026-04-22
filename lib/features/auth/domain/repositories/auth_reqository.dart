import 'package:sun_gate_app/features/auth/domain/entities/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login({required String email, required String password});

  Future<AuthResult> register({
    required String firstName,
    required String lastname,
    required String email,
    required String password,
  });

  Future<String> forgotPassword({required String email});
  Future<String> verifyEmail({required String email, required String code});
  Future<String> verifyOtp({required String email, required String code});

  Future<String> resetPassword({
    required String password,
    required String passwordResetToken,
  });
  Future<AuthResult> googleLogin({required String idToken});

  Future<void> logout();
}
