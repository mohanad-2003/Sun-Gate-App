class CreateCompanyRequestDto {
  final String ownerName;
  final String address;
  final String phone;

  const CreateCompanyRequestDto({
    required this.ownerName,
    required this.address,
    required this.phone,
  });
  Map<String, dynamic> toJson() {
    return {
      'ownerName': ownerName.trim(),
      'address': address.trim(),
      'phone': phone.trim(),
    };
  }
}
