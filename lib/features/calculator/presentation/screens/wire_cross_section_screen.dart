import 'package:flutter/material.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/features/calculator/domain/usecases/calculate_solar_values_usecase.dart';
import 'package:sun_gate_app/features/calculator/presentation/utils/calculator_input_parser.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_page_scaffold.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';

class WireCrossSectionScreen extends StatefulWidget {
  const WireCrossSectionScreen({super.key});

  @override
  State<WireCrossSectionScreen> createState() => _WireCrossSectionScreenState();
}

class _WireCrossSectionScreenState extends State<WireCrossSectionScreen> {
  final _calculator = const CalculateSolarValuesUseCase();
  final _loadPowerController = TextEditingController();
  final _systemVoltageController = TextEditingController();
  final _distanceController = TextEditingController();

  WireCrossSectionResult _result = const WireCrossSectionResult.empty();

  WireCrossSectionResult _calculate({bool showError = true}) {
    final loc = AppLocalizations.of(context)!;
    final result = _calculator.wireCrossSection(
      loadPowerWatts: readCalculatorDouble(_loadPowerController),
      systemVoltage: readCalculatorDouble(_systemVoltageController),
      distanceMeters: readCalculatorDouble(_distanceController),
    );

    setState(() {
      _result = result;
    });

    if (showError && result.recommendedSectionMm2 <= 0) {
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
    _loadPowerController.dispose();
    _systemVoltageController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return CalculatorPageScaffold(
      title: loc.wireCrossSectionTitle,
      children: [
        CalculatorInputField(
          labelText: loc.totalLoadPower,
          hintText: loc.totalLoadPowerHint,
          controller: _loadPowerController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.watt,
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
          labelText: loc.distanceFromSourceLoad,
          hintText: loc.distanceFromSourceLoadHint,
          controller: _distanceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.meter,
        ),
        const SizedBox(height: 18),
        CalculatorPrimaryButton(
          text: loc.calculate,
          icon: Icons.calculate_outlined,
          onPressed: _calculate,
        ),
        const SizedBox(height: 18),
        CalculatorResultCard(
          title: loc.requiredCableSection,
          value: formatCalculatorNumber(_result.recommendedSectionMm2),
          unit: loc.squareMillimeter,
          subtitle:
              '${loc.current}: ${formatCalculatorNumber(_result.current)} ${loc.ampere}',
          icon: Icons.cable_rounded,
        ),
        const SizedBox(height: 12),
        CalculatorResultCard(
          title: loc.recommendedBreaker,
          value: formatCalculatorNumber(
            _result.breakerAmpere,
            fractionDigits: 0,
          ),
          unit: loc.ampere,
          icon: Icons.power_settings_new_rounded,
        ),
      ],
    );
  }
}
