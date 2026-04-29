class UpdateReservationRequestDto {
  final String status;
  final String finalDecision;

  const UpdateReservationRequestDto({
    required this.status,
    required this.finalDecision,
  });

  Map<String, dynamic> toJson() {
    return {'status': status, 'finalDecision': finalDecision};
  }
}
