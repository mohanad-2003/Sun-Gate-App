class ConfirmCompanyPaymentDto {
  final String plan;
  final DateTime startDate;
  final DateTime endDate;

  const ConfirmCompanyPaymentDto({
    required this.plan,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    final subscription = {
      'plan': plan,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
    };

    return {
      'plan': plan,
      'startDate': subscription['startDate'],
      'endDate': subscription['endDate'],
      'subscription': subscription,
    };
  }
}
