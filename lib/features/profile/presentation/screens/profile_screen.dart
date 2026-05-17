import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/localization/local_provider.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/theme/theme_mode_provider.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/notifications/presentation/controllers/notification_controller.dart';
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
      ref.read(marketPlaceControllerProvider.notifier).getMyCompany();
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
                    if (context.mounted) Navigator.pop(context);
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
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations appLocal,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.red,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                appLocal.deleteAccountPermanently,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                appLocal.deleteAccountWarning,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: Colors.orange.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appLocal.deleteAccountPostsWarning,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(appLocal.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await ref
                            .read(authControllerProvider.notifier)
                            .deleteAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        appLocal.confirmDelete,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final profile = profileState.profile;
    final marketState = ref.watch(marketPlaceControllerProvider);
    final myCompany = marketState.myCompany;
    final shouldUseCompanyProfile = myCompany != null;
    final currentThemeMode = ref.watch(appThemeModeProvider);
    final isDarkMode = currentThemeMode == ThemeMode.dark;
    final loc = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(appLocaleProvider);

    final currentLanguageText = currentLocale?.languageCode == 'ar'
        ? loc.arabic
        : loc.english;

    ref.listen(authControllerProvider, (prev, next) {
      if (next.isSuccess && next.action == AuthAction.deleteAccount) {
        context.go(RouteNames.login);
      }
      if (next.errorMessage != null &&
          next.action == AuthAction.deleteAccount &&
          !(prev?.errorMessage == next.errorMessage)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(next.errorMessage!)),
              ],
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isDeleting =
        authState.isLoading && authState.action == AuthAction.deleteAccount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
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
                      if (shouldUseCompanyProfile)
                        ProfileHeaderCard(
                          name: myCompany.companyName.isNotEmpty
                              ? myCompany.companyName
                              : myCompany.ownerName,
                          email: myCompany.email.isNotEmpty
                              ? myCompany.email
                              : loc.userEmail,
                          imageUrl: myCompany.logo,
                          onEditTap: () => context.push(RouteNames.userInfo),
                        )
                      else if (profile != null)
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
                      else if (myCompany != null)
                        ProfileHeaderCard(
                          name: myCompany.companyName.isNotEmpty
                              ? myCompany.companyName
                              : myCompany.ownerName,
                          email: myCompany.email.isNotEmpty
                              ? myCompany.email
                              : loc.userEmail,
                          imageUrl: myCompany.logo,
                          onEditTap: null,
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

                      if (myCompany == null &&
                          profileState.errorMessage != null &&
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
                                  await ref
                                      .read(notificationControllerProvider.notifier)
                                      .resetDeliveryTracking();
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

                      const SizedBox(height: 12),

                      Divider(
                        color: Colors.red.withValues(alpha: 0.15),
                        thickness: 1,
                      ),

                      const SizedBox(height: 12),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red.shade400,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  loc.dangerZone,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              loc.dangerZoneDescription,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: isDeleting
                                  ? OutlinedButton(
                                      onPressed: null,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  : OutlinedButton.icon(
                                      onPressed: () => _showDeleteAccountDialog(
                                        context,
                                        ref,
                                        loc,
                                      ),

                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18,
                                      ),
                                      label: Text(
                                        loc.deleteAccount,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
