class CreateEngineerRequestDto {
  final String companyId;
  final int yearsOfExperience;
  final String certificate;

  const CreateEngineerRequestDto({
    required this.companyId,
    required this.yearsOfExperience,
    required this.certificate,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'yearsOfEXperience': yearsOfExperience,
      'certificate': certificate,
    };
  }
}
