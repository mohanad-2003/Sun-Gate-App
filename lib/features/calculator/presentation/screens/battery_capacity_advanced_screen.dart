import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/domain/entities/calculator_flow_data.dart';
import 'package:sun_gate_app/features/calculator/domain/usecases/calculate_solar_values_usecase.dart';
import 'package:sun_gate_app/features/calculator/presentation/utils/calculator_input_parser.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_page_scaffold.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';

class BatteryCapacityAdvancedScreen extends StatefulWidget {
  final CalculatorFlowData flowData;

  const BatteryCapacityAdvancedScreen({super.key, required this.flowData});

  @override
  State<BatteryCapacityAdvancedScreen> createState() =>
      _BatteryCapacityAdvancedScreenState();
}

class _BatteryCapacityAdvancedScreenState
    extends State<BatteryCapacityAdvancedScreen> {
  final _calculator = const CalculateSolarValuesUseCase();
  final _dailyConsumptionController = TextEditingController();
  final _systemVoltageController = TextEditingController(text: '48');
  final _daysOfAutonomyController = TextEditingController(text: '2');
  final _depthOfDischargeController = TextEditingController(text: '50');
  final _inverterEfficiencyController = TextEditingController(text: '90');
  final _minimumTemperatureController = TextEditingController(text: '10');

  double _batteryCapacity = 0;

  @override
  void initState() {
    super.initState();
    if (widget.flowData.dailyConsumption > 0) {
      _dailyConsumptionController.text = widget.flowData.dailyConsumption
          .toStringAsFixed(2);
    }
  }

  double _calculate({bool showError = true}) {
    final loc = AppLocalizations.of(context)!;
    final result = _calculator.advancedBatteryCapacityAh(
      dailyConsumptionWh: readCalculatorDouble(_dailyConsumptionController),
      systemVoltage: readCalculatorDouble(_systemVoltageController),
      daysOfAutonomy: readCalculatorDouble(_daysOfAutonomyController),
      depthOfDischargePercent: readCalculatorDouble(
        _depthOfDischargeController,
      ),
      inverterEfficiencyPercent: readCalculatorDouble(
        _inverterEfficiencyController,
      ),
      minimumTemperatureC: readCalculatorDouble(_minimumTemperatureController),
    );

    setState(() {
      _batteryCapacity = result;
    });

    if (showError && result <= 0) {
      _showInputError(loc);
    }

    return result;
  }

  void _showInputError(AppLocalizations loc) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.calculatorInvalidInputs)));
  }

  @override
  void dispose() {
    _dailyConsumptionController.dispose();
    _systemVoltageController.dispose();
    _daysOfAutonomyController.dispose();
    _depthOfDischargeController.dispose();
    _inverterEfficiencyController.dispose();
    _minimumTemperatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return CalculatorPageScaffold(
      title: loc.batteryCapacityTitle,
      children: [
        CalculatorInputField(
          labelText: loc.totalDailyConsumption,
          hintText: loc.dailyConsumptionWhHint,
          controller: _dailyConsumptionController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.wh,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.systemVoltage,
          hintText: loc.systemVoltageHint,
          controller: _systemVoltageController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.volt,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.daysOfAutonomy,
          hintText: loc.daysOfAutonomyHint,
          controller: _daysOfAutonomyController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.depthOfDischarge,
          hintText: loc.depthOfDischargeHint,
          controller: _depthOfDischargeController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: '%',
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.inverterEfficiency,
          hintText: loc.inverterEfficiencyHint,
          controller: _inverterEfficiencyController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: '%',
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.minimumExpectedTemperature,
          hintText: loc.minimumTemperatureHint,
          controller: _minimumTemperatureController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
          suffixText: loc.celsius,
        ),
        const SizedBox(height: 18),
        CalculatorPrimaryButton(
          text: loc.calculate,
          icon: Icons.calculate_outlined,
          onPressed: _calculate,
        ),
        const SizedBox(height: 18),
        CalculatorResultCard(
          title: loc.requiredBatteryCapacity,
          value: formatCalculatorNumber(_batteryCapacity),
          unit: loc.ampereHour,
          icon: Icons.battery_saver_outlined,
        ),
        const SizedBox(height: 14),
        CalculatorPrimaryButton(
          text: loc.nextTiltOfPanels,
          icon: Icons.arrow_forward_rounded,
          onPressed: () {
            final capacity = _calculate(showError: false);
            if (capacity <= 0) {
              _showInputError(loc);
              return;
            }

            context.push(
              RouteNames.tiltOfPanels,
              extra: widget.flowData.copyWith(
                dailyConsumption: readCalculatorDouble(
                  _dailyConsumptionController,
                ),
                batteryCapacity: capacity,
              ),
            );
          },
        ),
      ],
    );
  }
}
