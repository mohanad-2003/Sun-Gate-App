import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';

class HomeBannerCard extends StatelessWidget {
  final VoidCallback onTap;
  final double height;

  const HomeBannerCard({super.key, required this.onTap, this.height = 126});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    final horizontalPadding = screenWidth < 360 ? 14.0 : 18.0;
    final verticalPadding = screenWidth < 360 ? 14.0 : 16.0;
    final titleFontSize = screenWidth < 360 ? 15.0 : 16.0;
    final imageHeight = screenWidth < 360 ? 90.0 : 108.0;
    final buttonHeight = screenWidth < 360 ? 36.0 : 38.0;
    final buttonHorizontalPadding = screenWidth < 360 ? 14.0 : 28.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: height,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding - 2,
            verticalPadding,
          ),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.22 : 0.08,
                ),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: _BannerTextContent(
                  titleFontSize: titleFontSize,
                  buttonHeight: buttonHeight,
                  buttonHorizontalPadding: buttonHorizontalPadding,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/p.png',
                    height: imageHeight,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) {
                      return Container(
                        width: imageHeight * 0.82,
                        height: imageHeight * 0.82,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BannerTextContent extends StatelessWidget {
  final double titleFontSize;
  final double buttonHeight;
  final double buttonHorizontalPadding;

  const _BannerTextContent({
    required this.titleFontSize,
    required this.buttonHeight,
    required this.buttonHorizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            loc.homeBannerTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF314E7E),
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Container(
            height: buttonHeight,
            padding: EdgeInsets.symmetric(horizontal: buttonHorizontalPadding),
            decoration: BoxDecoration(
              color: const Color(0xFF314E7E),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Text(
              loc.startExplore,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
