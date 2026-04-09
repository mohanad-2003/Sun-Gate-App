import 'package:flutter/material.dart';
import 'package:sun_gate_app/core/widgets/app_button.dart';

class OnboardingBottomSection extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool showPrimaryButton;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final Widget indicator;

  const OnboardingBottomSection({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.showPrimaryButton,
    required this.onNext,
    required this.onSkip,
    required this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    if (showPrimaryButton) {
      return Column(
        children: [
          AppButton(
            text: 'Get Started',
            onPressed: () {},
          ),
          const SizedBox(height: 16),
          RichText(
            text: const TextSpan(
              text: "Don’t have an account ? ",
              style: TextStyle(color: Colors.white70),
              children: [
                TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(
                    color: Color(0xFFE0B86D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        InkWell(
          onTap: onNext,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFFE0B86D),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Color(0xFF274777),
            ),
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: onSkip,
          child: const Text(
            'Skip',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        indicator,
      ],
    );
  }
}