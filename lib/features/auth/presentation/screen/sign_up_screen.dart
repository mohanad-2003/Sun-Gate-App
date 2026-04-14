import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auht_text_field.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_bottom_link.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool acceptPolicy = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  (String firstName, String lastName) _splitName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return ('', '');
    }

    if (parts.length == 1) {
      return (parts.first, '');
    }

    return (parts.first, parts.sublist(1).join(' '));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message ?? 'Registration successful')),
        );
        context.go(RouteNames.otp, extra: emailController.text.trim());
      }
    });
    return AuthScaffoldBody(
      child: Column(
        children: [
          AuthBackButton(onTap: () => context.go('/login')),
          const SizedBox(height: 4),
          const Text(
            'Sign up',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 26),
          const AuthHeader(
            title: 'Complete Your account',
            subtitle: 'Create your new account',
          ),
          const SizedBox(height: 26),

          AuthTextField(
            controller: fullNameController,
            label: 'Full Name',
            hintText: 'Enter your full name',
          ),
          const SizedBox(height: 14),

          AuthTextField(
            controller: emailController,
            label: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),

          AuthTextField(
            controller: passwordController,
            label: 'Password',
            hintText: 'Enter your password',
            obscureText: true,
          ),
          const SizedBox(height: 12),

          CheckboxListTile(
            value: acceptPolicy,
            onChanged: (value) {
              setState(() {
                acceptPolicy = value ?? false;
              });
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'accept the policy and privacy of app',
              style: TextStyle(fontSize: 12),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),

          if (state.errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.20)),
              ),
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ],

          const SizedBox(height: 12),

          AuthPrimaryButton(
            text: 'Sign Up',
            isLoading: state.isLoading,
            onPressed: acceptPolicy
                ? () {
                    final name = _splitName(fullNameController.text);

                    ref
                        .read(authControllerProvider.notifier)
                        .register(
                          firstName: name.$1,
                          lastName: name.$2,
                          email: emailController.text.trim(),
                          password: passwordController.text,
                        );
                  }
                : null,
          ),

          const SizedBox(height: 20),

          AuthBottomLink(
            text: 'Already have an account ? ',
            actionText: 'Login',
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
