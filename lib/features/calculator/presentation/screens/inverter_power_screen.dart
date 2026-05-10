import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/features/calculator/domain/entities/calculator_flow_data.dart';
import 'package:sun_gate_app/features/calculator/domain/usecases/calculate_solar_values_usecase.dart';
import 'package:sun_gate_app/features/calculator/presentation/utils/calculator_input_parser.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_page_scaffold.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';

class InverterPowerScreen extends StatefulWidget {
  final CalculatorFlowData flowData;

  const InverterPowerScreen({
    super.key,
    this.flowData = const CalculatorFlowData(),
  });

  @override
  State<InverterPowerScreen> createState() => _InverterPowerScreenState();
}

class _InverterPowerScreenState extends State<InverterPowerScreen> {
  final _calculator = const CalculateSolarValuesUseCase();
  final _continuousPowerController = TextEditingController();
  final _maximumStartController = TextEditingController();
  final _powerFactorController = TextEditingController(text: '0.8');
  final _inverterEfficiencyController = TextEditingController(text: '90');
  final _dcInputVoltageController = TextEditingController();

  double _safetyFactor = 25;
  InverterCapacityResult _result = const InverterCapacityResult.empty();

  InverterCapacityResult _calculate({bool showError = true}) {
    final loc = AppLocalizations.of(context)!;
    final result = _calculator.inverterCapacity(
      continuousPowerWatts: readCalculatorDouble(_continuousPowerController),
      maximumStartWatts: readCalculatorDouble(_maximumStartController),
      powerFactor: readCalculatorDouble(_powerFactorController),
      inverterEfficiencyPercent: readCalculatorDouble(
        _inverterEfficiencyController,
      ),
      dcInputVoltage: readCalculatorDouble(_dcInputVoltageController),
      safetyFactorPercent: _safetyFactor,
    );

    setState(() {
      _result = result;
    });

    if (showError && result.requiredWatts <= 0) {
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
    _continuousPowerController.dispose();
    _maximumStartController.dispose();
    _powerFactorController.dispose();
    _inverterEfficiencyController.dispose();
    _dcInputVoltageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return CalculatorPageScaffold(
      title: loc.inverterCapacityTitle,
      children: [
        CalculatorInputField(
          labelText: loc.totalContinuousPowerDevices,
          hintText: loc.totalContinuousPowerHint,
          controller: _continuousPowerController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.watt,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.maximumInstantaneousStart,
          hintText: loc.maximumInstantaneousStartHint,
          controller: _maximumStartController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.watt,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.powerFactor,
          hintText: loc.powerFactorHint,
          controller: _powerFactorController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
          labelText: loc.dcInputVoltage,
          hintText: loc.dcInputVoltageHint,
          controller: _dcInputVoltageController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.volt,
        ),
        const SizedBox(height: 18),
        Text(
          loc.inverterSafetyFactor,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Slider(
          value: _safetyFactor,
          min: 0,
          max: 50,
          divisions: 50,
          label: '${_safetyFactor.toStringAsFixed(0)}%',
          onChanged: (value) {
            setState(() {
              _safetyFactor = value;
            });
          },
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: Text('${_safetyFactor.toStringAsFixed(0)}%'),
          ),
        ),
        const SizedBox(height: 18),
        CalculatorPrimaryButton(
          text: loc.calculate,
          icon: Icons.calculate_outlined,
          onPressed: _calculate,
        ),
        const SizedBox(height: 18),
        CalculatorResultCard(
          title: loc.requiredContinuousPower,
          value: formatCalculatorNumber(_result.requiredWatts),
          unit: '${loc.watt} / ${loc.voltAmpere}',
          subtitle:
              '${formatCalculatorNumber(_result.requiredVa)} ${loc.voltAmpere}',
          icon: Icons.offline_bolt_outlined,
        ),
        const SizedBox(height: 12),
        CalculatorResultCard(
          title: loc.dcCurrent,
          value: formatCalculatorNumber(_result.dcCurrent),
          unit: loc.ampere,
          icon: Icons.electrical_services_outlined,
        ),
      ],
    );
  }
}
