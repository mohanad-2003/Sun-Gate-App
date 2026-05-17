import 'package:sun_gate_app/features/admin/domain/entities/admin_account_entity.dart';

class AdminAccountModel extends AdminAccountEntity {
  const AdminAccountModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.role,
    required super.accountStatus,
    super.phoneWhatsapp,
    super.location,
    super.profileImageUrl,
  });

  factory AdminAccountModel.fromJson(Map<String, dynamic> json) {
    final fullName = json['fullName']?.toString().trim() ?? '';
    final companyName = json['companyName']?.toString().trim() ?? '';
    final ownerName = json['ownerName']?.toString().trim() ?? '';
    final displayName = fullName.isNotEmpty
        ? fullName
        : companyName.isNotEmpty
        ? companyName
        : ownerName;

    return AdminAccountModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      fullName: displayName.isNotEmpty ? displayName : 'Account',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'user',
      accountStatus: json['accountStatus']?.toString() ?? 'active',
      phoneWhatsapp:
          json['phoneWhatsapp']?.toString() ??
          json['whatsappNumbers']?.toString(),
      location: json['location']?.toString(),
      profileImageUrl:
          json['profileImageUrl']?.toString() ??
          json['profileImage']?.toString(),
    );
  }
}
