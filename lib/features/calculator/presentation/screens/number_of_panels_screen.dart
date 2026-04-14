import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/data/models/calculate_flow_data.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_app_bar.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';

class NumberOfPanelsScreen extends StatefulWidget {
  final CalculatorFlowData flowData;

  const NumberOfPanelsScreen({super.key, required this.flowData});

  @override
  State<NumberOfPanelsScreen> createState() => _NumberOfPanelsScreenState();
}

class _NumberOfPanelsScreenState extends State<NumberOfPanelsScreen> {
  final TextEditingController _dailyConsumptionController =
      TextEditingController();
  final TextEditingController _panelPowerController = TextEditingController();
  final TextEditingController _sunHoursController = TextEditingController();

  double _numberOfPanels = 0;
  @override
  void initState() {
    super.initState();
    if (widget.flowData.dailyConsumption > 0) {
      _dailyConsumptionController.text = widget.flowData.dailyConsumption
          .toStringAsFixed(2);
    }
  }

  void _calculatePanels() {
    final dailyConsumption =
        double.tryParse(_dailyConsumptionController.text.trim()) ?? 0;
    final panelPower = double.tryParse(_panelPowerController.text.trim()) ?? 0;
    final sunHours = double.tryParse(_sunHoursController.text.trim()) ?? 0;

    if (dailyConsumption <= 0 || panelPower <= 0 || sunHours <= 0) {
      setState(() {
        _numberOfPanels = 0;
      });
      return;
    }

    final panelProductionPerDay = panelPower * sunHours;
    final result = dailyConsumption / panelProductionPerDay;

    setState(() {
      _numberOfPanels = result;
    });
  }

  @override
  void dispose() {
    _dailyConsumptionController.dispose();
    _panelPowerController.dispose();
    _sunHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CalculatorAppBar(title: 'Return on investment'),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            20,
          ),
          children: [
            Text(
              'Enter your daily energy consumption, the panel power, and the average sunlight hours to estimate how many panels you need.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),

            CalculatorInputField(
              hintText: 'Daily consumption (Wh)',
              controller: _dailyConsumptionController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            CalculatorInputField(
              hintText: 'Panel power (W)',
              controller: _panelPowerController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            CalculatorInputField(
              hintText: 'Average sun hours per day',
              controller: _sunHoursController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 18),

            CalculatorPrimaryButton(
              text: 'Calculate',
              onPressed: _calculatePanels,
            ),
            const SizedBox(height: 18),

            CalculatorResultCard(
              title: 'Required number of panels',
              value: _numberOfPanels.toStringAsFixed(2),
              unit: 'panel',
            ),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.55),
                ),
              ),
              child: Text(
                'Formula used:\nNumber of panels = Daily consumption ÷ (Panel power × Sun hours)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 12),

            CalculatorPrimaryButton(
              text: 'Next: Battery capacity',
              onPressed: () {
                final updatedData = widget.flowData.copyWith(
                  dailyConsumption:
                      double.tryParse(
                        _dailyConsumptionController.text.trim(),
                      ) ??
                      0,
                  numberOfPanels: _numberOfPanels,
                );

                context.push(RouteNames.batteryCapacity, extra: updatedData);
              },
            ),
          ],
        ),
      ),
    );
  }
}
