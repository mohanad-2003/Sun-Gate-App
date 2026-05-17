import 'package:sun_gate_app/features/admin/domain/entities/admin_company_request_entity.dart';

class AdminCompanyRequestModel extends AdminCompanyRequestEntity {
  const AdminCompanyRequestModel({
    required super.id,
    required super.userId,
    required super.companyId,
    required super.companyName,
    required super.ownerName,
    required super.email,
    required super.location,
    required super.status,
    super.documentUrl,
    super.logo,
    super.establishmentDate,
  });

  factory AdminCompanyRequestModel.fromJson(Map<String, dynamic> json) {
    final company = json['company'];
    final user = json['user'];
    final companyMap = company is Map<String, dynamic> ? company : json;
    final userMap = user is Map<String, dynamic> ? user : json;

    return AdminCompanyRequestModel(
      id: json['_id']?.toString() ??
          json['id']?.toString() ??
          companyMap['_id']?.toString() ??
          '',
      userId: json['userId']?.toString() ??
          userMap['_id']?.toString() ??
          userMap['id']?.toString(),
      companyId: json['companyId']?.toString() ??
          companyMap['_id']?.toString() ??
          companyMap['id']?.toString(),
      companyName:
          companyMap['companyName']?.toString() ??
          json['companyName']?.toString() ??
          '',
      ownerName:
          companyMap['ownerName']?.toString() ??
          json['ownerName']?.toString() ??
          userMap['fullName']?.toString() ??
          '',
      email:
          companyMap['email']?.toString() ??
          json['email']?.toString() ??
          userMap['email']?.toString() ??
          '',
      location:
          companyMap['location']?.toString() ??
          companyMap['address']?.toString() ??
          json['location']?.toString() ??
          '',
      status:
          companyMap['status']?.toString() ??
          json['status']?.toString() ??
          'pending_review',
      documentUrl:
          companyMap['documentUrl']?.toString() ??
          json['documentUrl']?.toString(),
      logo: companyMap['logo']?.toString() ?? json['logo']?.toString(),
      establishmentDate:
          companyMap['dateOfEstablishment']?.toString() ??
          companyMap['establishmentDate']?.toString() ??
          json['dateOfEstablishment']?.toString(),
    );
  }
}
