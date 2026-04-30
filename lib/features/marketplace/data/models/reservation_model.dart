import 'package:sun_gate_app/features/marketplace/domain/entities/reservation_entity.dart';

class ReservationModel extends ReservationEntity {
  ReservationModel({
    required super.id,
    required super.productId,
    required super.status,
    required super.finalDescision,
    required super.expiresAt,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      finalDescision: json['finalDescision']?.toString() ?? '',
      expiresAt: json['expiresAt']?.toString() ?? '',
    );
  }
}
