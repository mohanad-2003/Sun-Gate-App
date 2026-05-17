/// Backend: `PATCH /api/admin/company-requests/{id}/confirm-payment`
/// Body: `{ "plan": "free" | "monthly" }`
class ConfirmCompanyPaymentDto {
  final String plan;

  const ConfirmCompanyPaymentDto({required this.plan});

  Map<String, dynamic> toJson() => {'plan': plan};
}
