class ResetPasswordRequestDto {
  final String email;
  final String token;
  final String password;

  const ResetPasswordRequestDto({
    required this.email,
    required this.token,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'token': token.trim(),
      'password': password.trim(),
    };
  }
}