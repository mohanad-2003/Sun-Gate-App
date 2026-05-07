import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/password_visiablity_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/otp_flow_type.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auht_text_field.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/password_strength_indicator.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  final String token;
  final OtpFlowType flowType;

  const NewPasswordScreen({
    super.key,
    required this.email,
    required this.token,
    required this.flowType,
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

          // CONFIRM PASSWORD
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

          // PASSWORD MATCH ERROR
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
            onPressed: () async {
              final password = passwordController.text.trim();
              final confirmPassword = confirmPasswordController.text.trim();

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

              if (!evaluatePasswordStrength(password).isValidStrongPassword) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.pleaseChooseStrongerPassword)),
                );
                return;
              }

              final authController = ref.read(authControllerProvider.notifier);

              if (widget.flowType == OtpFlowType.verifyEmail) {
                /// SIGN UP FLOW
                await authController.assignPassword(
                  email: widget.email,
                  password: password,
                );
              } else {
                /// FORGOT PASSWORD FLOW
                await authController.resetPassword(
                  password: password,
                  passwordResetToken: widget.token,
                );
              }

              final currentState = ref.read(authControllerProvider);

              if (!currentState.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      currentState.errorMessage ?? 'Assign password failed',
                    ),
                  ),
                );
                return;
              }

              await authController.login(
                email: widget.email,
                password: password,
              );
              await ref.read(profileControllerProvider.notifier).getMyProfile();
              await ref
                  .read(marketPlaceControllerProvider.notifier)
                  .getProducts();
              final loginState = ref.read(authControllerProvider);

              if (loginState.isSuccess && context.mounted) {
                context.go(RouteNames.main);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loginState.errorMessage ?? 'Login failed'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
