class CreateReservationRequestDto {
  final String productId;
  final String expiresAt;

  const CreateReservationRequestDto({
    required this.productId,
    required this.expiresAt,
  });
  Map<String, dynamic> toJson() {
    return {'productId': productId, 'expiresAt': expiresAt};
  }
}
