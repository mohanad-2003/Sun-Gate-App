class CompanySendOtpRequestDto {
  final String email;

  CompanySendOtpRequestDto({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}
