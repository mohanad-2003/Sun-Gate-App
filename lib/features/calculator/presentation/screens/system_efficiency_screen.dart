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

class SystemEfficiencyScreen extends StatefulWidget {
  final CalculatorFlowData flowData;
  const SystemEfficiencyScreen({super.key, required this.flowData});

  @override
  State<SystemEfficiencyScreen> createState() => _SystemEfficiencyScreenState();
}

class _SystemEfficiencyScreenState extends State<SystemEfficiencyScreen> {
  final _calculator = const CalculateSolarValuesUseCase();
  final _expectedOutputController = TextEditingController();
  final _actualOutputController = TextEditingController();

  double _efficiency = 0;

  double _calculateEfficiency({bool showError = true}) {
    final loc = AppLocalizations.of(context)!;
    final result = _calculator.systemEfficiency(
      theoreticalProductionWh: readCalculatorDouble(_expectedOutputController),
      actualProductionWh: readCalculatorDouble(_actualOutputController),
    );

    setState(() {
      _efficiency = result;
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
    _expectedOutputController.dispose();
    _actualOutputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return CalculatorPageScaffold(
      title: loc.systemEfficiencyTitle,
      children: [
        CalculatorInputField(
          labelText: loc.theoreticalProduction,
          hintText: loc.theoreticalProductionHint,
          controller: _expectedOutputController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.wh,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.actualProduction,
          hintText: loc.actualProductionHint,
          controller: _actualOutputController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.wh,
        ),
        const SizedBox(height: 18),
        CalculatorPrimaryButton(
          text: loc.calculate,
          icon: Icons.calculate_outlined,
          onPressed: _calculateEfficiency,
        ),
        const SizedBox(height: 18),
        CalculatorResultCard(
          title: loc.systemEfficiency,
          value: formatCalculatorNumber(_efficiency),
          unit: '%',
          icon: Icons.percent_rounded,
        ),
        const SizedBox(height: 14),
        CalculatorPrimaryButton(
          text: loc.nextReturnOnInvestment,
          icon: Icons.arrow_forward_rounded,
          onPressed: () {
            final efficiency = _calculateEfficiency(showError: false);
            if (efficiency <= 0) {
              _showInputError(loc);
              return;
            }

            context.push(
              RouteNames.returnOnInvestment,
              extra: widget.flowData.copyWith(systemEfficiency: efficiency),
            );
          },
        ),
      ],
    );
  }
}
