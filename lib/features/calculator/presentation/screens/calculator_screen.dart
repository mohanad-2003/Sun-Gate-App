import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calcultor_option_card.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 14.0 : 16.0;

    final items = <_CalculatorMenuItem>[
      const _CalculatorMenuItem(
        title: 'Device consumption',
        subtitle: 'Calculate daily energy usage based on devices.',
        icon: Icons.devices_outlined,
        route: RouteNames.deviceConsumption,
      ),
      const _CalculatorMenuItem(
        title: 'Number of panels',
        subtitle: 'Estimate required solar panels.',
        icon: Icons.grid_view_rounded,
        route: RouteNames.numberOfPanels,
      ),
      const _CalculatorMenuItem(
        title: 'Battery capacity',
        subtitle: 'Determine required battery storage.',
        icon: Icons.battery_charging_full_rounded,
        route: RouteNames.batteryCapacity,
      ),
      const _CalculatorMenuItem(
        title: 'Tilt of panels',
        subtitle: 'Find optimal panel angle.',
        icon: Icons.wb_sunny_outlined,
        route: RouteNames.tiltOfPanels,
      ),
      const _CalculatorMenuItem(
        title: 'System efficiency',
        subtitle: 'Compare expected vs actual output.',
        icon: Icons.percent_rounded,
        route: RouteNames.systemEfficiency,
      ),
      const _CalculatorMenuItem(
        title: 'ROI',
        subtitle: 'Calculate investment return period.',
        icon: Icons.savings_outlined,
        route: RouteNames.returnOnInvestment,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 🔥 Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solar Calculator',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Use smart tools to estimate your solar system needs.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            // 🔥 القائمة
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  8,
                  horizontalPadding,
                  16,
                ),
                itemCount: items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return CalculatorOptionCard(
                    title: item.title,
                    subtitle: item.subtitle,
                    icon: item.icon,
                    onTap: () => context.push(item.route),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatorMenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const _CalculatorMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });
}
