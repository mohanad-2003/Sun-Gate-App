class UpdateCompanyRequestDto {
  final String? ownerName;
  final String? address;
  final String? phone;
  final String? description;
  final String? establishmentDate;

  const UpdateCompanyRequestDto({
    this.ownerName,
    this.address,
    this.phone,
    this.description,
    this.establishmentDate,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (ownerName != null && ownerName!.trim().isNotEmpty) {
      map['ownerName'] = ownerName!.trim();
    }
    if (address != null && address!.trim().isNotEmpty) {
      map['address'] = address!.trim();
    }
    if (phone != null && phone!.trim().isNotEmpty) {
      map['phone'] = phone!.trim();
    }
    if (description != null && description!.trim().isNotEmpty) {
      map['description'] = description!.trim();
    }
    if (establishmentDate != null && establishmentDate!.trim().isNotEmpty) {
      map['dateOfEstablishment'] = establishmentDate!.trim();
    }
    return map;
  }
}
