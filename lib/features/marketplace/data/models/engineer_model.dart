import 'package:sun_gate_app/features/marketplace/domain/entities/engineer_entity.dart';

class EngineerModel extends EngineerEntity {
  const EngineerModel({
    required super.id,
    required super.companyId,
    required super.yearsOfExperience,
    required super.certificate,
    required super.rating,
  });

  factory EngineerModel.fromJson(Map<String, dynamic> json) {
    return EngineerModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      yearsOfExperience: (json['yearsOfExperience'] as num?)?.toInt() ?? 0,
      certificate: json['cartificate']?.toString() ?? '',
      rating: (json['rating'] as double?)?.toDouble() ?? 0,
    );
  }
}
