class UpdateProfileRequestDto {
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? gender;
  final String? location;
  final String? whatsappNumbers;

  const UpdateProfileRequestDto({
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.location,
    this.whatsappNumbers,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (firstName != null && firstName!.trim().isNotEmpty) {
      map['firstName'] = firstName!.trim();
    }
    if (lastName != null && lastName!.trim().isNotEmpty) {
      map['lastName'] = lastName!.trim();
    }
    if (birthDate != null && birthDate!.trim().isNotEmpty) {
      map['birthDate'] = birthDate!.trim();
    }
    if (gender != null && gender!.trim().isNotEmpty) {
      map['gender'] = gender!.trim();
    }
    if (location != null && location!.trim().isNotEmpty) {
      map['location'] = location!.trim();
    }
    if (whatsappNumbers != null && whatsappNumbers!.trim().isNotEmpty) {
      map['whatsappNumbers'] = whatsappNumbers!.trim();
    }
    return map;
  }
}
