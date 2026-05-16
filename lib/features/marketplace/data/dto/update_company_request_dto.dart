class UpdateCompanyRequestDto {
  final String? companyName;
  final String? ownerName;
  final String? email;
  final String? address;
  final String? phone;
  final String? establishmentDate;

  const UpdateCompanyRequestDto({
    this.companyName,
    this.ownerName,
    this.email,
    this.address,
    this.phone,
    this.establishmentDate,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (companyName != null && companyName!.trim().isNotEmpty) {
      map['companyName'] = companyName!.trim();
    }
    if (ownerName != null && ownerName!.trim().isNotEmpty) {
      map['ownerName'] = ownerName!.trim();
    }
    if (email != null && email!.trim().isNotEmpty) {
      map['email'] = email!.trim();
    }
    if (address != null && address!.trim().isNotEmpty) {
      map['address'] = address!.trim();
    }
    if (phone != null && phone!.trim().isNotEmpty) {
      map['phone'] = phone!.trim();
    }
    if (establishmentDate != null && establishmentDate!.trim().isNotEmpty) {
      map['establishmentDate'] = establishmentDate!.trim();
    }
    return map;
  }
}
