class VerifyOtpRequestDto {
  final String email;
  final String code;

  const VerifyOtpRequestDto({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'token': code.trim(),
    };
  }
}