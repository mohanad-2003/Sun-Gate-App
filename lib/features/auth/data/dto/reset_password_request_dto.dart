class ResetPasswordRequestDto {
  final String password;

  const ResetPasswordRequestDto({
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password.trim(),
    };
  }
}