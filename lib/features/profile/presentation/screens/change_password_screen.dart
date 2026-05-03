import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/auth/presentation/widgets/password_strength_indicator.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/widgets/profile_section_label.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool oldObscure = true;
  bool newObscure = true;
  bool confirmObscure = true;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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

  Color? _getConfirmPasswordBorderColor({
    required String newPassword,
    required String confirmPassword,
  }) {
    if (confirmPassword.isEmpty) {
      return null;
    }

    if (newPassword == confirmPassword) {
      return Colors.green;
    }

    return Colors.red;
  }

  InputDecoration _buildPasswordDecoration({
    required bool obscureText,
    required VoidCallback onToggle,
    Color? enabledBorderColor,
    Color? focusedBorderColor,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: enabledBorderColor ?? const Color(0xFFE4E7EC),
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: focusedBorderColor ?? const Color(0xFF274777),
          width: 1.5,
        ),
      ),
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    final loc = AppLocalizations.of(context)!;

    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final passwordStrength = evaluatePasswordStrength(newPassword);
    final newPasswordBorderColor = _getPasswordBorderColor(newPassword);
    final confirmPasswordBorderColor = _getConfirmPasswordBorderColor(
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    ref.listen(profileControllerProvider, (previous, next) {
      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.successMessage!)));
        context.go(RouteNames.main);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(loc.changePassword)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.changePasswordHint,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 20),

              ProfileSectionLabel(title: loc.oldPassword),
              const SizedBox(height: 8),
              TextField(
                controller: oldPasswordController,
                obscureText: oldObscure,
                decoration: _buildPasswordDecoration(
                  obscureText: oldObscure,
                  onToggle: () => setState(() => oldObscure = !oldObscure),
                ),
              ),
              const SizedBox(height: 16),

              ProfileSectionLabel(title: loc.newPassword),
              const SizedBox(height: 8),
              TextField(
                controller: newPasswordController,
                obscureText: newObscure,
                onChanged: (_) => setState(() {}),
                decoration: _buildPasswordDecoration(
                  obscureText: newObscure,
                  onToggle: () => setState(() => newObscure = !newObscure),
                  enabledBorderColor: newPasswordBorderColor,
                  focusedBorderColor:
                      newPasswordBorderColor ?? const Color(0xFF274777),
                ),
              ),
              const SizedBox(height: 10),

              PasswordStrengthIndicator(password: newPassword),

              const SizedBox(height: 16),

              ProfileSectionLabel(title: loc.confirmPassword),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordController,
                obscureText: confirmObscure,
                onChanged: (_) => setState(() {}),
                decoration: _buildPasswordDecoration(
                  obscureText: confirmObscure,
                  onToggle: () =>
                      setState(() => confirmObscure = !confirmObscure),
                  enabledBorderColor: confirmPasswordBorderColor,
                  focusedBorderColor:
                      confirmPasswordBorderColor ?? const Color(0xFF274777),
                ),
              ),
              const SizedBox(height: 10),

              if (confirmPassword.isNotEmpty)
                Text(
                  newPassword == confirmPassword
                      ? '✓ ${loc.passwordsMatch}'
                      : loc.passwordsDoNotMatch,
                  style: TextStyle(
                    color: newPassword == confirmPassword
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              const SizedBox(height: 18),

              if (state.errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.isSaving
                      ? null
                      : () {
                          final oldPassword = oldPasswordController.text.trim();
                          final newPasswordValue = newPasswordController.text
                              .trim();
                          final confirmPasswordValue = confirmPasswordController
                              .text
                              .trim();

                          if (oldPassword.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loc.pleaseEnterOldPassword),
                              ),
                            );
                            return;
                          }

                          if (newPasswordValue.isEmpty ||
                              confirmPasswordValue.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loc.pleaseFillAllPasswordFields),
                              ),
                            );
                            return;
                          }

                          if (oldPassword == newPasswordValue) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(loc.newPasswordMustBeDifferent),
                              ),
                            );
                            return;
                          }

                          if (newPasswordValue != confirmPasswordValue) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(loc.passwordsDoNotMatch)),
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
                              .read(profileControllerProvider.notifier)
                              .changePassword(
                                oldPassword: oldPassword,
                                newPassword: newPasswordValue,
                              );
                        },
                  child: state.isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(loc.submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
