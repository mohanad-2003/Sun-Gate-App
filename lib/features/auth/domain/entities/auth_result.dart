import 'package:sun_gate_app/features/auth/domain/entities/auth_user.dart';

class AuthResult {
  final String? accessToken;
  final String? refreshToken;
  final AuthUser user;
  final String? message;

  AuthResult({
    this.accessToken,
    this.refreshToken,
    this.message,
    required this.user,
  });
}
