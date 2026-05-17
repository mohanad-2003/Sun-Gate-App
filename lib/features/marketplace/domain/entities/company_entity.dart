class CompanyEntity {
  final String id;
  final String companyName;
  final String ownerName;
  final String email;
  final String address;
  final String phone;
  final String? description;
  final String? engineerNumber;
  final String? establishmentDate;
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
    this.description,
    this.engineerNumber,
    this.establishmentDate,
    this.logo,
    this.createAt,
    this.updateAt,
  });

  CompanyEntity copyWith({
    String? id,
    String? companyName,
    String? ownerName,
    String? email,
    String? address,
    String? phone,
    String? description,
    String? engineerNumber,
    String? establishmentDate,
    String? logo,
    String? createAt,
    String? updateAt,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      engineerNumber: engineerNumber ?? this.engineerNumber,
      establishmentDate: establishmentDate ?? this.establishmentDate,
      logo: logo ?? this.logo,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
    );
  }
}
