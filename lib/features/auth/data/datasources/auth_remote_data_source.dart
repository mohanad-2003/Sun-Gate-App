import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import 'package:sun_gate_app/features/auth/data/dto/forgot_password_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/google_login_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/login_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/register_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/reset_password_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/verify_otp_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/models/auth_response_model.dart';
import 'package:sun_gate_app/features/auth/data/models/basic_message_response_modle.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestDto request);
  Future<AuthResponseModel> register(RegisterRequestDto request);

  Future<BasicMessageResponseModel> verifyOtp(VerifyOtpRequestDto request);
  Future<BasicMessageResponseModel> resetPassword(
    ResetPasswordRequestDto request,
  );
  Future<BasicMessageResponseModel> forgotPassword(
    ForgotPasswordRequestDto request,
  );
  Future<AuthResponseModel> googleLogin(GoogleLoginRequestDto request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login(LoginRequestDto request) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;

      if (e.response?.statusCode == 400) {
        throw Exception(
          data is Map<String, dynamic>
              ? data['message']?.toString() ?? 'Validation error'
              : 'Validation error',
        );
      }

      if (e.response?.statusCode == 401) {
        throw Exception(
          data is Map<String, dynamic>
              ? data['message']?.toString() ?? 'Invalid email or password'
              : 'Invalid email or password',
        );
      }

      if (e.response?.statusCode == 403) {
        throw Exception(
          data is Map<String, dynamic>
              ? data['message']?.toString() ??
                    'Please verify your email before signing in'
              : 'Please verify your email before signing in',
        );
      }

      if (e.response?.statusCode == 500) {
        throw Exception(
          data is Map<String, dynamic>
              ? data['message']?.toString() ?? 'Internal server error'
              : 'Internal server error',
        );
      }

      throw Exception('Something went wrong');
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestDto request) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;

      if (e.response?.statusCode == 400) {
        throw Exception(
          data is Map<String, dynamic>
              ? data['message']?.toString() ?? 'Validation error'
              : 'Validation error',
        );
      }

      if (e.response?.statusCode == 409) {
        throw Exception(
          data is Map<String, dynamic>
              ? data['message']?.toString() ?? 'Email already exists'
              : 'Email already exists',
        );
      }

      if (e.response?.statusCode == 500) {
        throw Exception(
          data is Map<String, dynamic>
              ? data['message']?.toString() ?? 'Internal server error'
              : 'Internal server error',
        );
      }

      throw Exception('Something went wrong');
    }
  }

  @override
  Future<BasicMessageResponseModel> verifyOtp(
    VerifyOtpRequestDto request,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.verifyEmail,
        data: request.toJson(),
      );

      debugPrint('VERIFY OTP STATUS: ${response.statusCode}');
      debugPrint('VERIFY OTP DATA: ${response.data}');

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      debugPrint('VERIFY OTP ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('VERIFY OTP ERROR DATA: ${e.response?.data}');
      debugPrint('VERIFY OTP ERROR MESSAGE: ${e.message}');

      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }

      if (e.response?.statusCode == 400) {
        throw Exception('Invalid email');
      }

      if (e.response?.statusCode == 403) {
        throw Exception('Verification token has expired');
      }

      if (e.response?.statusCode == 500) {
        throw Exception('Internal server error');
      }

      throw Exception(
        'OTP verification failed: ${e.response?.statusCode ?? 'no-status'}',
      );
    } catch (e) {
      debugPrint('VERIFY OTP PARSE ERROR: $e');
      throw Exception('Verify OTP parse error: $e');
    }
  }

  @override
  Future<AuthResponseModel> googleLogin(GoogleLoginRequestDto request) async {
    try {
      final response = await dio.post(
        ApiConstants.googleLogin,
        data: request.toJson(),
      );

      debugPrint('GOOGLE LOGIN STATUS: ${response.statusCode}');
      debugPrint('GOOGLE LOGIN DATA: ${response.data}');

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      debugPrint('GOOGLE LOGIN ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('GOOGLE LOGIN ERROR DATA: ${e.response?.data}');
      debugPrint('GOOGLE LOGIN ERROR MESSAGE: ${e.message}');

      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }

      if (e.response?.statusCode == 400) {
        throw Exception('Validation error');
      }

      if (e.response?.statusCode == 401) {
        throw Exception('Invalid Google token');
      }

      if (e.response?.statusCode == 409) {
        throw Exception('Google account does not match this user');
      }

      if (e.response?.statusCode == 500) {
        throw Exception('Google login is not configured');
      }

      throw Exception(
        'Google login failed: ${e.response?.statusCode ?? 'no-status'}',
      );
    } catch (e) {
      debugPrint('GOOGLE LOGIN PARSE ERROR: $e');
      throw Exception('Google login parse error: $e');
    }
  }

  @override
  Future<BasicMessageResponseModel> forgotPassword(
    ForgotPasswordRequestDto request,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.forgotPassword,
        data: request.toJson(),
      );

      debugPrint('FORGOT PASSWORD STATUS: ${response.statusCode}');
      debugPrint('FORGOT PASSWORD DATA: ${response.data}');

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      debugPrint('FORGOT PASSWORD ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('FORGOT PASSWORD ERROR DATA: ${e.response?.data}');
      debugPrint('FORGOT PASSWORD ERROR MESSAGE: ${e.message}');

      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }

      if (e.response?.statusCode == 400) {
        throw Exception('Validation error');
      }

      if (e.response?.statusCode == 404) {
        throw Exception('Email not found');
      }

      if (e.response?.statusCode == 500) {
        throw Exception('Internal server error');
      }

      throw Exception(
        'Forgot password failed: ${e.response?.statusCode ?? 'no-status'}',
      );
    } catch (e) {
      debugPrint('FORGOT PASSWORD PARSE ERROR: $e');
      throw Exception('Forgot password parse error: $e');
    }
  }

  @override
  Future<BasicMessageResponseModel> resetPassword(
    ResetPasswordRequestDto request,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.resetPassword,
        data: request.toJson(),
      );

      debugPrint('RESET PASSWORD REQUEST: ${request.toJson()}');
      debugPrint('RESET PASSWORD STATUS: ${response.statusCode}');
      debugPrint('RESET PASSWORD DATA: ${response.data}');

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      debugPrint('RESET PASSWORD ERROR STATUS: ${e.response?.statusCode}');
      debugPrint('RESET PASSWORD ERROR DATA: ${e.response?.data}');
      throw Exception(
        e.response?.data is Map<String, dynamic>
            ? e.response?.data['message']?.toString() ?? 'Reset password failed'
            : 'Reset password failed',
      );
    }
  }
}
