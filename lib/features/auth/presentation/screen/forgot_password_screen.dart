import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_form_controller.dart';
import 'package:sun_gate_app/features/auth/presentation/controllers/auth_state.dart';
import 'package:sun_gate_app/features/auth/presentation/otp_flow_type.dart';
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
    final loc = AppLocalizations.of(context)!;

    ref.listen(authControllerProvider, (previous, next) {
      if (next.action == AuthAction.forgotPassword && next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message ?? loc.passwordResetEmailSent)),
        );

        context.push(
          RouteNames.otp,
          extra: {
            'email': emailController.text.trim(),
            'flowType': OtpFlowType.resetPassword,
          },
        );
      }
    });

    return AuthScaffoldBody(
      child: Column(
        children: [
          AuthBackButton(onTap: () => context.pop()),
          const SizedBox(height: 40),

          AuthHeader(
            title: loc.forgotPasswordTitle,
            subtitle: loc.forgotPasswordSubtitle,
          ),

          const SizedBox(height: 40),

          AuthTextField(
            controller: emailController,
            label: loc.emailAddress,
            hintText: loc.enterEmailAddress,
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
            text: loc.next,
            isLoading: state.isLoading,
            onPressed: () {
              ref
                  .read(authControllerProvider.notifier)
                  .forgotPassword(email: emailController.text.trim());
            },
          ),
        ],
      ),
    );
  }
}
