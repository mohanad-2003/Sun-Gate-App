import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/features/calculator/domain/entities/calculator_flow_data.dart';
import 'package:sun_gate_app/features/calculator/presentation/utils/calculator_input_parser.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_page_scaffold.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/summary_bar_chart.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/summary_efficiency_gauge.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/summary_matric_card.dart';

class CalculatorSummaryScreen extends StatelessWidget {
  final CalculatorFlowData flowData;

  const CalculatorSummaryScreen({super.key, required this.flowData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;

    return CalculatorPageScaffold(
      title: loc.calculationSummaryTitle,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.systemOverview,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                loc.systemOverviewSubtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: width < 380 ? 1 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: width < 380 ? 2.8 : 1.55,
          children: [
            SummaryMetricCard(
              title: loc.totalDailyConsumption,
              value: formatCalculatorNumber(flowData.dailyConsumption),
              unit: loc.wh,
              icon: Icons.electric_bolt_rounded,
            ),
            SummaryMetricCard(
              title: loc.numberOfPanelsRequired,
              value: formatCalculatorNumber(
                flowData.numberOfPanels,
                fractionDigits: 0,
              ),
              unit: loc.panel,
              icon: Icons.grid_view_rounded,
            ),
            SummaryMetricCard(
              title: loc.requiredBatteryCapacity,
              value: formatCalculatorNumber(flowData.batteryCapacity),
              unit: loc.ampereHour,
              icon: Icons.battery_charging_full_rounded,
            ),
            SummaryMetricCard(
              title: loc.selectedDateTilt,
              value: formatCalculatorNumber(
                flowData.tiltAngle,
                fractionDigits: 1,
              ),
              unit: loc.degree,
              icon: Icons.wb_sunny_outlined,
            ),
            SummaryMetricCard(
              title: loc.systemEfficiency,
              value: formatCalculatorNumber(flowData.systemEfficiency),
              unit: '%',
              icon: Icons.percent_rounded,
            ),
            SummaryMetricCard(
              title: loc.estimatedPaybackPeriod,
              value: formatCalculatorNumber(flowData.roiYears),
              unit: loc.years,
              icon: Icons.trending_up_rounded,
            ),
          ],
        ),
        const SizedBox(height: 18),
        SummaryEfficiencyGauge(value: flowData.systemEfficiency),
        const SizedBox(height: 18),
        SummaryBarChart(
          dailyConsumption: flowData.dailyConsumption,
          numberOfPanels: flowData.numberOfPanels,
          batteryCapacity: flowData.batteryCapacity,
          tiltAngle: flowData.tiltAngle,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.quickRecommendation,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _buildRecommendation(loc),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _buildRecommendation(AppLocalizations loc) {
    final efficiencyText = flowData.systemEfficiency >= 85
        ? loc.good
        : flowData.systemEfficiency >= 70
        ? loc.average
        : loc.needsImprovement;

    return '${loc.summaryRecommendationPrefix} '
        '${formatCalculatorNumber(flowData.numberOfPanels, fractionDigits: 0)} '
        '${loc.panel}, '
        '${formatCalculatorNumber(flowData.batteryCapacity, fractionDigits: 0)} '
        '${loc.ampereHour}, '
        '${formatCalculatorNumber(flowData.tiltAngle, fractionDigits: 1)}'
        '${loc.degree}. ${loc.summaryEfficiencyPrefix} $efficiencyText. '
        '${loc.summaryRoiPrefix} '
        '${formatCalculatorNumber(flowData.roiYears, fractionDigits: 1)} '
        '${loc.years}.';
  }
}
