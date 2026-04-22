import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/password_visiablity_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auht_text_field.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/password_strength_indicator.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String token;

  const NewPasswordScreen({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  ConsumerState<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final passVisible = ref.watch(newPasswordVisiableProvider);
    final confirmVisible = ref.watch(confirmPasswordVisiableProvider);
    final loc = AppLocalizations.of(context)!;

    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final passwordStrength = evaluatePasswordStrength(password);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message ?? loc.passwordResetSuccess)),
        );
        context.go(RouteNames.login);
      }
    });

    return AuthScaffoldBody(
      child: Column(
        children: [
          AuthBackButton(onTap: () => context.pop()),

          const SizedBox(height: 24),

          AuthHeader(
            title: loc.createNewPassword,
            subtitle: loc.enterNewPasswordSubtitle,
          ),

          const SizedBox(height: 34),

          /// NEW PASSWORD
          AuthTextField(
            controller: passwordController,
            label: loc.newPassword,
            hintText: loc.enterPassword,
            obscureText: !passVisible,
            onChanged: (_) => setState(() {}),
            suffixIcon: IconButton(
              onPressed: () {
                ref.read(newPasswordVisiableProvider.notifier).state =
                    !passVisible;
              },
              icon: Icon(
                passVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),

          const SizedBox(height: 10),

          PasswordStrengthIndicator(password: password),

          const SizedBox(height: 16),

          /// CONFIRM PASSWORD
          AuthTextField(
            controller: confirmPasswordController,
            label: loc.confirmPassword,
            hintText: loc.confirmYourPassword,
            obscureText: !confirmVisible,
            onChanged: (_) => setState(() {}),
            suffixIcon: IconButton(
              onPressed: () {
                ref.read(confirmPasswordVisiableProvider.notifier).state =
                    !confirmVisible;
              },
              icon: Icon(
                confirmVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// PASSWORD MATCH ERROR
          if (confirmPassword.isNotEmpty && password != confirmPassword)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withValues(alpha: 0.20)),
              ),
              child: Text(
                loc.passwordsDoNotMatch,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          if (state.errorMessage != null) ...[
            const SizedBox(height: 16),
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

          const SizedBox(height: 20),

          /// SUBMIT BUTTON
          AuthPrimaryButton(
            text: loc.next,
            isLoading: state.isLoading,
            onPressed: () {
              if (widget.token.trim().isEmpty) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(loc.tokenMissing)));
                return;
              }

              if (password.isEmpty || confirmPassword.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.pleaseFillAllPasswordFields)),
                );
                return;
              }

              if (password != confirmPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.passwordsDoNotMatch)),
                );
                return;
              }

              if (!passwordStrength.isValidStrongPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.pleaseChooseStrongerPassword)),
                );
                return;
              }

              ref
                  .read(authControllerProvider.notifier)
                  .resetPassword(
                    password: password,
                    passwordResetToken: widget.token,
                  );
            },
          ),
        ],
      ),
    );
  }
}
