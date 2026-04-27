class UpdateProfileRequestDto {
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? birthDate;
  final String? gender;
  final String? location;
  final String? whatsappNumber;

  const UpdateProfileRequestDto({
    this.firstName,
    this.lastName,
    this.fullName,
    this.birthDate,
    this.gender,
    this.location,
    this.whatsappNumber,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    final fullName = '${firstName ?? ''} ${lastName ?? ''}'.trim();

    if (fullName.isNotEmpty) {
      map['fullName'] = fullName;
    }

    if (gender != null && gender!.trim().isNotEmpty) {
      map['gender'] = gender!.trim();
    }

    if (location != null && location!.trim().isNotEmpty) {
      map['location'] = location!.trim();
    }

    if (birthDate != null && birthDate!.trim().isNotEmpty) {
      map['birthDate'] = birthDate!.trim();
    }

    if (whatsappNumber != null && whatsappNumber!.trim().isNotEmpty) {
      map['whatsappNumber'] = whatsappNumber!.trim();
    }

    return map;
  }
}
