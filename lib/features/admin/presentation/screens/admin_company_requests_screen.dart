import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_company_request_entity.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_message_banner.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminCompanyRequestsScreen extends ConsumerStatefulWidget {
  const AdminCompanyRequestsScreen({super.key});

  @override
  ConsumerState<AdminCompanyRequestsScreen> createState() =>
      _AdminCompanyRequestsScreenState();
}

class _AdminCompanyRequestsScreenState
    extends ConsumerState<AdminCompanyRequestsScreen> {
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadRequests);
  }

  Future<void> _loadRequests() {
    return ref
        .read(adminControllerProvider.notifier)
        .loadCompanyRequests(status: _statusFilter);
  }

  Future<void> _approveForPayment(
    AdminCompanyRequestEntity request,
    bool isArabic,
  ) async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          isArabic ? 'الموافقة وإرسال الدفع' : 'Approve & send payment',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          isArabic
              ? 'سيتم نقل الطلب إلى "بانتظار الدفع" وإرسال تعليمات الدفع إلى ${request.email}. هل تريد المتابعة؟'
              : 'The request will move to payment_pending and payment instructions will be emailed to ${request.email}. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(isArabic ? 'موافقة' : 'Approve'),
          ),
        ],
      ),
    );

    if (approved == true && mounted) {
      await ref
          .read(adminControllerProvider.notifier)
          .approveCompanyRequest(request.id);
    }
  }

  Future<void> _confirmPayment(
    AdminCompanyRequestEntity request,
    bool isArabic,
  ) async {
    var selectedPlan = 'monthly';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: Text(
                isArabic ? 'تأكيد الدفع' : 'Confirm payment',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic
                        ? 'اختر خطة الاشتراك لتفعيل الشركة:'
                        : 'Choose a subscription plan to activate the company:',
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'free',
                        label: Text(isArabic ? 'مجاني' : 'Free'),
                        icon: const Icon(Icons.card_giftcard_outlined),
                      ),
                      ButtonSegment(
                        value: 'monthly',
                        label: Text(isArabic ? 'شهري' : 'Monthly'),
                        icon: const Icon(Icons.payments_outlined),
                      ),
                    ],
                    selected: {selectedPlan},
                    onSelectionChanged: (value) {
                      if (value.isEmpty) return;
                      setDialogState(() => selectedPlan = value.first);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(isArabic ? 'تأكيد' : 'Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed == true && mounted) {
      await ref.read(adminControllerProvider.notifier).confirmCompanyPayment(
            requestId: request.id,
            plan: selectedPlan,
          );
    }
  }

  Future<void> _rejectRequest(
    AdminCompanyRequestEntity request,
    bool isArabic,
  ) async {
    final reasonController = TextEditingController();
    var reason = '';

    final rejected = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          isArabic ? 'رفض الطلب' : 'Reject request',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          onChanged: (value) => reason = value,
          decoration: InputDecoration(
            labelText: isArabic ? 'سبب الرفض (اختياري)' : 'Reason (optional)',
            hintText: isArabic
                ? 'اكتب سبب الرفض للشركة'
                : 'Write a rejection reason for the company',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(isArabic ? 'رفض' : 'Reject'),
          ),
        ],
      ),
    );

    final trimmedReason = reason.trim();
    reasonController.dispose();

    if (rejected == true && mounted) {
      await ref.read(adminControllerProvider.notifier).rejectCompanyRequest(
            requestId: request.id,
            reason: trimmedReason.isEmpty ? null : trimmedReason,
          );
    }
  }

  Future<void> _sendEmail(
    AdminCompanyRequestEntity request, {
    required bool isPaymentInstructions,
  }) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final companyName = request.companyName.isNotEmpty
        ? request.companyName
        : request.ownerName;

    final subject = Uri.encodeComponent(
      isPaymentInstructions
          ? (isArabic
              ? 'تعليمات دفع اشتراك Sun Gate'
              : 'Sun Gate subscription payment instructions')
          : (isArabic
              ? 'تأكيد استلام طلب انضمام شركتكم'
              : 'Your company request was received'),
    );

    final body = Uri.encodeComponent(
      isPaymentInstructions
          ? (isArabic
              ? 'مرحباً ${request.ownerName},\n\nتمت الموافقة على طلب شركة $companyName. يرجى إتمام دفع الاشتراك حسب التعليمات المرسلة من فريق Sun Gate.\n\nبعد استلام الدفع سنقوم بتفعيل حسابكم.\n\nمع التحية،\nفريق Sun Gate'
              : 'Hello ${request.ownerName},\n\nYour company request for $companyName was approved. Please complete the subscription payment using the instructions provided by the Sun Gate team.\n\nOnce payment is received, we will activate your account.\n\nRegards,\nSun Gate Team')
          : (isArabic
              ? 'مرحباً ${request.ownerName},\n\nتم استلام طلب انضمام $companyName وهو قيد المراجعة.\n\nمع التحية،\nفريق Sun Gate'
              : 'Hello ${request.ownerName},\n\nWe received your request for $companyName and it is under review.\n\nRegards,\nSun Gate Team'),
    );

    final uri = Uri.parse(
      'mailto:${request.email}?subject=$subject&body=$body',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final requests = state.companyRequests;
    final pendingCount =
        requests.where((request) => request.needsAdminAction).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'طلبات الشركات' : 'Company requests'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.06),
              colorScheme.surface,
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _loadRequests,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _AdminRequestsHero(
                isArabic: isArabic,
                totalCount: requests.length,
                pendingCount: pendingCount,
              ),
              const SizedBox(height: 12),
              _StatusFilterBar(
                isArabic: isArabic,
                selected: _statusFilter,
                onSelected: (value) {
                  setState(() => _statusFilter = value);
                  _loadRequests();
                },
              ),
              const SizedBox(height: 16),
              AdminMessageBanner(
                errorMessage: state.errorMessage,
                successMessage: state.successMessage,
              ),
              if (state.isLoading)
                const SizedBox(
                  height: 320,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (requests.isEmpty)
                _EmptyRequestsState(isArabic: isArabic)
              else
                ...requests.map(
                  (request) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _AdminRequestCard(
                      request: request,
                      isArabic: isArabic,
                      isSaving: state.isSaving,
                      onSendEmail: () => _sendEmail(
                        request,
                        isPaymentInstructions: request.isPaymentPending,
                      ),
                      onApprove: () =>
                          _approveForPayment(request, isArabic),
                      onConfirmPayment: () =>
                          _confirmPayment(request, isArabic),
                      onReject: () => _rejectRequest(request, isArabic),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusFilterBar extends StatelessWidget {
  final bool isArabic;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _StatusFilterBar({
    required this.isArabic,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = <String?, String>{
      null: isArabic ? 'الكل' : 'All',
      'pending_review': isArabic ? 'مراجعة' : 'Review',
      'payment_pending': isArabic ? 'دفع' : 'Payment',
      'active': isArabic ? 'نشط' : 'Active',
      'rejected': isArabic ? 'مرفوض' : 'Rejected',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((entry) {
          final isSelected = selected == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (_) => onSelected(entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AdminRequestsHero extends StatelessWidget {
  final bool isArabic;
  final int totalCount;
  final int pendingCount;

  const _AdminRequestsHero({
    required this.isArabic,
    required this.totalCount,
    required this.pendingCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [colorScheme.primary, const Color(0xFF163A6B)],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic ? 'مراجعة → دفع → تفعيل' : 'Review → Pay → Activate',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isArabic
                ? 'وافق على الطلب، ثم أكّد الدفع بعد استلامه'
                : 'Approve the request, then confirm payment when received',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: isArabic ? 'إجمالي الطلبات' : 'Total',
                  value: '$totalCount',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroMetric(
                  label: isArabic ? 'تحتاج إجراء' : 'Needs action',
                  value: '$pendingCount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.80),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminRequestCard extends StatelessWidget {
  final AdminCompanyRequestEntity request;
  final bool isArabic;
  final bool isSaving;
  final VoidCallback onSendEmail;
  final VoidCallback onApprove;
  final VoidCallback onConfirmPayment;
  final VoidCallback onReject;

  const _AdminRequestCard({
    required this.request,
    required this.isArabic,
    required this.isSaving,
    required this.onSendEmail,
    required this.onApprove,
    required this.onConfirmPayment,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final companyName = request.companyName.isNotEmpty
        ? request.companyName
        : request.ownerName;
    final plan = request.subscription?.plan;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                  child: Text(
                    companyName.isNotEmpty
                        ? companyName.substring(0, 1).toUpperCase()
                        : 'C',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        request.ownerName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: request.status),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(icon: Icons.email_outlined, label: request.email),
                if (request.phone.isNotEmpty)
                  _InfoChip(icon: Icons.phone_outlined, label: request.phone),
                if (request.location.isNotEmpty)
                  _InfoChip(
                    icon: Icons.location_on_outlined,
                    label: request.location,
                  ),
                if (plan != null && plan.isNotEmpty)
                  _InfoChip(
                    icon: Icons.card_membership_outlined,
                    label: plan,
                  ),
              ],
            ),
            if (request.rejectionReason != null &&
                request.rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '${isArabic ? 'سبب الرفض: ' : 'Rejection: '}${request.rejectionReason}',
                style: TextStyle(color: Colors.red.shade700),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: isSaving ? null : onSendEmail,
              icon: const Icon(Icons.mail_outline),
              label: Text(
                request.isPaymentPending
                    ? (isArabic ? 'بريد تعليمات الدفع' : 'Payment email')
                    : (isArabic ? 'إرسال بريد' : 'Send email'),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            if (request.isPendingReview) ...[
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: isSaving ? null : onApprove,
                icon: const Icon(Icons.verified_outlined),
                label: Text(isArabic ? 'موافقة وإرسال الدفع' : 'Approve for payment'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1F9D55),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: isSaving ? null : onReject,
                icon: const Icon(Icons.close),
                label: Text(isArabic ? 'رفض' : 'Reject'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
            if (request.isPaymentPending) ...[
              const SizedBox(height: 10),
              FilledButton.icon(
                onPressed: isSaving ? null : onConfirmPayment,
                icon: const Icon(Icons.payments_outlined),
                label: Text(isArabic ? 'تأكيد الدفع والتفعيل' : 'Confirm payment'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  Color _colorForStatus() {
    switch (status.toLowerCase()) {
      case 'pending_review':
        return const Color(0xFFE58A00);
      case 'payment_pending':
        return const Color(0xFF039BE5);
      case 'active':
        return const Color(0xFF1F9D55);
      case 'rejected':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFF607D8B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForStatus();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _EmptyRequestsState extends StatelessWidget {
  final bool isArabic;

  const _EmptyRequestsState({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Center(
        child: Text(
          isArabic ? 'لا توجد طلبات لهذا الفلتر' : 'No requests for this filter',
        ),
      ),
    );
  }
}
