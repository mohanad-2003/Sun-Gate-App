class CompanyVerifyOtpRequestDto {
  final String email;
  final String otp;

  CompanyVerifyOtpRequestDto({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}
