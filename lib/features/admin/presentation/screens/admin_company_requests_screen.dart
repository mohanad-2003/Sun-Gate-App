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
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(adminControllerProvider.notifier).loadCompanyRequests(),
    );
  }

  Future<void> _approveRequest(
    BuildContext context,
    String requestId,
    bool isArabic,
  ) async {
    final plans = ['basic', 'standard', 'premium', 'annual'];
    var selectedPlan = plans[1];
    var startDate = DateTime.now();
    var endDate = DateTime.now().add(const Duration(days: 365));

    final approved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                isArabic ? 'تأكيد الاشتراك' : 'Confirm subscription',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedPlan,
                    decoration: InputDecoration(
                      labelText: isArabic ? 'خطة الاشتراك' : 'Subscription plan',
                    ),
                    items: plans
                        .map(
                          (plan) => DropdownMenuItem(
                            value: plan,
                            child: Text(plan),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setDialogState(() => selectedPlan = value);
                    },
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(isArabic ? 'تاريخ البداية' : 'Start date'),
                    subtitle: Text(
                      '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() => startDate = picked);
                      }
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(isArabic ? 'تاريخ النهاية' : 'End date'),
                    subtitle: Text(
                      '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}',
                    ),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate,
                        firstDate: startDate,
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() => endDate = picked);
                      }
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
                  child: Text(isArabic ? 'موافقة' : 'Approve'),
                ),
              ],
            );
          },
        );
      },
    );

    if (approved == true && mounted) {
      await ref.read(adminControllerProvider.notifier).confirmCompanyRequest(
            requestId: requestId,
            plan: selectedPlan,
            startDate: startDate,
            endDate: endDate,
          );
    }
  }

  Future<void> _sendPaymentEmail(AdminCompanyRequestEntity request) async {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final subject = Uri.encodeComponent(
      isArabic ? 'رسوم اشتراك SunGate' : 'SunGate subscription fee',
    );
    final body = Uri.encodeComponent(
      isArabic
          ? 'مرحباً ${request.ownerName}،\n\nيرجى دفع رسوم الاشتراك. كما نطلب إنشاء حساب للمهندس المسجل على النظام.\n\nشكراً.'
          : 'Hello ${request.ownerName},\n\nPlease pay the subscription fee. We also request an engineer account to be registered on the system.\n\nThank you.',
    );
    final uri = Uri.parse(
      'mailto:${request.email}?subject=$subject&body=$body',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الطلبات' : 'Requests'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(adminControllerProvider.notifier).loadCompanyRequests(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            AdminMessageBanner(
              errorMessage: state.errorMessage,
              successMessage: state.successMessage,
            ),
            if (state.isLoading)
              const SizedBox(
                height: 280,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.companyRequests.isEmpty)
              SizedBox(
                height: 280,
                child: Center(
                  child: Text(
                    isArabic ? 'لا توجد طلبات' : 'No requests found',
                  ),
                ),
              )
            else
              ...state.companyRequests.map((request) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.companyName.isNotEmpty
                              ? request.companyName
                              : request.ownerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(request.email),
                        const SizedBox(height: 4),
                        Text(
                          request.location.isNotEmpty
                              ? request.location
                              : (isArabic ? 'الموقع غير متوفر' : 'No location'),
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(request.status),
                          backgroundColor: request.isPending
                              ? Colors.orange.withValues(alpha: 0.15)
                              : Colors.green.withValues(alpha: 0.15),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton.filledTonal(
                              onPressed: state.isSaving
                                  ? null
                                  : () => _sendPaymentEmail(request),
                              icon: const Icon(Icons.mail_outline),
                              tooltip: isArabic ? 'إرسال بريد' : 'Send email',
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: state.isSaving
                                  ? null
                                  : () => _approveRequest(
                                      context,
                                      request.id,
                                      isArabic,
                                    ),
                              icon: const Icon(Icons.check),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: state.isSaving
                                  ? null
                                  : () async {
                                      await ref
                                          .read(
                                            adminControllerProvider.notifier,
                                          )
                                          .rejectCompanyRequest(request.id);
                                    },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
