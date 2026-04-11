import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

    ref.listen(authControllerProvider, (previous, next) async {
      if (next.isSuccess && mounted) {
        if (mounted) {
          context.go(RouteNames.main);
        }
      }
    });
    return AuthScaffoldBody(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AuthBackButton(onTap: () => context.go('/onboarding')),
            const SizedBox(height: 8),
            const Text(
              'Login',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            const AuthHeader(
              title: 'Hi, Welcome Back ! 👋',
              subtitle: 'Sun Gate Welcome you',
            ),
            const SizedBox(height: 38),
            AuthTextField(
              controller: emailController,
              label: 'Email',
              hintText: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            AuthTextField(
              controller: passwordController,
              label: 'Password',
              hintText: 'Enter your password',
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
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.25)),
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
            SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => context.push(RouteNames.forgotPassword),
                child: const Text('Forgot Password?'),
              ),
            ),
            const SizedBox(height: 4),
            AuthPrimaryButton(
              text: 'Login',
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
                    const SnackBar(
                      content: Text('Google sign-in failed. Please try again.'),
                    ),
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
              text: "Don't have an account ? ",
              actionText: 'Sign Up',
              onTap: () => context.push(RouteNames.signUp),
            ),
          ],
        ),
      ),
    );
  }
}
