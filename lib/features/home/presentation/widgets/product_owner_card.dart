import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';

class ProductOwnerCard extends StatelessWidget {
  final String ownerName;
  final String ownerRole;
  final String ownerPhone;
  final String ownerEmail;

  const ProductOwnerCard({
    super.key,
    required this.ownerName,
    required this.ownerRole,
    required this.ownerPhone,
    required this.ownerEmail,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ownerName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ownerRole,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ownerPhone,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call),
            tooltip: loc.call,
            onPressed: () {
           //   ContactService.call(ownerPhone);
            },
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.email),
            tooltip: loc.email,
            onPressed: () {
           //   ContactService.email(ownerEmail);
            },
          ),
        ],
      ),
    );
  }
}