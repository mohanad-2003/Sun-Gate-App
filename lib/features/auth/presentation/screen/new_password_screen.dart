import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/password_visiablity_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auht_text_field.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';

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

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message ?? 'Password reset successfully'),
          ),
        );

        context.go(RouteNames.login);
      }
    });

    return AuthScaffoldBody(
      child: Column(
        children: [
          AuthBackButton(onTap: () => context.pop()),
          const SizedBox(height: 24),
          const AuthHeader(
            title: 'create a New Password',
            subtitle: 'Enter your new password',
          ),
          const SizedBox(height: 34),

          AuthTextField(
            controller: passwordController,
            label: 'New Password',
            hintText: 'Enter your password',
            obscureText: !passVisible,
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
          const SizedBox(height: 16),

          AuthTextField(
            controller: confirmPasswordController,
            label: 'Confirm Password',
            hintText: 'confirm your password',
            obscureText: !confirmVisible,
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

          const SizedBox(height: 16),

          if (state.errorMessage != null) ...[
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
            const SizedBox(height: 16),
          ],

          AuthPrimaryButton(
            text: 'Next',
            isLoading: state.isLoading,
            onPressed: () {
              if (widget.email.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Email is missing. Please go back and try again.',
                    ),
                  ),
                );
                return;
              }

              if (widget.token.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Reset code is missing. Please go back and try again.',
                    ),
                  ),
                );
                return;
              }

              if (passwordController.text.trim() !=
                  confirmPasswordController.text.trim()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Passwords do not match')),
                );
                return;
              }

              ref
                  .read(authControllerProvider.notifier)
                  .resetPassword(
                    email: widget.email,
                    token: widget.token,
                    password: passwordController.text.trim(),
                  );
            },
          ),
        ],
      ),
    );
  }
}
