import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/data/models/calculate_flow_data.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_app_bar.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';

class SystemEfficiencyScreen extends StatefulWidget {
  final CalculatorFlowData flowData;
  const SystemEfficiencyScreen({super.key, required this.flowData});

  @override
  State<SystemEfficiencyScreen> createState() => _SystemEfficiencyScreenState();
}

class _SystemEfficiencyScreenState extends State<SystemEfficiencyScreen> {
  final TextEditingController _expectedOutputController =
      TextEditingController();
  final TextEditingController _actualOutputController = TextEditingController();

  double _efficiency = 0;

  void _calculateEfficiency() {
    final expected =
        double.tryParse(_expectedOutputController.text.trim()) ?? 0;
    final actual = double.tryParse(_actualOutputController.text.trim()) ?? 0;

    if (expected <= 0 || actual < 0) {
      setState(() {
        _efficiency = 0;
      });
      return;
    }

    final result = (actual / expected) * 100;

    setState(() {
      _efficiency = result;
    });
  }

  @override
  void dispose() {
    _expectedOutputController.dispose();
    _actualOutputController.dispose();
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
              'Enter the expected system output and the actual measured output to estimate the overall efficiency.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),

            CalculatorInputField(
              hintText: 'Expected output (Wh)',
              controller: _expectedOutputController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),

            CalculatorInputField(
              hintText: 'Actual output (Wh)',
              controller: _actualOutputController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 18),

            CalculatorPrimaryButton(
              text: 'Calculate',
              onPressed: _calculateEfficiency,
            ),
            const SizedBox(height: 18),

            CalculatorResultCard(
              title: 'System efficiency',
              value: _efficiency.toStringAsFixed(2),
              unit: '%',
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
                'Formula used:\nEfficiency = (Actual output ÷ Expected output) × 100',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ),
            SizedBox(height: 12),
            CalculatorPrimaryButton(
              text: 'Next: Return on investment',
              onPressed: () {
                final updatedDate = widget.flowData.copyWith(
                  systemEfficiency: _efficiency,
                );
                context.go(RouteNames.returnOnInvestment, extra: updatedDate);
              },
            ),
          ],
        ),
      ),
    );
  }
}
