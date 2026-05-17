import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/theme/theme_mode_provider.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_ui_kit.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/logout_conformation_dialog.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/profile_menu_title.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/profile_section_label.dart';

class AdminProfileScreen extends ConsumerStatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  ConsumerState<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends ConsumerState<AdminProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(profileControllerProvider.notifier).getMyProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;
    final loc = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDarkMode = ref.watch(appThemeModeProvider) == ThemeMode.dark;

    return Scaffold(
      body: SafeArea(
        child: AdminScreenContainer(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AdminHeroBanner(
                eyebrow: isArabic ? 'الحساب الإداري' : 'Admin account',
                title: profile?.displasyName ?? (isArabic ? 'الملف الشخصي' : 'Profile'),
                subtitle: isArabic
                    ? 'تحكم بمعلومات الحساب، الإعدادات، وسياسات الاستخدام من مكان واحد.'
                    : 'Control account details, settings, and policy shortcuts from one place.',
                icon: Icons.admin_panel_settings_outlined,
              ),
              const SizedBox(height: 18),
              if (profile != null)
                ProfileHeaderCard(
                  name: profile.displasyName,
                  email: profile.email,
                  imageUrl: profile.imageUrl ?? profile.profileImage,
                  onEditTap: () => context.push(RouteNames.userInfo),
                ),
              const SizedBox(height: 20),
              AdminPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileSectionLabel(title: loc.security),
                    const SizedBox(height: 8),
                    ProfileMenuTile(
                      icon: Icons.person_outline,
                      title: loc.userInfo,
                      onTap: () => context.push(RouteNames.userInfo),
                    ),
                    ProfileMenuTile(
                      icon: Icons.lock_outline,
                      title: loc.changePassword,
                      onTap: () => context.push(RouteNames.changePassword),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AdminPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileSectionLabel(title: loc.about),
                    const SizedBox(height: 8),
                    ProfileMenuTile(
                      icon: Icons.policy_outlined,
                      title: loc.legal_and_policies,
                      onTap: () => context.push(RouteNames.legalPolicies),
                    ),
                    ProfileMenuTile(
                      icon: Icons.support_agent_outlined,
                      title: loc.help_and_center,
                      onTap: () => context.push(RouteNames.helpSupport),
                    ),
                    ProfileMenuTile(
                      icon: Icons.dark_mode_outlined,
                      title: loc.darkMode,
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          ref.read(appThemeModeProvider.notifier).toggleTheme(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => LogoutConfirmationDialog(
                        onConfirm: () async {
                          Navigator.of(context).pop();
                          await ref.read(authControllerProvider.notifier).logout();
                          if (context.mounted) {
                            context.go(RouteNames.login);
                          }
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: Text(loc.logOut),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
