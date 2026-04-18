import 'package:flutter/material.dart';

enum PasswordStrengthLevel {
  empty,
  weak,
  medium,
  strong,
}

class PasswordStrengthResult {
  final double progress;
  final PasswordStrengthLevel level;
  final String label;
  final Color color;

  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasNumber;
  final bool hasSpecialCharacter;

  const PasswordStrengthResult({
    required this.progress,
    required this.level,
    required this.label,
    required this.color,
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasNumber,
    required this.hasSpecialCharacter,
  });

  bool get isValidStrongPassword {
    return hasMinLength &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecialCharacter;
  }
}

PasswordStrengthResult evaluatePasswordStrength(String password) {
  final hasMinLength = password.length >= 8;
  final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
  final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
  final hasNumber = RegExp(r'[0-9]').hasMatch(password);
  final hasSpecialCharacter = RegExp(
    r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\];`~]',
  ).hasMatch(password);

  int score = 0;
  if (hasMinLength) score++;
  if (hasUppercase) score++;
  if (hasLowercase) score++;
  if (hasNumber) score++;
  if (hasSpecialCharacter) score++;

  if (password.isEmpty) {
    return PasswordStrengthResult(
      progress: 0,
      level: PasswordStrengthLevel.empty,
      label: '',
      color: Colors.grey,
      hasMinLength: hasMinLength,
      hasUppercase: hasUppercase,
      hasLowercase: hasLowercase,
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
    );
  }

  if (score <= 2) {
    return PasswordStrengthResult(
      progress: 0.33,
      level: PasswordStrengthLevel.weak,
      label: 'Weak password',
      color: Colors.red,
      hasMinLength: hasMinLength,
      hasUppercase: hasUppercase,
      hasLowercase: hasLowercase,
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
    );
  }

  if (score <= 4) {
    return PasswordStrengthResult(
      progress: 0.66,
      level: PasswordStrengthLevel.medium,
      label: 'Medium password',
      color: Colors.orange,
      hasMinLength: hasMinLength,
      hasUppercase: hasUppercase,
      hasLowercase: hasLowercase,
      hasNumber: hasNumber,
      hasSpecialCharacter: hasSpecialCharacter,
    );
  }

  return PasswordStrengthResult(
    progress: 1,
    level: PasswordStrengthLevel.strong,
    label: 'Strong password',
    color: Colors.green,
    hasMinLength: hasMinLength,
    hasUppercase: hasUppercase,
    hasLowercase: hasLowercase,
    hasNumber: hasNumber,
    hasSpecialCharacter: hasSpecialCharacter,
  );
}

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    final result = evaluatePasswordStrength(password);
    final theme = Theme.of(context);

    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: result.progress,
            minHeight: 7,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(result.color),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          result.label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: result.color,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: [
            _RequirementChip(
              text: '8+ characters',
              isValid: result.hasMinLength,
            ),
            _RequirementChip(
              text: 'Uppercase letter',
              isValid: result.hasUppercase,
            ),
            _RequirementChip(
              text: 'Lowercase letter',
              isValid: result.hasLowercase,
            ),
            _RequirementChip(
              text: 'Number',
              isValid: result.hasNumber,
            ),
            _RequirementChip(
              text: 'Special character',
              isValid: result.hasSpecialCharacter,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Use a strong password to continue safely.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _RequirementChip extends StatelessWidget {
  final String text;
  final bool isValid;

  const _RequirementChip({
    required this.text,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isValid
        ? Colors.green.withOpacity(0.10)
        : Colors.grey.withOpacity(0.10);

    final borderColor = isValid
        ? Colors.green.withOpacity(0.35)
        : Colors.grey.withOpacity(0.30);

    final iconColor = isValid ? Colors.green : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 15,
            color: iconColor,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: isValid ? Colors.green.shade700 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}