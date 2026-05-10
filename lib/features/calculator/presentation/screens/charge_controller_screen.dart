import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/features/calculator/domain/usecases/calculate_solar_values_usecase.dart';
import 'package:sun_gate_app/features/calculator/presentation/utils/calculator_input_parser.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_page_scaffold.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';

class ChargeControllerScreen extends StatefulWidget {
  const ChargeControllerScreen({super.key});

  @override
  State<ChargeControllerScreen> createState() => _ChargeControllerScreenState();
}

class _ChargeControllerScreenState extends State<ChargeControllerScreen> {
  final _calculator = const CalculateSolarValuesUseCase();
  final _batteryVoltageController = TextEditingController();
  final _shortCircuitCurrentController = TextEditingController();
  final _panelsInParallelController = TextEditingController(text: '1');

  String _controllerType = 'MPPT';
  ChargeControllerResult _result = const ChargeControllerResult.empty();

  ChargeControllerResult _calculate({bool showError = true}) {
    final loc = AppLocalizations.of(context)!;
    final result = _calculator.chargeController(
      batteryVoltage: readCalculatorDouble(_batteryVoltageController),
      shortCircuitCurrentPerPanel: readCalculatorDouble(
        _shortCircuitCurrentController,
      ),
      panelsInParallel: readCalculatorDouble(_panelsInParallelController),
    );

    setState(() {
      _result = result;
    });

    if (showError && result.requiredCurrent <= 0) {
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
    _batteryVoltageController.dispose();
    _shortCircuitCurrentController.dispose();
    _panelsInParallelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return CalculatorPageScaffold(
      title: loc.chargeControllerTitle,
      children: [
        Text(
          loc.chargeControllerType,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.65),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _controllerType,
              isExpanded: true,
              borderRadius: BorderRadius.circular(14),
              items: const [
                DropdownMenuItem(value: 'MPPT', child: Text('MPPT')),
                DropdownMenuItem(value: 'PWM', child: Text('PWM')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _controllerType = value;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.batterySystemVoltage,
          hintText: loc.batterySystemVoltageHint,
          controller: _batteryVoltageController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.volt,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.shortCircuitCurrentPerPanel,
          hintText: loc.shortCircuitCurrentHint,
          controller: _shortCircuitCurrentController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.ampere,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.panelsInParallel,
          hintText: loc.panelsInParallelHint,
          controller: _panelsInParallelController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 18),
        CalculatorPrimaryButton(
          text: loc.calculate,
          icon: Icons.calculate_outlined,
          onPressed: _calculate,
        ),
        const SizedBox(height: 18),
        CalculatorResultCard(
          title: loc.requiredControllerCurrent,
          value: formatCalculatorNumber(_result.requiredCurrent),
          unit: loc.ampere,
          subtitle:
              '${loc.supportedArrayPower}: ${formatCalculatorNumber(_result.supportedArrayPower)} ${loc.watt}',
          icon: Icons.settings_input_component_outlined,
        ),
      ],
    );
  }
}
