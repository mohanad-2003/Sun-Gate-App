import 'package:flutter/material.dart';
import 'package:sun_gate_app/core/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: List.generate(totalCount, (index) {
        final isActive = currentIndex == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isActive ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.secondary
                : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}