import 'package:flutter/material.dart';
import 'package:sun_gate_app/features/marketplace/domain/entities/company_entity.dart';

class CompanyCard extends StatelessWidget {
  final CompanyEntity company;
  final VoidCallback? onTap;

  const CompanyCard({
    super.key,
    required this.company,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: colorScheme.surfaceContainerHighest,
              ),
              clipBehavior: Clip.antiAlias,
              child: company.logo != null && company.logo!.isNotEmpty
                  ? Image.network(
                      company.logo!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return Icon(
                          Icons.business,
                          size: 34,
                          color: colorScheme.primary,
                        );
                      },
                    )
                  : Icon(
                      Icons.business,
                      size: 34,
                      color: colorScheme.primary,
                    ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    company.ownerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: colorScheme.primary,
                      ),

                      const SizedBox(width: 4),

                      Expanded(
                        child: Text(
                          company.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 16,
                        color: colorScheme.primary,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        company.phone,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}