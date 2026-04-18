import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/constants/app_assets.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/utils/app_string.dart';
import 'package:sun_gate_app/core/widgets/app_scaffold.dart';
import 'package:sun_gate_app/features/onboarding/data/model/onboarding_item_model.dart';
import 'package:sun_gate_app/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:sun_gate_app/features/onboarding/presentation/widgets/onboarding_footer.dart';
import 'package:sun_gate_app/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:sun_gate_app/features/onboarding/presentation/widgets/onboarding_page_view.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});
  List<OnboardingItemModel> _items() {
    return [
      OnboardingItemModel(
        imagePath: AppAssets.onboarding1,
        titleKey: 'onboarding_1_title',
        descriptionKey: 'onboarding_1_desc',
      ),
      OnboardingItemModel(
        imagePath: AppAssets.onboarding2,
        titleKey: 'onboarding_2_title',
        descriptionKey: 'onboarding_2_desc',
      ),
      OnboardingItemModel(
        imagePath: AppAssets.onboarding3,
        titleKey: 'onboarding_3_title',
        descriptionKey: 'onboarding_3_desc',
      ),
      OnboardingItemModel(
        imagePath: AppAssets.onboarding4,
        titleKey: 'onboarding_4_title',
        descriptionKey: 'onboarding_4_desc',
        isLastPage: true,
        useFullImageOverlay: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = _items();

    final currentIndex = ref.watch(onboardingPageIndexProvider);
    final pageController = ref.watch(onboardingPageControllerProvider);

    void goNext() {
      if (currentIndex < items.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
        );
      }
    }

    void skipToLast() {
      pageController.animateToPage(
        items.length - 1,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      );
    }

    void getStarted() {
      context.go(RouteNames.login);
    }

    return AppScaffold(
      useSafeArea: false,
      child: PageView.builder(
        controller: pageController,
        itemCount: items.length,

        onPageChanged: (index) {
          ref.read(onboardingPageIndexProvider.notifier).state = index;
        },
        itemBuilder: (context, index) {
          final item = items[index];

          return OnboardingPageView(
            item: item,
            title: AppStrings.get(context, item.titleKey),
            description: AppStrings.get(context, item.descriptionKey),
            footer: OnboardingFooter(
              isLastPage: item.isLastPage,
              onNext: goNext,
              onSkip: skipToLast,
              onGetStarted: getStarted,
              indicator: OnboardingIndicator(
                currentIndex: currentIndex,
                totalCount: items.length,
              ),
            ),
          );
        },
      ),
    );
  }
}
