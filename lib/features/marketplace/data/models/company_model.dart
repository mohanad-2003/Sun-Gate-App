import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.id,
    required super.companyName,
    required super.ownerName,
    required super.email,
    required super.address,
    required super.phone,
    super.description,
    super.engineerNumber,
    super.establishmentDate,
    super.logo,
    super.createAt,
    super.updateAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      ownerName: json['ownerName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address:
          json['address']?.toString() ??
          json['location']?.toString() ??
          json['companyLocation']?.toString() ??
          '',
      phone: json['phone']?.toString() ?? '',
      description:
          json['description']?.toString() ??
          json['about']?.toString() ??
          json['bio']?.toString(),
      engineerNumber:
          json['engineerNumber']?.toString() ??
          json['engineersNumber']?.toString() ??
          json['engineerPhone']?.toString() ??
          json['phoneWhatsapp']?.toString() ??
          json['whatsAppNumber']?.toString(),
      establishmentDate:
          json['establishmentDate']?.toString() ??
          json['dateOfEstablishment']?.toString(),
      logo: json['logo']?.toString(),
      createAt:
          json['createAt']?.toString() ?? json['createdAt']?.toString(),
      updateAt:
          json['updateAt']?.toString() ?? json['updatedAt']?.toString(),
    );
  }
}
