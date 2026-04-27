import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.id,
    required super.ownerName,
    required super.address,
    required super.phone,
    super.logo,
    super.createAt,
    super.updateAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      ownerName: json['ownerName']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      logo: json['logo']?.toString(),
      createAt: json['createAt']?.toString(),
      updateAt: json['updateAt']?.toString(),
    );
  }
}
