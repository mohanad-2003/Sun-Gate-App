class UpdateCompanyRequestDto {
  final String? ownerName;
  final String? address;
  final String? phone;

  const UpdateCompanyRequestDto({this.ownerName, this.address, this.phone});

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
    return map;
  }
}
