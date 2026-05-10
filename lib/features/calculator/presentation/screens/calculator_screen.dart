import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/widgets/language_switcher_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calcultor_option_card.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    final items = <_CalculatorMenuItem>[
      _CalculatorMenuItem(
        title: loc.deviceConsumptionTitle,
        subtitle: loc.deviceConsumptionMenuSubtitle,
        icon: Icons.devices_outlined,
        route: RouteNames.deviceConsumption,
      ),
      _CalculatorMenuItem(
        title: loc.numberOfPanelsTitle,
        subtitle: loc.numberOfPanelsMenuSubtitle,
        icon: Icons.grid_view_rounded,
        route: RouteNames.numberOfPanels,
      ),
      _CalculatorMenuItem(
        title: loc.batteryCapacityTitle,
        subtitle: loc.batteryCapacityMenuSubtitle,
        icon: Icons.battery_charging_full_rounded,
        route: RouteNames.batteryCapacity,
      ),
      _CalculatorMenuItem(
        title: loc.inverterCapacityTitle,
        subtitle: loc.inverterCapacityMenuSubtitle,
        icon: Icons.offline_bolt_outlined,
        route: RouteNames.inverterPower,
      ),
      _CalculatorMenuItem(
        title: loc.wireCrossSectionTitle,
        subtitle: loc.wireCrossSectionMenuSubtitle,
        icon: Icons.cable_rounded,
        route: RouteNames.wireCrossSection,
      ),
      _CalculatorMenuItem(
        title: loc.chargeControllerTitle,
        subtitle: loc.chargeControllerMenuSubtitle,
        icon: Icons.settings_input_component_outlined,
        route: RouteNames.chargeController,
      ),
      _CalculatorMenuItem(
        title: loc.tiltOfPanelsTitle,
        subtitle: loc.tiltOfPanelsMenuSubtitle,
        icon: Icons.wb_sunny_outlined,
        route: RouteNames.tiltOfPanels,
      ),
      _CalculatorMenuItem(
        title: loc.systemEfficiencyTitle,
        subtitle: loc.systemEfficiencyMenuSubtitle,
        icon: Icons.percent_rounded,
        route: RouteNames.systemEfficiency,
      ),
      _CalculatorMenuItem(
        title: loc.returnOnInvestmentTitle,
        subtitle: loc.returnOnInvestmentMenuSubtitle,
        icon: Icons.trending_up_rounded,
        route: RouteNames.returnOnInvestment,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = width < 360 ? 14.0 : 20.0;
            final useGrid = width >= 700;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        14,
                        horizontalPadding,
                        10,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.solarCalculatorTitle,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    loc.solarCalculatorSubtitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const LanguageSwitcherButton(),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        8,
                        horizontalPadding,
                        20,
                      ),
                      sliver: useGrid
                          ? SliverGrid(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final item = items[index];
                                return CalculatorOptionCard(
                                  title: item.title,
                                  subtitle: item.subtitle,
                                  icon: item.icon,
                                  onTap: () => context.push(item.route),
                                );
                              }, childCount: items.length),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                    childAspectRatio: 3.2,
                                  ),
                            )
                          : SliverList.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
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
          },
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
