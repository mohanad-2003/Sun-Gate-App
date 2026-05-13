import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/password_visiablity_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auht_text_field.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_bottom_link.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_divider.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_outline_google_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/langauge_switcher.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final isVisible = ref.watch(loginPasswordVisiableProvider);
    final loc = AppLocalizations.of(context)!;
    final isPendingCompanyReview = _isPendingCompanyReviewMessage(
      state.errorMessage,
    );

    ref.listen(authControllerProvider, (previous, next) async {
      if (next.action == AuthAction.login && next.isSuccess && mounted) {
        await ref.read(profileControllerProvider.notifier).getMyProfile();
        if (!mounted) return;

        // Check if user has a company
        await ref.read(marketPlaceControllerProvider.notifier).getMyCompany();
        if (!mounted) return;

        final marketState = ref.read(marketPlaceControllerProvider);
        if (marketState.myCompany != null) {
          // User is a company owner, navigate to company home
          context.go(RouteNames.home);
        } else {
          // Regular user, navigate to main navigation
          context.go(RouteNames.main);
        }
        return;
      }

      if (next.action == AuthAction.companyLogin && next.isSuccess && mounted) {
        await ref.read(profileControllerProvider.notifier).getMyProfile();
        if (!mounted) return;

        // Company login always goes to company home
        await ref.read(marketPlaceControllerProvider.notifier).getMyCompany();
        if (!mounted) return;

        context.go(RouteNames.home);
        return;
      }

      if (next.action == AuthAction.googleLogin && next.isSuccess && mounted) {
        // Check if Google user has a company
        await ref.read(profileControllerProvider.notifier).getMyProfile();
        if (!mounted) return;

        await ref.read(marketPlaceControllerProvider.notifier).getMyCompany();
        if (!mounted) return;

        final marketState = ref.read(marketPlaceControllerProvider);
        if (marketState.myCompany != null) {
          context.go(RouteNames.home);
        } else {
          context.go(RouteNames.main);
        }
      }
    });

    return AuthScaffoldBody(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AuthBackButton(onTap: () => context.go('/onboarding')),
                    const LanguageSwitcherButton(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              loc.login,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            AuthHeader(
              title: loc.loginWelcomeTitle,
              subtitle: loc.loginWelcomeSubtitle,
            ),
            const SizedBox(height: 38),
            AuthTextField(
              controller: emailController,
              label: loc.emailAddress,
              hintText: loc.enterEmailAddress,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: passwordController,
              label: loc.password,
              hintText: loc.enterPassword,
              obscureText: !isVisible,
              suffixIcon: IconButton(
                onPressed: () {
                  ref.read(loginPasswordVisiableProvider.notifier).state =
                      !isVisible;
                },
                icon: Icon(
                  isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
              ),
            ),
            if (state.errorMessage != null) ...[
              isPendingCompanyReview
                  ? const _CompanyPendingReviewCard()
                  : _LoginErrorCard(message: state.errorMessage!),
            ],
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => context.push(RouteNames.forgotPassword),
                child: Text(loc.forgotPassword),
              ),
            ),
            const SizedBox(height: 4),
            AuthPrimaryButton(
              text: loc.login,
              isLoading: state.isLoading,
              onPressed: () {
                final controller = ref.read(authControllerProvider.notifier);
                controller.login(
                  email: emailController.text,
                  password: passwordController.text,
                );
              },
            ),
            const SizedBox(height: 22),
            const AuthDivider(),
            const SizedBox(height: 22),
            AuthOutlineGoogleButton(
              onPressed: () async {
                final googleService = ref.read(googleAuthServiceProvider);
                final account = await googleService.signIn();

                if (account == null) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.googleSignInFailed)),
                  );
                  return;
                }

                final auth = account.authentication;
                final idToken = auth.idToken;
                final photo = account.photoUrl;

                if (idToken == null) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.googleSignInFailed)),
                  );
                  return;
                }

                await ref
                    .read(authControllerProvider.notifier)
                    .googleLogin(idToken: idToken, ref: ref, photoUrl: photo);
              },
            ),
            const SizedBox(height: 28),
            AuthBottomLink(
              text: loc.dontHaveAccount,
              actionText: loc.signUp,
              onTap: () => context.push(RouteNames.accountType),
            ),
          ],
        ),
      ),
    );
  }

  bool _isPendingCompanyReviewMessage(String? message) {
    if (message == null || message.isEmpty) return false;

    final normalized = message.toLowerCase();

    return normalized.contains('pending admin') ||
        normalized.contains('pending review') ||
        normalized.contains('not active') ||
        normalized.contains('account is not active') ||
        normalized.contains('not active yet');
  }
}

class _LoginErrorCard extends StatelessWidget {
  final String message;

  const _LoginErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _CompanyPendingReviewCard extends StatelessWidget {
  const _CompanyPendingReviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF274777).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF274777).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFF274777),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.hourglass_top_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u0637\u0644\u0628\u0643 \u0642\u064A\u062F \u0627\u0644\u0645\u0631\u0627\u062C\u0639\u0629',
                  style: TextStyle(
                    color: Color(0xFF274777),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '\u062A\u0645 \u0625\u0646\u0634\u0627\u0621 \u0637\u0644\u0628 \u0627\u0644\u0634\u0631\u0643\u0629 \u0628\u0646\u062C\u0627\u062D. \u064A\u0645\u0643\u0646\u0643 \u062A\u0633\u062C\u064A\u0644 \u0627\u0644\u062F\u062E\u0648\u0644 \u0628\u0639\u062F \u0645\u0648\u0627\u0641\u0642\u0629 \u0627\u0644\u0627\u062F\u0645\u0646 \u0648\u062A\u0641\u0639\u064A\u0644 \u0627\u0644\u062D\u0633\u0627\u0628.',
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
