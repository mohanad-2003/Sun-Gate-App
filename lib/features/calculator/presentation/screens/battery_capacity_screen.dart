import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/data/models/calculate_flow_data.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_app_bar.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';

class BatteryCapacityScreen extends StatefulWidget {
  final CalculatorFlowData flowData;
  const BatteryCapacityScreen({super.key, required this.flowData});

  @override
  State<BatteryCapacityScreen> createState() => _BatteryCapacityScreenState();
}

class _BatteryCapacityScreenState extends State<BatteryCapacityScreen> {
  final TextEditingController _dailyConsumptionController =
      TextEditingController();
  final TextEditingController _batteryVoltageController =
      TextEditingController();
  final TextEditingController _backupDaysController = TextEditingController();
  final TextEditingController _depthOfDischargeController =
      TextEditingController();

  double _batteryCapacity = 0;
  @override
  void initState() {
    super.initState();
    if (widget.flowData.dailyConsumption > 0) {
      _dailyConsumptionController.text = widget.flowData.dailyConsumption
          .toStringAsFixed(2);
    }
  }

  void _calculateBatteryCapacity() {
    final dailyConsumption =
        double.tryParse(_dailyConsumptionController.text.trim()) ?? 0;
    final batteryVoltage =
        double.tryParse(_batteryVoltageController.text.trim()) ?? 0;
    final backupDays = double.tryParse(_backupDaysController.text.trim()) ?? 0;
    final depthOfDischarge =
        double.tryParse(_depthOfDischargeController.text.trim()) ?? 0;

    if (dailyConsumption <= 0 ||
        batteryVoltage <= 0 ||
        backupDays <= 0 ||
        depthOfDischarge <= 0) {
      setState(() {
        _batteryCapacity = 0;
      });
      return;
    }

    final dod = depthOfDischarge / 100;

    if (dod <= 0 || dod > 1) {
      setState(() {
        _batteryCapacity = 0;
      });
      return;
    }

    final result = (dailyConsumption * backupDays) / (batteryVoltage * dod);

    setState(() {
      _batteryCapacity = result;
    });
  }

  @override
  void dispose() {
    _dailyConsumptionController.dispose();
    _batteryVoltageController.dispose();
    _backupDaysController.dispose();
    _depthOfDischargeController.dispose();
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
              'Enter your daily energy consumption, battery voltage, backup days, and depth of discharge to estimate the required battery capacity.',
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
              hintText: 'Battery voltage (V)',
              controller: _batteryVoltageController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            CalculatorInputField(
              hintText: 'Backup days',
              controller: _backupDaysController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            CalculatorInputField(
              hintText: 'Depth of discharge (%)',
              controller: _depthOfDischargeController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 18),

            CalculatorPrimaryButton(
              text: 'Calculate',
              onPressed: _calculateBatteryCapacity,
            ),
            const SizedBox(height: 18),

            CalculatorResultCard(
              title: 'Required battery capacity',
              value: _batteryCapacity.toStringAsFixed(2),
              unit: 'Ah',
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
                'Formula used:\nBattery capacity = (Daily consumption × Backup days) ÷ (Battery voltage × Depth of discharge)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 12),

            CalculatorPrimaryButton(
              text: 'Next: Tilt of panels',
              onPressed: () {
                final updatedData = widget.flowData.copyWith(
                  dailyConsumption:
                      double.tryParse(
                        _dailyConsumptionController.text.trim(),
                      ) ??
                      0,
                  numberOfPanels: widget.flowData.numberOfPanels,
                  batteryCapacity: _batteryCapacity,
                );

                context.push(RouteNames.tiltOfPanels, extra: updatedData);
              },
            ),
          ],
        ),
      ),
    );
  }
}
