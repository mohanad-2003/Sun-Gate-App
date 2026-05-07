import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';

class CompanyDetailScreen extends StatelessWidget {
  final CompanyEntity company;

  const CompanyDetailScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Detail'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 190,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: company.logo != null && company.logo!.isNotEmpty
                ? Image.network(
                    company.logo!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Icon(
                        Icons.business,
                        size: 70,
                        color: colorScheme.primary,
                      );
                    },
                  )
                : Icon(
                    Icons.business,
                    size: 70,
                    color: colorScheme.primary,
                  ),
          ),

          const SizedBox(height: 20),

          Text(
            company.ownerName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 18),

          _InfoTile(
            icon: Icons.location_on_outlined,
            title: 'Address',
            value: company.address,
          ),

          const SizedBox(height: 12),

          _InfoTile(
            icon: Icons.phone_outlined,
            title: 'Phone',
            value: company.phone,
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call),
              label: const Text('Contact Company'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}