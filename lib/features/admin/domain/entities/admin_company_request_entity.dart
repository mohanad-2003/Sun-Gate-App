import 'package:sun_gate_app/features/admin/domain/entities/admin_company_subscription_entity.dart';

class AdminCompanyRequestEntity {
  final String id;
  final String? userId;
  final String? companyId;
  final String companyName;
  final String ownerName;
  final String email;
  final String phone;
  final String location;
  final String status;
  final String? rejectionReason;
  final String? documentUrl;
  final String? logo;
  final String? establishmentDate;
  final AdminCompanySubscriptionEntity? subscription;

  const AdminCompanyRequestEntity({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.companyName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.location,
    required this.status,
    this.rejectionReason,
    this.documentUrl,
    this.logo,
    this.establishmentDate,
    this.subscription,
  });

  String get normalizedStatus => status.trim().toLowerCase();

  bool get isPendingReview => normalizedStatus == 'pending_review';

  bool get isPaymentPending => normalizedStatus == 'payment_pending';

  bool get isActive => normalizedStatus == 'active';

  bool get isRejected => normalizedStatus == 'rejected';

  bool get needsAdminAction => isPendingReview || isPaymentPending;
}
