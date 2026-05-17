import 'package:flutter/material.dart';

class AdminRoleFilterChips extends StatelessWidget {
  final String? selectedRole;
  final ValueChanged<String?> onSelected;
  final bool isArabic;
  final Map<String, int> counts;

  const AdminRoleFilterChips({
    super.key,
    required this.selectedRole,
    required this.onSelected,
    required this.isArabic,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final filters = <({String? role, String label})>[
      (role: null, label: isArabic ? 'الكل' : 'All'),
      (role: 'user', label: isArabic ? 'مستخدمون' : 'Users'),
      (role: 'engineer', label: isArabic ? 'مهندسون' : 'Engineers'),
      (role: 'company', label: isArabic ? 'شركات' : 'Companies'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedRole == filter.role;
          final countKey = filter.role ?? 'all';
          final count = counts[countKey] ?? 0;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              showCheckmark: false,
              label: Text('$count ${filter.label}'),
              selectedColor: colorScheme.primary.withValues(alpha: 0.14),
              labelStyle: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              onSelected: (_) => onSelected(filter.role),
            ),
          );
        }).toList(),
      ),
    );
  }
}
