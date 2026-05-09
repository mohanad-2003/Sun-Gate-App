import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/localization/local_provider.dart';
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

  void _showLanguageBottomSheet(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
    Locale? currentLocale,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  loc.chooseLanguage,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(loc.english),
                  trailing: currentLocale?.languageCode == 'en'
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () async {
                    await ref.read(appLocaleProvider.notifier).setEnglish();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(loc.arabic),
                  trailing: currentLocale?.languageCode == 'ar'
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () async {
                    await ref.read(appLocaleProvider.notifier).setArabic();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;
    final currentThemeMode = ref.watch(appThemeModeProvider);
    final isDarkMode = currentThemeMode == ThemeMode.dark;
    final loc = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(appLocaleProvider);

    final currentLanguageText = currentLocale?.languageCode == 'ar'
        ? loc.arabic
        : loc.english;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(loc.profile),
        centerTitle: true,
      ),
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
                          imageUrl: profile.imageUrl?.isNotEmpty == true
                              ? profile.imageUrl
                              : profile.profileImage?.isNotEmpty == true
                              ? profile.profileImage
                              : profileState.googlePhoto,
                          onEditTap: () => context.push(RouteNames.userInfo),
                        )
                      else
                        ProfileHeaderCard(
                          name: loc.userName,
                          email: loc.userEmail,
                          imageUrl: null,
                          onEditTap: () => context.push(RouteNames.userInfo),
                        ),

                      const SizedBox(height: 28),

                      ProfileSectionLabel(title: loc.security),
                      const SizedBox(height: 8),
                      ProfileMenuTile(
                        icon: Icons.lock_outline_rounded,
                        title: loc.changePassword,
                        onTap: () => context.push(RouteNames.changePassword),
                      ),

                      const SizedBox(height: 18),

                      ProfileSectionLabel(title: loc.about),
                      const SizedBox(height: 8),
                      ProfileMenuTile(
                        icon: Icons.language_outlined,
                        title: loc.language,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentLanguageText,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                            ),
                          ],
                        ),
                        onTap: () => _showLanguageBottomSheet(
                          context,
                          ref,
                          loc,
                          currentLocale,
                        ),
                      ),
                      ProfileMenuTile(
                        icon: Icons.shield_outlined,
                        title: loc.legal_and_policies,
                        onTap: () => context.push(RouteNames.legalPolicies),
                      ),
                      ProfileMenuTile(
                        icon: Icons.help_outline_rounded,
                        title: loc.help_and_center,
                        onTap: () => context.push(RouteNames.helpSupport),
                      ),
                      ProfileMenuTile(
                        icon: isDarkMode
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        title: loc.darkMode,
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
                          child: Text(loc.logOut),
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
