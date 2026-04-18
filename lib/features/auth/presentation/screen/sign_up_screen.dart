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
import 'package:sun_gate_app/features/auth/presentation/widgets/password_strength_indicator.dart';

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
  bool obscurePassword = true;

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

  Color? _getPasswordBorderColor(String password) {
    if (password.isEmpty) {
      return null;
    }

    final result = evaluatePasswordStrength(password);

    if (result.level == PasswordStrengthLevel.strong) {
      return Colors.green;
    }

    if (result.level == PasswordStrengthLevel.medium) {
      return Colors.orange;
    }

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final password = passwordController.text.trim();
    final passwordStrength = evaluatePasswordStrength(password);
    final passwordBorderColor = _getPasswordBorderColor(password);

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
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),

          AuthTextField(
            controller: emailController,
            label: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),

          AuthTextField(
            controller: passwordController,
            label: 'Password',
            hintText: 'Enter your password',
            obscureText: obscurePassword,
            onChanged: (_) => setState(() {}),
            enabledBorderColor: passwordBorderColor,
            focusedBorderColor: passwordBorderColor ?? const Color(0xFF274777),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),

          const SizedBox(height: 10),

          PasswordStrengthIndicator(password: password),

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
                    final fullName = fullNameController.text.trim();
                    final email = emailController.text.trim();
                    final rawPassword = passwordController.text;

                    if (fullName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your full name'),
                        ),
                      );
                      return;
                    }

                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email'),
                        ),
                      );
                      return;
                    }

                    if (rawPassword.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your password'),
                        ),
                      );
                      return;
                    }

                    if (!passwordStrength.isValidStrongPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please choose a stronger password'),
                        ),
                      );
                      return;
                    }

                    final name = _splitName(fullName);

                    ref
                        .read(authControllerProvider.notifier)
                        .register(
                          firstName: name.$1,
                          lastName: name.$2,
                          email: email,
                          password: rawPassword,
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
