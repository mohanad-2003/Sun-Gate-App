import 'package:flutter/material.dart';
import 'package:sun_gate_app/core/theme/app_colors.dart';

class OnboardingFooter extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onGetStarted;
  final Widget indicator;

  const OnboardingFooter({
    super.key,
    required this.isLastPage,
    required this.onNext,
    required this.onSkip,
    required this.onGetStarted,
    required this.indicator,
  });

  @override
  Widget build(BuildContext context) {
    if (isLastPage) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Get Started"),
            ),
          ),
          const SizedBox(height: 12),
          // const Text(
          //   "Don't have an account? Sign Up",
          //   style: TextStyle(color: Colors.white70),
          // ),
        ],
      );
    }

    return Row(
      children: [
        /// Skip
        TextButton(
          onPressed: onSkip,
          child: const Text("Skip", style: TextStyle(color: Colors.white70)),
        ),

        const Spacer(),

        /// Indicator
        indicator,

        const Spacer(),

        /// Arrow
        AnimatedScale(
          scale: 1,
          duration: const Duration(milliseconds: 300),
          child: InkWell(
            onTap: onNext,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, Color(0xFFE8C07D)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
