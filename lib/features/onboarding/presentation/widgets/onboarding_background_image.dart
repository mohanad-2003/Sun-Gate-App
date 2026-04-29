import 'package:flutter/material.dart';

class OnboardingBackgroundImage extends StatelessWidget {
  final String imagePath;
  final bool useDarkOverlay;
  final bool isLastPage;

  const OnboardingBackgroundImage({
    super.key,
    required this.imagePath,
    required this.useDarkOverlay,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),

          /// Gradient cinematic overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}