import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/features/calculator/data/models/calculate_flow_data.dart';
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Calculation Summary'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            24,
          ),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.45),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System overview',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This summary combines all results from the calculator and gives a quick overview of your estimated solar system.',
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
              crossAxisCount: screenWidth < 380 ? 1 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: screenWidth < 380 ? 2.8 : 1.55,
              children: [
                SummaryMetricCard(
                  title: 'Daily consumption',
                  value: flowData.dailyConsumption.toStringAsFixed(2),
                  unit: 'Wh',
                  icon: Icons.electric_bolt_rounded,
                ),
                SummaryMetricCard(
                  title: 'Panels required',
                  value: flowData.numberOfPanels.toStringAsFixed(2),
                  unit: 'panel',
                  icon: Icons.grid_view_rounded,
                ),
                SummaryMetricCard(
                  title: 'Battery capacity',
                  value: flowData.batteryCapacity.toStringAsFixed(2),
                  unit: 'Ah',
                  icon: Icons.battery_charging_full_rounded,
                ),
                SummaryMetricCard(
                  title: 'Tilt angle',
                  value: flowData.tiltAngle.toStringAsFixed(1),
                  unit: '°',
                  icon: Icons.wb_sunny_outlined,
                ),
                SummaryMetricCard(
                  title: 'System efficiency',
                  value: flowData.systemEfficiency.toStringAsFixed(2),
                  unit: '%',
                  icon: Icons.percent_rounded,
                ),
                SummaryMetricCard(
                  title: 'ROI period',
                  value: flowData.roiYears.toStringAsFixed(2),
                  unit: 'years',
                  icon: Icons.savings_outlined,
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
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.45),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick recommendation',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _buildRecommendation(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _buildRecommendation() {
    final efficiencyText = flowData.systemEfficiency >= 85
        ? 'good'
        : flowData.systemEfficiency >= 70
        ? 'acceptable'
        : 'low';

    return 'Your estimated system requires around ${flowData.numberOfPanels.toStringAsFixed(0)} panels and '
        '${flowData.batteryCapacity.toStringAsFixed(0)} Ah of battery storage. '
        'The suggested tilt angle is ${flowData.tiltAngle.toStringAsFixed(1)}°. '
        'The current estimated system efficiency is $efficiencyText, and the investment may be recovered in '
        '${flowData.roiYears.toStringAsFixed(1)} years.';
  }
}
