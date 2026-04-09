import 'package:flutter/material.dart';
import 'package:sun_gate_app/core/widgets/app_text.dart';
import 'package:sun_gate_app/features/onboarding/data/model/onboarding_item_model.dart';

import 'onboarding_background_image.dart';
import 'onboarding_content_card.dart';

class OnboardingPageView extends StatelessWidget {
  final OnboardingItemModel item;
  final String title;
  final String description;
  final Widget footer;

  const OnboardingPageView({
    super.key,
    required this.item,
    required this.title,
    required this.description,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    if (item.isLastPage) {
      return Stack(
        fit: StackFit.expand,
        children: [
          OnboardingBackgroundImage(
            imagePath: item.imagePath,
            useDarkOverlay: true,
            isLastPage: true,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF264069).withOpacity(0.35),
                      const Color(0xFF264069).withOpacity(0.72),
                      const Color(0xFF264069).withOpacity(0.95),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            height: 1.35,
                          ),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 14,
                        height: 1.5,
                      ),
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 28),
                    footer,
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        OnboardingBackgroundImage(
          imagePath: item.imagePath,
          useDarkOverlay: false,
          isLastPage: false,
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20),
            //  margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: const BoxDecoration(
              color: Color(0xFF274777),
              borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OnboardingContentCard(title: title, description: description),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  color: const Color(0xFF274777),
                  child: footer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
