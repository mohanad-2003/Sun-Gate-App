import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/theme/theme_mode_provider.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/logout_conformation_dialog.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/profile_header_card.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/profile_menu_title.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/profile_section_label.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(profileControllerProvider.notifier).getMyProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;
    final currentThemeMode = ref.watch(appThemeModeProvider);
    final isDarkMode = currentThemeMode == ThemeMode.dark;
    return Scaffold(
      body: SafeArea(
        child: profileState.isLoading && profile == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profile != null)
                        ProfileHeaderCard(
                          name: profile.displasyName,
                          email: profile.email,
                          imageUrl: profile.imageUrl ?? profile.profileImage,
                          onEditTap: () => context.push(RouteNames.userInfo),
                        )
                      else
                        ProfileHeaderCard(
                          name: 'User Name',
                          email: 'user@example.com',
                          imageUrl: null,
                          onEditTap: () => context.push(RouteNames.userInfo),
                        ),

                      const SizedBox(height: 28),

                      const ProfileSectionLabel(title: 'Security'),
                      const SizedBox(height: 8),
                      ProfileMenuTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change Password',
                        onTap: () => context.push(RouteNames.changePassword),
                      ),

                      const SizedBox(height: 18),

                      const ProfileSectionLabel(title: 'About'),
                      const SizedBox(height: 8),
                      ProfileMenuTile(
                        icon: Icons.shield_outlined,
                        title: 'Legal and Policies',
                        onTap: () => context.push(RouteNames.legalPolicies),
                      ),
                      ProfileMenuTile(
                        icon: Icons.help_outline_rounded,
                        title: 'Help & Support',
                        onTap: () => context.push(RouteNames.helpSupport),
                      ),
                      ProfileMenuTile(
                        icon: isDarkMode
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        title: 'Dark Mode',
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (value) async {
                            ref
                                .read(appThemeModeProvider.notifier)
                                .toggleTheme(value);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (profileState.errorMessage != null &&
                          profileState.errorMessage!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.20),
                            ),
                          ),
                          child: Text(
                            profileState.errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => LogoutConfirmationDialog(
                                onConfirm: () async {
                                  Navigator.of(context).pop();

                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .logout();

                                  if (context.mounted) {
                                    context.go(RouteNames.login);
                                  }
                                },
                              ),
                            );
                          },
                          child: const Text('Log out'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
