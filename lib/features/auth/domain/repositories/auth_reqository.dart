import 'package:sun_gate_app/features/auth/domain/entities/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login({required String email, required String password});

  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String birthDate,
    String? location,
    String? gender,
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

  Future<String> companySendOtp({required String email});

  Future<String> companyVerifyOtp({required String email, required String otp});

  Future<AuthResult> companyRegister({
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
  });

  Future<AuthResult> companyLogin({
    required String email,
    required String password,
  });

  Future<void> deleteAccount();
}
