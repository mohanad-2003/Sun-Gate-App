class OnboardingItemModel {
  final String imagePath;
  final String titleKey;
  final String descriptionKey;
  final bool isLastPage;
  final bool useFullImageOverlay;

  const OnboardingItemModel({
    required this.imagePath,
    required this.titleKey,
    required this.descriptionKey,
    this.isLastPage = false,
    this.useFullImageOverlay = false,
  });
}