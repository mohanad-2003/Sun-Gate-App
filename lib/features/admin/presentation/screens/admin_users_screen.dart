import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_account_entity.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/providers/admin_account_filter_provider.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_message_banner.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_role_filter_chips.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_ui_kit.dart';
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

  List<AdminAccountEntity> _filtered(
    List<AdminAccountEntity> accounts,
    String? roleFilter,
  ) {
    Iterable<AdminAccountEntity> results = accounts;

    if (roleFilter != null && roleFilter.isNotEmpty) {
      results = results.where(
        (account) => account.role.toLowerCase() == roleFilter.toLowerCase(),
      );
    }

    if (_query.isEmpty) return results.toList();

    return results
        .where(
          (account) =>
              account.fullName.toLowerCase().contains(_query) ||
              account.email.toLowerCase().contains(_query) ||
              account.role.toLowerCase().contains(_query),
        )
        .toList();
  }

  Map<String, int> _roleCounts(List<AdminAccountEntity> accounts) {
    var users = 0;
    var engineers = 0;
    var companies = 0;

    for (final account in accounts) {
      switch (account.role.toLowerCase()) {
        case 'engineer':
          engineers++;
          break;
        case 'company':
          companies++;
          break;
        default:
          users++;
      }
    }

    return {
      'all': accounts.length,
      'user': users,
      'engineer': engineers,
      'company': companies,
    };
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

  Future<bool?> _confirmDelete(bool isArabic) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(isArabic ? 'حذف الحساب' : 'Delete account'),
        content: Text(
          isArabic
              ? 'هل أنت متأكد؟ سيتم حذف المستخدم والملف المرتبط به.'
              : 'Are you sure? The user and linked profile will be deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(isArabic ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);
    final roleFilter = ref.watch(adminAccountRoleFilterProvider);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final allAccounts = state.accounts;
    final roleCounts = _roleCounts(allAccounts);
    final accounts = _filtered(allAccounts, roleFilter);
    final activeCount = accounts.where((account) => account.isActive).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'إدارة الحسابات' : 'Account management'),
      ),
      body: AdminScreenContainer(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(adminControllerProvider.notifier).loadAccounts(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              AdminHeroBanner(
                eyebrow: isArabic ? 'الحسابات' : 'Accounts',
                title: isArabic ? 'إدارة الحسابات' : 'Account management',
                subtitle: isArabic
                    ? 'تحكم بكل المسجلين: مستخدمون عاديون، مهندسون، وشركات.'
                    : 'Control every registered account: users, engineers, and companies.',
                icon: Icons.groups_2_outlined,
                footer: [
                  AdminHeroMetric(
                    label: isArabic ? 'المعروضة' : 'Showing',
                    value: '${accounts.length}',
                    icon: Icons.filter_list_rounded,
                  ),
                  const SizedBox(width: 10),
                  AdminHeroMetric(
                    label: isArabic ? 'النشطة' : 'Active',
                    value: '$activeCount',
                    icon: Icons.verified_user_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AdminRoleFilterChips(
                selectedRole: roleFilter,
                isArabic: isArabic,
                counts: roleCounts,
                onSelected: (role) {
                  ref.read(adminAccountRoleFilterProvider.notifier).state =
                      role;
                },
              ),
              const SizedBox(height: 14),
              AdminSearchField(
                controller: _searchController,
                hintText: isArabic ? 'ابحث بالاسم أو البريد أو الدور' : 'Search by name, email, or role',
              ),
              const SizedBox(height: 12),
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
                AdminEmptyState(
                  icon: Icons.people_outline,
                  title: isArabic ? 'لا توجد حسابات' : 'No accounts found',
                  subtitle: isArabic
                      ? 'ستظهر هنا حسابات المستخدمين عند توفرها.'
                      : 'User accounts will appear here when available.',
                )
              else
                ...accounts.map((account) {
                  final whatsapp = account.phoneWhatsapp?.trim() ?? '';
                  final statusColor = account.isActive
                      ? const Color(0xFF1F9D55)
                      : const Color(0xFFE58A00);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AdminPanel(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.12),
                                child: Text(
                                  _initial(account.fullName),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
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
                                      account.fullName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(account.email),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AdminBadge(
                                    label: _roleLabel(account.role, isArabic),
                                    color: _roleColor(account.role),
                                  ),
                                  const SizedBox(height: 6),
                                  AdminBadge(
                                    label: account.accountStatus,
                                    color: statusColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _MetaTile(
                                  icon: Icons.badge_outlined,
                                  label: isArabic ? 'الدور' : 'Role',
                                  value: account.role,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _MetaTile(
                                  icon: Icons.chat_bubble_outline,
                                  label: 'WhatsApp',
                                  value: whatsapp.isEmpty ? '--' : whatsapp,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              if (whatsapp.isNotEmpty)
                                OutlinedButton.icon(
                                  onPressed: () => _openWhatsApp(whatsapp),
                                  icon: const Icon(Icons.chat),
                                  label: const Text('WhatsApp'),
                                ),
                              if (!account.isActive)
                                FilledButton.tonalIcon(
                                  onPressed: state.isSaving
                                      ? null
                                      : () => ref
                                            .read(
                                              adminControllerProvider.notifier,
                                            )
                                            .activateAccount(account.id),
                                  icon: const Icon(Icons.check_circle_outline),
                                  label: Text(isArabic ? 'تفعيل' : 'Activate'),
                                ),
                              if (account.isActive)
                                FilledButton.tonalIcon(
                                  onPressed: state.isSaving
                                      ? null
                                      : () => ref
                                            .read(
                                              adminControllerProvider.notifier,
                                            )
                                            .suspendAccount(account.id),
                                  icon: const Icon(Icons.pause_circle_outline),
                                  label: Text(isArabic ? 'إيقاف' : 'Suspend'),
                                  style: FilledButton.styleFrom(
                                    foregroundColor: const Color(0xFFE58A00),
                                    backgroundColor: const Color(
                                      0xFFE58A00,
                                    ).withValues(alpha: 0.12),
                                  ),
                                ),
                              FilledButton.tonalIcon(
                                onPressed: state.isSaving
                                    ? null
                                    : () async {
                                        final confirmed =
                                            await _confirmDelete(isArabic);
                                        if (confirmed == true && mounted) {
                                          await ref
                                              .read(
                                                adminControllerProvider.notifier,
                                              )
                                              .deleteAccount(account.id);
                                        }
                                      },
                                icon: const Icon(Icons.delete_outline),
                                label: Text(isArabic ? 'حذف' : 'Delete'),
                                style: FilledButton.styleFrom(
                                  foregroundColor: const Color(0xFFC62828),
                                  backgroundColor: const Color(
                                    0xFFC62828,
                                  ).withValues(alpha: 0.12),
                                ),
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
      ),
    );
  }
}

String _initial(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return 'U';
  return trimmed.substring(0, 1).toUpperCase();
}

String _roleLabel(String role, bool isArabic) {
  switch (role.toLowerCase()) {
    case 'engineer':
      return isArabic ? 'مهندس' : 'Engineer';
    case 'company':
      return isArabic ? 'شركة' : 'Company';
    case 'admin':
      return isArabic ? 'أدمن' : 'Admin';
    default:
      return isArabic ? 'مستخدم' : 'User';
  }
}

Color _roleColor(String role) {
  switch (role.toLowerCase()) {
    case 'engineer':
      return const Color(0xFF6A1B9A);
    case 'company':
      return const Color(0xFFE53935);
    case 'admin':
      return const Color(0xFF274777);
    default:
      return const Color(0xFF00897B);
  }
}

class _MetaTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
