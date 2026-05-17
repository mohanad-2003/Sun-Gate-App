import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/admin/domain/entities/admin_dashboard_stats_entity.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_message_banner.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_section_header.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_stat_card.dart';
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final adminName = profile?.displasyName ?? (isArabic ? 'مدير' : 'Admin');

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(adminControllerProvider.notifier).loadDashboard(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'مرحباً،' : 'Hi,',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          adminName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic
                              ? 'إدارة التطبيق من لوحة التحكم'
                              : 'Manage the app from your dashboard',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push(RouteNames.notifications),
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: isArabic ? 'بحث...' : 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AdminSectionHeader(
                title: isArabic ? 'التقارير' : 'Report',
              ),
              const SizedBox(height: 12),
              AdminMessageBanner(
                errorMessage: state.errorMessage,
                successMessage: state.successMessage,
              ),
              if (state.isLoading && state.stats == AdminDashboardStatsEntity.empty)
                const SizedBox(
                  height: 220,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SizedBox(
                  height: 220,
                  child: GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.15,
                    ),
                    children: [
                      AdminStatCard(
                        label: isArabic ? 'المستخدمون' : 'Users',
                        value: '${state.stats.usersCount}',
                        icon: Icons.person_outline,
                        color: const Color(0xFF274777),
                      ),
                      AdminStatCard(
                        label: isArabic ? 'الشركات' : 'Companies',
                        value: '${state.stats.companiesCount}',
                        icon: Icons.business_outlined,
                        color: const Color(0xFFE53935),
                      ),
                      AdminStatCard(
                        label: isArabic ? 'المنتجات' : 'Products',
                        value: '${state.stats.productsCount}',
                        icon: Icons.inventory_2_outlined,
                        color: const Color(0xFF039BE5),
                        onTap: () => context.push(RouteNames.adminProducts),
                      ),
                      AdminStatCard(
                        label: isArabic ? 'طلبات جديدة' : 'New Requests',
                        value: '${state.stats.pendingRequestsCount}',
                        icon: Icons.mark_email_unread_outlined,
                        color: const Color(0xFFFF9800),
                        onTap: () => context.push(RouteNames.adminRequests),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              AdminSectionHeader(
                title: isArabic ? 'إجراءات سريعة' : 'Quick actions',
              ),
              const SizedBox(height: 10),
              _QuickActionTile(
                icon: Icons.engineering_outlined,
                title: isArabic
                    ? 'المهندسون (${state.stats.engineersCount})'
                    : 'Engineers (${state.stats.engineersCount})',
                subtitle: isArabic
                    ? 'عرض أرقام واتساب المهندسين'
                    : 'View engineer WhatsApp numbers',
                onTap: () => context.push(RouteNames.adminUsers),
              ),
              _QuickActionTile(
                icon: Icons.delete_outline,
                title: isArabic ? 'إدارة المنتجات' : 'Manage products',
                subtitle: isArabic
                    ? 'حذف المنتجات غير المناسبة'
                    : 'Remove inappropriate products',
                onTap: () => context.push(RouteNames.adminProducts),
              ),
              _QuickActionTile(
                icon: Icons.edit_note_outlined,
                title: isArabic ? 'تعديل المحتوى' : 'Edit information',
                subtitle: isArabic
                    ? 'مقالات وتعليمات المنصة'
                    : 'Platform articles & guides',
                onTap: () => context.push(RouteNames.adminArticles),
              ),
            ],
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF274777).withValues(alpha: 0.1),
          child: Icon(icon, color: const Color(0xFF274777)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
