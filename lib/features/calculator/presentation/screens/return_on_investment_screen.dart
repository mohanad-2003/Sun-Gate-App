import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/data/models/calculate_flow_data.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_app_bar.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';

class ReturnOnInvestmentScreen extends StatefulWidget {
  final CalculatorFlowData flowData;
  const ReturnOnInvestmentScreen({super.key, required this.flowData});

  @override
  State<ReturnOnInvestmentScreen> createState() =>
      _ReturnOnInvestmentScreenState();
}

class _ReturnOnInvestmentScreenState extends State<ReturnOnInvestmentScreen> {
  final TextEditingController _systemCostController = TextEditingController();
  final TextEditingController _annualSavingsController =
      TextEditingController();

  double _roiYears = 0;

  void _calculateRoi() {
    final systemCost = double.tryParse(_systemCostController.text.trim()) ?? 0;
    final annualSavings =
        double.tryParse(_annualSavingsController.text.trim()) ?? 0;

    if (systemCost <= 0 || annualSavings <= 0) {
      setState(() {
        _roiYears = 0;
      });
      return;
    }

    final result = systemCost / annualSavings;

    setState(() {
      _roiYears = result;
    });
  }

  @override
  void dispose() {
    _systemCostController.dispose();
    _annualSavingsController.dispose();
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
              'Enter the total system cost and the estimated annual savings to calculate how many years it may take to recover the investment.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),

            CalculatorInputField(
              hintText: 'System cost (\$)',
              controller: _systemCostController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),

            CalculatorInputField(
              hintText: 'Annual savings (\$)',
              controller: _annualSavingsController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 18),

            CalculatorPrimaryButton(
              text: 'Calculate',
              onPressed: _calculateRoi,
            ),
            const SizedBox(height: 18),

            CalculatorResultCard(
              title: 'Estimated payback period',
              value: _roiYears.toStringAsFixed(2),
              unit: 'years',
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
                'Formula used:\nPayback period = System cost ÷ Annual savings',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.55),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculation summary',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Daily consumption: ${widget.flowData.dailyConsumption.toStringAsFixed(2)} Wh',
                  ),
                  Text(
                    'Number of panels: ${widget.flowData.numberOfPanels.toStringAsFixed(2)}',
                  ),
                  Text(
                    'Battery capacity: ${widget.flowData.batteryCapacity.toStringAsFixed(2)} Ah',
                  ),
                  Text(
                    'Tilt angle: ${widget.flowData.tiltAngle.toStringAsFixed(1)}°',
                  ),
                  Text(
                    'System efficiency: ${widget.flowData.systemEfficiency.toStringAsFixed(2)}%',
                  ),
                  Text('ROI: ${_roiYears.toStringAsFixed(2)} years'),
                ],
              ),
            ),
            const SizedBox(height: 14),

            CalculatorPrimaryButton(
              text: 'View final summary',
              onPressed: () {
                final updatedData = widget.flowData.copyWith(
                  roiYears: _roiYears,
                );

                context.push(RouteNames.calculatorSummary, extra: updatedData);
              },
            ),
          ],
        ),
      ),
    );
  }
}
