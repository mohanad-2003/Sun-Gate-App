class RegisterRequestDto {
  final String fullName;
  final String email;
  final String birthDate;
  final String? location;
  final String? gender;

  RegisterRequestDto({
    required this.fullName,
    required this.email,
    required this.birthDate,
    this.location,
    this.gender,
  });
  Map<String, dynamic> toJson() {
    final data = {"fullName": fullName, "email": email, "birthDate": birthDate};

    if (location != null && location!.isNotEmpty) {
      data["location"] = location!;
    }

    return data;
  }
}
