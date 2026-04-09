import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/profile_controller.dart';
import '../widgets/profile_section_label.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);

    ref.listen(profileControllerProvider, (previous, next) {
      if (next.successMessage != null && next.successMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The new password must be different from the current password',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
              const SizedBox(height: 20),

              const ProfileSectionLabel(title: 'Old Password'),
              const SizedBox(height: 8),
              TextField(
                controller: oldPasswordController,
                obscureText: oldObscure,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => oldObscure = !oldObscure),
                    icon: Icon(
                      oldObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const ProfileSectionLabel(title: 'New Password'),
              const SizedBox(height: 8),
              TextField(
                controller: newPasswordController,
                obscureText: newObscure,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => newObscure = !newObscure),
                    icon: Icon(
                      newObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                '✓ There must be at least 8 characters',
                style: TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 6),
              const Text(
                '✓ There must be a unique code like @!#',
                style: TextStyle(color: Colors.green),
              ),
              const SizedBox(height: 16),

              const ProfileSectionLabel(title: 'Confirm Password'),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordController,
                obscureText: confirmObscure,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => confirmObscure = !confirmObscure),
                    icon: Icon(
                      confirmObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '✓ There must be the same of new password',
                style: TextStyle(color: Colors.green),
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
                          if (newPasswordController.text.trim() !=
                              confirmPasswordController.text.trim()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Passwords do not match'),
                              ),
                            );
                            return;
                          }

                          ref
                              .read(profileControllerProvider.notifier)
                              .changePassword(
                                oldPassword: oldPasswordController.text.trim(),
                                newPassword: newPasswordController.text.trim(),
                              );
                        },
                  child: state.isSaving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}