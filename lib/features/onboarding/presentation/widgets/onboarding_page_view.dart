import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:sun_gate_app/core/widgets/app_text.dart';
import 'package:sun_gate_app/features/onboarding/data/model/onboarding_item_model.dart';
import 'onboarding_background_image.dart';

class OnboardingPageView extends StatefulWidget {
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
  State<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends State<OnboardingPageView> {
  Color dominantColor = const Color(0xFF274777);
  @override
  void initState() {
    super.initState();
    _generateColor();
  }

  Future<void> _generateColor() async {
    final palette = await PaletteGeneratorMaster.fromImageProvider(
      AssetImage(widget.item.imagePath),
    );
    if (!mounted) return;
    setState(() {
      dominantColor = palette.dominantColor?.color ?? const Color(0xFF274777);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        OnboardingBackgroundImage(
          imagePath: widget.item.imagePath,
          useDarkOverlay: false,
          isLastPage: widget.item.isLastPage,
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      dominantColor.withOpacity(0.6),
                      dominantColor.withOpacity(0.85),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Animated Text
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 500),
                      tween: Tween<Offset>(
                        begin: const Offset(0, 30),
                        end: Offset.zero,
                      ),
                      builder: (context, value, child) {
                        return Transform.translate(offset: value, child: child);
                      },
                      child: Column(
                        children: [
                          AppText(
                            widget.title,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 26,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          AppText(
                            widget.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 15,
                                  height: 1.6,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    widget.footer,
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
