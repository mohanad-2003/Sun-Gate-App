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
            alignment: Alignment.center,
            errorBuilder: (_, _, _) {
              return Container(
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined, size: 48),
              );
            },
          ),
          if (isLastPage)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF264069).withOpacity(0.63),
                    const Color(0xFFE1C886).withOpacity(0.20),
                    const Color(0xFF264069).withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.42, 1.0],
                ),
              ),
            )
          else if (useDarkOverlay)
            Container(color: Colors.black.withOpacity(0.06)),
        ],
      ),
    );
  }
}
