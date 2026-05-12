class CompanyEntity {
  final String id;
  final String companyName;
  final String ownerName;
  final String email;
  final String address;
  final String phone;
  final String? logo;
  final String? createAt;
  final String? updateAt;

  const CompanyEntity({
    required this.id,
    required this.companyName,
    required this.ownerName,
    required this.email,
    required this.address,
    required this.phone,
    this.logo,
    this.createAt,
    this.updateAt,
  });
}
