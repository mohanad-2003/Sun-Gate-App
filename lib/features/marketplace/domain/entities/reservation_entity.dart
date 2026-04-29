class ReservationEntity {
  final String id;
  final String productId;
  final String status;
  final String finalDescision;
  final String expiresAt;

  const ReservationEntity({
    required this.id,
    required this.productId,
    required this.status,
    required this.finalDescision,
    required this.expiresAt,
  });
}
