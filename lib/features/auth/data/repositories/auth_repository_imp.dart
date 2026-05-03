import 'package:sun_gate_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sun_gate_app/features/auth/data/datasources/auth_remote_data_source.dart';
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
    required String lastname,
    required String email,
    required String birthDate,
    required String location,
  }) async {
    final result = await remoteDataSource.register(
      RegisterRequestDto(
        firstName: firstName,
        lastName: lastname,
        email: email,
        birthDate: birthDate,
        location: location,
      ),
    );

    return result;
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    final result = await remoteDataSource.forgotPassword(
      ForgotPasswordRequestDto(email: email),
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
  Future<void> logout() async {
    await localDataSource.clearSession();
  }
}
