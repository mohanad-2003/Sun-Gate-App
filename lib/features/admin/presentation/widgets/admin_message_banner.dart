import 'package:flutter/material.dart';

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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: (isError ? Colors.red : Colors.green).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isError ? Colors.red : Colors.green).withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isError ? Colors.red.shade700 : Colors.green.shade700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
