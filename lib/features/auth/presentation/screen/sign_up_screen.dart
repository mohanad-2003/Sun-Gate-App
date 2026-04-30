import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/otp_flow_type.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auht_text_field.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_bottom_link.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/langauge_switcher.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/password_strength_indicator.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool acceptPolicy = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Color? _getPasswordBorderColor(String password) {
    if (password.isEmpty) return null;

    final result = evaluatePasswordStrength(password);

    if (result.level == PasswordStrengthLevel.strong) return Colors.green;
    if (result.level == PasswordStrengthLevel.medium) return Colors.orange;

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final loc = AppLocalizations.of(context)!;

    final password = passwordController.text.trim();
    final passwordStrength = evaluatePasswordStrength(password);
    final passwordBorderColor = _getPasswordBorderColor(password);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.registrationSuccess)));
        context.go(
          RouteNames.otp,
          extra: {
            'email': emailController.text.trim(),
            'flowType': OtpFlowType.verifyEmail,
          },
        );
      }
    });

    return AuthScaffoldBody(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AuthBackButton(onTap: () => context.go('/login')),
                  const LanguageSwitcherButton(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),

          Text(
            loc.signUpTitle,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),

          const SizedBox(height: 26),

          AuthHeader(
            title: loc.completeAccountTitle,
            subtitle: loc.createNewAccount,
          ),

          const SizedBox(height: 26),

          Row(
            children: [
              Expanded(
                child: AuthTextField(
                  controller: firstNameController,
                  label: loc.firstName,
                  hintText: loc.enterFirstName,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AuthTextField(
                  controller: lastNameController,
                  label: loc.lastName,
                  hintText: loc.enterLastName,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          AuthTextField(
            controller: emailController,
            label: loc.emailAddress,
            hintText: loc.enterEmail,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 14),

          AuthTextField(
            controller: passwordController,
            label: loc.password,
            hintText: loc.enterPassword,
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
            title: Text(loc.acceptPolicy, style: const TextStyle(fontSize: 12)),
            controlAffinity: ListTileControlAffinity.leading,
          ),

          if (state.errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withValues(alpha: 0.20)),
              ),
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ],

          const SizedBox(height: 12),

          AuthPrimaryButton(
            text: loc.signUpTitle,
            isLoading: state.isLoading,
            onPressed: acceptPolicy
                ? () {
                    final email = emailController.text.trim();
                    final rawPassword = passwordController.text;

                    if (firstNameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterFirstName)),
                      );
                      return;
                    }

                    if (lastNameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterLastName)),
                      );
                      return;
                    }

                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterEmail)),
                      );
                      return;
                    }

                    if (rawPassword.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.pleaseEnterPassword)),
                      );
                      return;
                    }

                    if (!passwordStrength.isValidStrongPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(loc.pleaseChooseStrongerPassword),
                        ),
                      );
                      return;
                    }

                    ref
                        .read(authControllerProvider.notifier)
                        .register(
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          email: email,
                          password: rawPassword,
                        );
                  }
                : null,
          ),

          const SizedBox(height: 20),

          AuthBottomLink(
            text: loc.alreadyHaveAccount,
            actionText: loc.login,
            onTap: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
