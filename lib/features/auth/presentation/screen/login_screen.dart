import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
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

    ref.listen(authControllerProvider, (previous, next) async {
      if (next.isSuccess && mounted) {
        context.go(RouteNames.main);
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.25)),
                ),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
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
                ref
                    .read(authControllerProvider.notifier)
                    .login(
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

                final idToken = await googleService.signInAndGetIdToken();

                if (idToken == null) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.googleSignInFailed)),
                  );
                  return;
                }

                await ref
                    .read(authControllerProvider.notifier)
                    .googleLogin(idToken: idToken);
              },
            ),

            const SizedBox(height: 28),

            AuthBottomLink(
              text: loc.dontHaveAccount,
              actionText: loc.signUp,
              onTap: () => context.push(RouteNames.signUp),
            ),
          ],
        ),
      ),
    );
  }
}
