import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_dashboard_stats_entity.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_message_banner.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_section_header.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_stat_card.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_ui_kit.dart';
import 'package:sun_gate_app/features/admin/presentation/providers/admin_navigation_helper.dart';
import 'package:sun_gate_app/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminControllerProvider.notifier).loadDashboard();
      ref.read(profileControllerProvider.notifier).getMyProfile();
      ref.read(notificationControllerProvider.notifier).loadUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminControllerProvider);
    final profile = ref.watch(profileControllerProvider).profile;
    final unreadCount = ref.watch(notificationControllerProvider).unreadCount;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final adminName = profile?.displasyName ?? (isArabic ? 'مدير النظام' : 'Admin');

    return Scaffold(
      body: SafeArea(
        child: AdminScreenContainer(
          child: RefreshIndicator(
            onRefresh: () =>
                ref.read(adminControllerProvider.notifier).loadDashboard(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                AdminHeroBanner(
                  eyebrow: isArabic ? 'لوحة التحكم' : 'Admin workspace',
                  title: adminName,
                  subtitle: isArabic
                      ? 'تابع المؤشرات، راجع الطلبات، وأدر المنصة من مكان واحد.'
                      : 'Track metrics, review requests, and manage the platform from one place.',
                  icon: Icons.shield_outlined,
                  notificationCount: unreadCount,
                  onNotificationsTap: () =>
                      context.push(RouteNames.notifications),
                  footer: [
                    AdminHeroMetric(
                      label: isArabic ? 'المستخدمون' : 'Users',
                      value: '${state.stats.usersCount}',
                      icon: Icons.people_outline_rounded,
                    ),
                    const SizedBox(width: 10),
                    AdminHeroMetric(
                      label: isArabic ? 'طلبات جديدة' : 'New requests',
                      value: '${state.stats.pendingRequestsCount}',
                      icon: Icons.inbox_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AdminSectionHeader(
                  title: isArabic ? 'المؤشرات الرئيسية' : 'Key metrics',
                ),
                const SizedBox(height: 12),
                AdminMessageBanner(
                  errorMessage: state.errorMessage,
                  successMessage: state.successMessage,
                ),
                if (state.isLoading &&
                    state.stats == AdminDashboardStatsEntity.empty)
                  const SizedBox(
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          mainAxisExtent: 136,
                        ),
                    children: [
                        AdminStatCard(
                          label: isArabic ? 'المستخدمون' : 'Users',
                          value: '${state.stats.usersCount}',
                          icon: Icons.person_outline,
                          color: const Color(0xFF274777),
                          onTap: () => openAdminAccountsTab(ref, roleFilter: 'user'),
                        ),
                        AdminStatCard(
                          label: isArabic ? 'المهندسون' : 'Engineers',
                          value: '${state.stats.engineersCount}',
                          icon: Icons.engineering_outlined,
                          color: const Color(0xFF6A1B9A),
                          onTap: () =>
                              openAdminAccountsTab(ref, roleFilter: 'engineer'),
                        ),
                        AdminStatCard(
                          label: isArabic ? 'الشركات' : 'Companies',
                          value: '${state.stats.companiesCount}',
                          icon: Icons.business_outlined,
                          color: const Color(0xFFE53935),
                          onTap: () =>
                              openAdminAccountsTab(ref, roleFilter: 'company'),
                        ),
                        AdminStatCard(
                          label: isArabic ? 'طلبات جديدة' : 'New requests',
                          value: '${state.stats.pendingRequestsCount}',
                          icon: Icons.mark_email_unread_outlined,
                          color: const Color(0xFFFF9800),
                          onTap: () => openAdminRequestsTab(ref),
                        ),
                        AdminStatCard(
                          label: isArabic ? 'المنتجات' : 'Products',
                          value: '${state.stats.productsCount}',
                          icon: Icons.inventory_2_outlined,
                          color: const Color(0xFF039BE5),
                          onTap: () => context.push(RouteNames.adminProducts),
                        ),
                        AdminStatCard(
                          label: isArabic ? 'كل الحسابات' : 'All accounts',
                          value:
                              '${state.stats.usersCount + state.stats.engineersCount + state.stats.companiesCount}',
                          icon: Icons.manage_accounts_outlined,
                          color: const Color(0xFF00897B),
                          onTap: () => openAdminAccountsTab(ref),
                        ),
                      ],
                  ),
                const SizedBox(height: 20),
                AdminSectionHeader(
                  title: isArabic ? 'إجراءات سريعة' : 'Quick actions',
                ),
                const SizedBox(height: 10),
                _QuickActionTile(
                  icon: Icons.manage_accounts_outlined,
                  title: isArabic ? 'إدارة كل الحسابات' : 'Manage all accounts',
                  subtitle: isArabic
                      ? 'مستخدمون، مهندسون، وشركات — تفعيل، إيقاف، وحذف'
                      : 'Users, engineers, and companies — activate, suspend, or delete',
                  onTap: () => openAdminAccountsTab(ref),
                ),
                _QuickActionTile(
                  icon: Icons.delete_outline,
                  title: isArabic ? 'إدارة المنتجات' : 'Manage products',
                  subtitle: isArabic
                      ? 'إزالة المنتجات غير المناسبة بسرعة'
                      : 'Remove inappropriate products quickly',
                  onTap: () => context.push(RouteNames.adminProducts),
                ),
                _QuickActionTile(
                  icon: Icons.edit_note_outlined,
                  title: isArabic ? 'تعديل المحتوى' : 'Edit information',
                  subtitle: isArabic
                      ? 'إدارة المقالات والتعليمات الخاصة بالمنصة'
                      : 'Manage platform articles and guidance',
                  onTap: () => context.push(RouteNames.adminArticles),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AdminPanel(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF274777).withValues(alpha: 0.1),
            child: Icon(icon, color: const Color(0xFF274777)),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      ),
    );
  }
}
