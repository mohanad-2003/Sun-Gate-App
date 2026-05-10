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

class ReturnOnInvestmentScreen extends StatefulWidget {
  final CalculatorFlowData flowData;
  const ReturnOnInvestmentScreen({super.key, required this.flowData});

  @override
  State<ReturnOnInvestmentScreen> createState() =>
      _ReturnOnInvestmentScreenState();
}

class _ReturnOnInvestmentScreenState extends State<ReturnOnInvestmentScreen> {
  final _calculator = const CalculateSolarValuesUseCase();
  final _systemCostController = TextEditingController();
  final _dailyOutputController = TextEditingController();
  final _pricePerKwhController = TextEditingController();

  double _roiYears = 0;

  @override
  void initState() {
    super.initState();
    if (widget.flowData.dailyConsumption > 0) {
      _dailyOutputController.text = widget.flowData.dailyConsumption
          .toStringAsFixed(2);
    }
  }

  double _calculateRoi({bool showError = true}) {
    final loc = AppLocalizations.of(context)!;
    final result = _calculator.returnOnInvestmentYears(
      totalSystemCost: readCalculatorDouble(_systemCostController),
      expectedDailyOutputWh: readCalculatorDouble(_dailyOutputController),
      pricePerKwh: readCalculatorDouble(_pricePerKwhController),
    );

    setState(() {
      _roiYears = result;
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
    _systemCostController.dispose();
    _dailyOutputController.dispose();
    _pricePerKwhController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return CalculatorPageScaffold(
      title: loc.returnOnInvestmentTitle,
      children: [
        CalculatorInputField(
          labelText: loc.totalSystemCost,
          hintText: loc.totalSystemCostHint,
          controller: _systemCostController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.expectedDailyOutput,
          hintText: loc.expectedDailyOutputHint,
          controller: _dailyOutputController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.wh,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.pricePerKilowattHour,
          hintText: loc.pricePerKilowattHourHint,
          controller: _pricePerKwhController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 18),
        CalculatorPrimaryButton(
          text: loc.calculate,
          icon: Icons.calculate_outlined,
          onPressed: _calculateRoi,
        ),
        const SizedBox(height: 18),
        CalculatorResultCard(
          title: loc.estimatedPaybackPeriod,
          value: formatCalculatorNumber(_roiYears),
          unit: loc.years,
          icon: Icons.savings_outlined,
        ),
        const SizedBox(height: 14),
        CalculatorPrimaryButton(
          text: loc.viewFinalSummary,
          icon: Icons.summarize_outlined,
          onPressed: () {
            final roi = _calculateRoi(showError: false);
            if (roi <= 0) {
              _showInputError(loc);
              return;
            }

            context.push(
              RouteNames.calculatorSummary,
              extra: widget.flowData.copyWith(roiYears: roi),
            );
          },
        ),
      ],
    );
  }
}
