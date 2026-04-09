import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auht_text_field.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/auth_scaffold_body.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.message ?? 'Password reset email sent',
            ),
          ),
        );

        context.push(
          RouteNames.otp,
          extra: emailController.text.trim(),
        );
      }
    });

    return AuthScaffoldBody(
      child: Column(
        children: [
          AuthBackButton(onTap: () => context.pop()),
          const SizedBox(height: 40),
          const AuthHeader(
            title: 'Forget Password',
            subtitle: 'Recover your account password',
          ),
          const SizedBox(height: 40),
          AuthTextField(
            controller: emailController,
            label: 'E-mail',
            hintText: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          if (state.errorMessage != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.20),
                ),
              ),
              child: Text(
                state.errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          AuthPrimaryButton(
            text: 'Next',
            isLoading: state.isLoading,
            onPressed: () {
              ref.read(authControllerProvider.notifier).forgotPassword(
                    email: emailController.text.trim(),
                  );
            },
          ),
        ],
      ),
    );
  }
}