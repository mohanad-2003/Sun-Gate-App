import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/core/theme/app_colors.dart';
import 'package:sun_gate_app/core/utils/app_string.dart';

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
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                AppStrings.get(context, 'get_started'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: AppStrings.get(context, 'dont_have_account'),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
              children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.go('/sign-up'),
                  text: AppStrings.get(context, 'sign_up'),
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
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
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 30),
        TextButton(
          onPressed: onSkip,
          child: Text(
            AppStrings.get(context, 'skip'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        const Spacer(),
        Flexible(child: indicator),
      ],
    );
  }
}
