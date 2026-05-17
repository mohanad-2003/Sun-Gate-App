import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/features/admin/presentation/screens/admin_articles_screen.dart';
import 'package:sun_gate_app/features/admin/presentation/screens/admin_company_requests_screen.dart';
import 'package:sun_gate_app/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:sun_gate_app/features/admin/presentation/screens/admin_profile_screen.dart';
import 'package:sun_gate_app/features/admin/presentation/screens/admin_users_screen.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_bottom_nav_bar.dart';

final adminBottomNavProvider = StateProvider<int>((ref) => 0);

class AdminMainNavigationScreen extends ConsumerWidget {
  const AdminMainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(adminBottomNavProvider);
    const pages = [
      AdminDashboardScreen(),
      AdminCompanyRequestsScreen(),
      AdminUsersScreen(),
      AdminArticlesScreen(),
      AdminProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: AdminBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(adminBottomNavProvider.notifier).state = index,
      ),
    );
  }
}
