import 'package:sun_gate_app/features/auth/domain/entities/auth_result.dart';

import 'auth_user_model.dart';

class AuthResponseModel extends AuthResult {
   AuthResponseModel({
    required super.user,
    super.accessToken,
    super.refreshToken,
    super.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    return AuthResponseModel(
      user: AuthUserModel.fromJson(
        (data?['user'] as Map<String, dynamic>?) ?? {
          
        },
      ),
      accessToken: data?['accessToken']?.toString(),
      refreshToken: data?['refreshToken']?.toString(),
      message: json['message']?.toString(),
    );
  }
}