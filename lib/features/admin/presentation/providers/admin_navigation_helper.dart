import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/admin/presentation/controllers/admin_controller.dart';
import 'package:sun_gate_app/features/admin/presentation/providers/admin_account_filter_provider.dart';
import 'package:sun_gate_app/features/admin/presentation/screens/admin_main_navigation_screen.dart';

void openAdminAccountsTab(
  WidgetRef ref, {
  String? roleFilter,
}) {
  ref.read(adminAccountRoleFilterProvider.notifier).state = roleFilter;
  ref.read(adminBottomNavProvider.notifier).state = 2;
  ref.read(adminControllerProvider.notifier).loadAccounts();
}

void openAdminRequestsTab(WidgetRef ref) {
  ref.read(adminBottomNavProvider.notifier).state = 1;
  ref.read(adminControllerProvider.notifier).loadCompanyRequests();
}
