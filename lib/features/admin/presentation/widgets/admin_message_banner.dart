import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/admin/presentation/widgets/admin_ui_kit.dart';

class AdminMessageBanner extends StatelessWidget {
  final String? errorMessage;
  final String? successMessage;

  const AdminMessageBanner({
    super.key,
    this.errorMessage,
    this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null && successMessage == null) {
      return const SizedBox.shrink();
    }

    final isError = errorMessage != null;
    final message = errorMessage ?? successMessage!;

    final color = isError ? const Color(0xFFC62828) : const Color(0xFF1F9D55);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AdminPanel(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
