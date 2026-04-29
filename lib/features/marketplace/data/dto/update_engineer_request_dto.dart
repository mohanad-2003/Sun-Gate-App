class UpdateEngineerRequestDto {
  final int? yearsOfExperience;
  final String? certificate;
  final double? rating;

  const UpdateEngineerRequestDto({
    this.yearsOfExperience,
    this.certificate,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (yearsOfExperience != null) {
      map['yearsOfExperience'] = yearsOfExperience;
    }
    if (certificate != null && certificate!.trim().isNotEmpty) {
      map['certificate'] = certificate!.trim();
    }
    if (rating != null) {
      map['rating'] = rating;
    }
    return map;
  }
}
