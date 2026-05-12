import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import 'package:sun_gate_app/features/auth/data/dto/company_send_otp_request_dto.dart';
import 'package:sun_gate_app/features/auth/data/dto/company_verify_otp_request_dto.dart';
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
    ResetPasswordRequestDto request, {
    required String passwordResetToken,
  });
  Future<BasicMessageResponseModel> verifyEmail(VerifyOtpRequestDto request);
  Future<BasicMessageResponseModel> forgotPassword(
    ForgotPasswordRequestDto request,
  );
  Future<AuthResponseModel> googleLogin(GoogleLoginRequestDto request);
  Future<BasicMessageResponseModel> assignPassword({
    required String email,
    required String password,
  });
  Future<BasicMessageResponseModel> resendVerification(String email);

  Future<BasicMessageResponseModel> companySendOtp(
    CompanySendOtpRequestDto request,
  );
  Future<BasicMessageResponseModel> companyVerifyOtp(
    CompanyVerifyOtpRequestDto request,
  );
  Future<AuthResponseModel> companyRegister(FormData formData);
  Future<AuthResponseModel> companyLogin(LoginRequestDto request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  String _mapCrossAccountEmailConflict(
    String? message, {
    required bool forCompanyFlow,
  }) {
    final normalized = message?.toLowerCase() ?? '';
    final isConflict =
        normalized.contains('email already exists') ||
        normalized.contains('already exists') ||
        normalized.contains('already registered') ||
        normalized.contains('email is already') ||
        normalized.contains('duplicate') ||
        normalized.contains('used before');

    if (!isConflict) {
      return message?.isNotEmpty == true
          ? message!
          : (forCompanyFlow
                ? 'This email is already linked to another account.'
                : 'This email is already linked to another account.');
    }

    return forCompanyFlow
        ? 'This email is already used by another account. You cannot create a company account and a user account with the same email.'
        : 'This email is already used by another account. You cannot create a user account and a company account with the same email.';
  }

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
          _mapCrossAccountEmailConflict(
            data is Map<String, dynamic> ? data['message']?.toString() : null,
            forCompanyFlow: false,
          ),
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
  Future<BasicMessageResponseModel> verifyEmail(
    VerifyOtpRequestDto request,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.verifyEmail,
        data: request.toJson(),
      );

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
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

      throw Exception('Email verification failed');
    }
  }

  @override
  Future<BasicMessageResponseModel> assignPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.setPassword,
        data: {'email': email, 'password': password},
      );

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }

      throw Exception('Assign password failed');
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
    ResetPasswordRequestDto request, {
    required String passwordResetToken,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.resetPassword,
        data: request.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $passwordResetToken'},
        ),
      );

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
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
        throw Exception('Missing or invalid password-reset session');
      }

      if (e.response?.statusCode == 403) {
        throw Exception('Reset window expired after verification');
      }

      if (e.response?.statusCode == 404) {
        throw Exception('User not found');
      }

      throw Exception('Reset password failed');
    }
  }

  @override
  Future<BasicMessageResponseModel> verifyOtp(
    VerifyOtpRequestDto request,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.verifyResetOtp,
        data: request.toJson(),
      );

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }

      throw Exception('OTP verification failed');
    }
  }

  @override
  Future<BasicMessageResponseModel> resendVerification(String email) async {
    try {
      final response = await dio.post(
        ApiConstants.resendCode,
        data: {'email': email.trim()},
      );

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }

      throw Exception('Resend verification failed');
    }
  }

  @override
  Future<BasicMessageResponseModel> companySendOtp(
    CompanySendOtpRequestDto request,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.companySendOtp,
        data: request.toJson(),
      );

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(
          _mapCrossAccountEmailConflict(message, forCompanyFlow: true),
        );
      }

      throw Exception('Company send OTP failed');
    }
  }

  @override
  Future<BasicMessageResponseModel> companyVerifyOtp(
    CompanyVerifyOtpRequestDto request,
  ) async {
    try {
      final response = await dio.post(
        ApiConstants.companyVerifyOtp,
        data: request.toJson(),
      );

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }

      throw Exception('Company verify OTP failed');
    }
  }

  @override
  Future<AuthResponseModel> companyRegister(FormData formData) async {
    try {
      final response = await dio.post(
        ApiConstants.companyRegister,
        data: formData,
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(
          _mapCrossAccountEmailConflict(message, forCompanyFlow: true),
        );
      }

      throw Exception('Company registration failed');
    }
  }

  @override
  Future<AuthResponseModel> companyLogin(LoginRequestDto request) async {
    try {
      final response = await dio.post(
        ApiConstants.companyLogin,
        data: request.toJson(),
      );

      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final data = e.response?.data;
      debugPrint('COMPANY LOGIN STATUS: ${e.response?.statusCode}'); // ← أضف
      debugPrint('COMPANY LOGIN DATA: $data'); // ← أضف
      if (e.response?.statusCode == 403) {
        final serverMessage = data is Map<String, dynamic>
            ? data['message']?.toString()
            : null;

        if (serverMessage != null &&
            serverMessage.toLowerCase().contains('not active')) {
          throw Exception(
            'Your company request is still pending admin approval. '
            'You can sign in after the company account is activated.',
          );
        }

        throw Exception(
          serverMessage ??
              'Email not verified or company account is not active yet.',
        );
      }

      final message = data is Map<String, dynamic>
          ? data['message']?.toString()
          : null;

      if (message != null && message.isNotEmpty) {
        throw Exception(message);
      }

      throw Exception('Company login failed');
    }
  }
}
