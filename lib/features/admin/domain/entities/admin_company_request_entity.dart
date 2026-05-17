class AdminCompanyRequestEntity {
  final String id;
  final String? userId;
  final String? companyId;
  final String companyName;
  final String ownerName;
  final String email;
  final String location;
  final String status;
  final String? documentUrl;
  final String? logo;
  final String? establishmentDate;

  const AdminCompanyRequestEntity({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.companyName,
    required this.ownerName,
    required this.email,
    required this.location,
    required this.status,
    this.documentUrl,
    this.logo,
    this.establishmentDate,
  });

  bool get isPending =>
      status.toLowerCase().contains('pending') ||
      status.toLowerCase() == 'pending_review';
}
