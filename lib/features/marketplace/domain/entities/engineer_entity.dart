class EngineerEntity {
  final String id;
  final String userId;
  final String companyId;
  final int yearsOfExperience;
  final String certificate;
  final double rating;
  final String? phoneWhatsapp;

  const EngineerEntity({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.yearsOfExperience,
    required this.certificate,
    required this.rating,
    this.phoneWhatsapp,
  });
}
