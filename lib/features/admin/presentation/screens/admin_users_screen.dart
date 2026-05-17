import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_account_entity.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_message_banner.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(adminControllerProvider.notifier).loadAccounts(),
    );
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AdminAccountEntity> _filtered(List<AdminAccountEntity> accounts) {
    if (_query.isEmpty) return accounts;
    return accounts
        .where(
          (account) =>
              account.fullName.toLowerCase().contains(_query) ||
              account.email.toLowerCase().contains(_query) ||
              account.role.toLowerCase().contains(_query),
        )
        .toList();
  }

  Future<void> _openWhatsApp(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    var normalized = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (normalized.startsWith('0')) {
      normalized = '970${normalized.substring(1)}';
    }
    normalized = normalized.replaceAll('+', '');
    final uri = Uri.parse('https://wa.me/$normalized');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final accounts = _filtered(state.accounts);

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'إدارة الحسابات' : 'Edit users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: isArabic ? 'بحث...' : 'Search...',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(adminControllerProvider.notifier).loadAccounts(),
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
                  else if (accounts.isEmpty)
                    SizedBox(
                      height: 280,
                      child: Center(
                        child: Text(
                          isArabic ? 'لا توجد حسابات' : 'No accounts found',
                        ),
                      ),
                    )
                  else
                    ...accounts.map((account) {
                      final whatsapp = account.phoneWhatsapp?.trim() ?? '';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          title: Text(
                            account.fullName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(account.email),
                              Text(
                                '${account.role} • ${account.accountStatus}',
                              ),
                              if (whatsapp.isNotEmpty)
                                Text(
                                  isArabic
                                      ? 'واتساب: $whatsapp'
                                      : 'WhatsApp: $whatsapp',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (whatsapp.isNotEmpty)
                                IconButton(
                                  onPressed: () => _openWhatsApp(whatsapp),
                                  icon: const Icon(
                                    Icons.chat,
                                    color: Colors.green,
                                  ),
                                ),
                              if (!account.isActive)
                                IconButton(
                                  onPressed: state.isSaving
                                      ? null
                                      : () => ref
                                            .read(
                                              adminControllerProvider.notifier,
                                            )
                                            .activateAccount(account.id),
                                  icon: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                ),
                              if (account.isActive)
                                IconButton(
                                  onPressed: state.isSaving
                                      ? null
                                      : () => ref
                                            .read(
                                              adminControllerProvider.notifier,
                                            )
                                            .suspendAccount(account.id),
                                  icon: const Icon(
                                    Icons.pause_circle_outline,
                                    color: Colors.orange,
                                  ),
                                ),
                              IconButton(
                                onPressed: state.isSaving
                                    ? null
                                    : () async {
                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                              isArabic
                                                  ? 'حذف الحساب'
                                                  : 'Delete account',
                                            ),
                                            content: Text(
                                              isArabic
                                                  ? 'هل أنت متأكد؟ سيتم حذف المستخدم وملف المهندس/الشركة المرتبط.'
                                                  : 'Are you sure? Linked engineer/company profiles will be removed.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  false,
                                                ),
                                                child: Text(
                                                  isArabic ? 'إلغاء' : 'Cancel',
                                                ),
                                              ),
                                              FilledButton(
                                                onPressed: () => Navigator.pop(
                                                  context,
                                                  true,
                                                ),
                                                child: Text(
                                                  isArabic ? 'حذف' : 'Delete',
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (confirmed == true && mounted) {
                                          await ref
                                              .read(
                                                adminControllerProvider
                                                    .notifier,
                                              )
                                              .deleteAccount(account.id);
                                        }
                                      },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
