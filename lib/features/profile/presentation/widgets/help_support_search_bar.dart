import 'package:flutter/material.dart';

class HelpSupportSearchBar extends StatelessWidget {
  const HelpSupportSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: theme.hintColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Search for help...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
          Icon(Icons.tune_rounded, color: theme.hintColor),
        ],
      ),
    );
  }
}
