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
    final data = {
      "fullName": fullName.trim(),
      "email": email.trim(),
      "birthDate": birthDate.trim(),
    };

    if (location != null && location!.isNotEmpty) {
      data["location"] = location!.trim();
    }

    if (gender != null && gender!.isNotEmpty) {
      data["gender"] = gender!.trim();
    }

    return data;
  }
}
