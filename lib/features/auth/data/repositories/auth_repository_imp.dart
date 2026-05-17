import 'package:dio/dio.dart';
import 'package:sun_gate_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sun_gate_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sun_gate_app/features/auth/data/dto/company_send_otp_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/company_verify_otp_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/forgot_password_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/google_login_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/login_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/register_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/reset_password_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/verify_otp_request_dto.dart';
import 'package:sun_gate_app/features/auth/domain/entities/auth_result.dart';
import 'package:sun_gate_app/features/auth/domain/repositories/auth_reqository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.login(
      LoginRequestDto(email: email, password: password),
    );

    if (result.accessToken != null && result.accessToken!.isNotEmpty) {
      await localDataSource.saveAccessToken(result.accessToken!);
    }

    if (result.refreshToken != null && result.refreshToken!.isNotEmpty) {
      await localDataSource.saveRefreshToken(result.refreshToken!);
    }

    return result;
  }

  @override
  Future<AuthResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String birthDate,
    String? location,
    String? gender,
  }) async {
    final fullName = '$firstName $lastName';

    final result = await remoteDataSource.register(
      RegisterRequestDto(
        fullName: fullName.trim(),
        email: email,
        birthDate: birthDate,
        gender: gender,
        location: location,
      ),
    );

    return result;
  }

  @override
  Future<String> assignPassword({
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.assignPassword(
      email: email,
      password: password,
    );

    return result.message;
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    final result = await remoteDataSource.forgotPassword(
      ForgotPasswordRequestDto(email: email),
    );

    return result.message;
  }

  @override
  Future<String> verifyEmail({
    required String email,
    required String code,
  }) async {
    final result = await remoteDataSource.verifyEmail(
      VerifyOtpRequestDto(email: email, code: code),
    );

    return result.message;
  }

  @override
  Future<String> verifyOtp({
    required String email,
    required String code,
  }) async {
    final response = await remoteDataSource.verifyOtp(
      VerifyOtpRequestDto(email: email, code: code),
    );

    final token = response.passwordResetToken;

    if (token == null || token.isEmpty) {
      throw Exception('Password reset token was not returned');
    }

    return token;
  }

  @override
  Future<String> resetPassword({
    required String password,
    required String passwordResetToken,
  }) async {
    final result = await remoteDataSource.resetPassword(
      ResetPasswordRequestDto(password: password),
      passwordResetToken: passwordResetToken,
    );

    return result.message;
  }

  @override
  Future<AuthResult> googleLogin({required String idToken}) async {
    final result = await remoteDataSource.googleLogin(
      GoogleLoginRequestDto(idToken: idToken),
    );

    if (result.accessToken != null && result.accessToken!.isNotEmpty) {
      await localDataSource.saveAccessToken(result.accessToken!);
    }

    if (result.refreshToken != null && result.refreshToken!.isNotEmpty) {
      await localDataSource.saveRefreshToken(result.refreshToken!);
    }

    return result;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearSession();
  }

  @override
  Future<String> resendVerification({required String email}) async {
    final result = await remoteDataSource.resendVerification(email);
    return result.message;
  }

  @override
  Future<String> companySendOtp({required String email}) async {
    final result = await remoteDataSource.companySendOtp(
      CompanySendOtpRequestDto(email: email.trim()),
    );

    return result.message;
  }

  @override
  Future<String> companyVerifyOtp({
    required String email,
    required String otp,
  }) async {
    final result = await remoteDataSource.companyVerifyOtp(
      CompanyVerifyOtpRequestDto(email: email.trim(), otp: otp.trim()),
    );

    final token = result.registrationToken;

    if (token == null || token.isEmpty) {
      throw Exception('Registration token was not returned');
    }

    return token;
  }

  @override
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
  }) async {
    final formData = FormData.fromMap({
      'document': await MultipartFile.fromFile(documentPath),
      'logo': await MultipartFile.fromFile(logoPath),
      'registrationToken': registrationToken,
      'companyName': companyName.trim(),
      'ownerName': ownerName.trim(),
      'email': email.trim(),
      'location': location.trim(),
      'dateOfEstablishment': establishmentDate.trim(),
      'acceptPrivacyPolicy': acceptPrivacyPolicy,
      'password': password,
    });

    return remoteDataSource.companyRegister(formData);
  }

  @override
  Future<AuthResult> companyLogin({
    required String email,
    required String password,
  }) async {
    final result = await remoteDataSource.companyLogin(
      LoginRequestDto(email: email.trim(), password: password),
    );

    if (result.accessToken != null && result.accessToken!.isNotEmpty) {
      await localDataSource.saveAccessToken(result.accessToken!);
    }

    if (result.refreshToken != null && result.refreshToken!.isNotEmpty) {
      await localDataSource.saveRefreshToken(result.refreshToken!);
    }

    return result;
  }

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount();
    await localDataSource.clearSession();
  }
}
