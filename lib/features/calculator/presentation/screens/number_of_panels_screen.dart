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

class NumberOfPanelsScreen extends StatefulWidget {
  final CalculatorFlowData flowData;

  const NumberOfPanelsScreen({super.key, required this.flowData});

  @override
  State<NumberOfPanelsScreen> createState() => _NumberOfPanelsScreenState();
}

class _NumberOfPanelsScreenState extends State<NumberOfPanelsScreen> {
  final _calculator = const CalculateSolarValuesUseCase();
  final _dailyConsumptionController = TextEditingController();
  final _panelPowerController = TextEditingController();
  final _sunHoursController = TextEditingController();

  bool _isOffGrid = true;
  double _systemEfficiency = 85;
  double _numberOfPanels = 0;

  @override
  void initState() {
    super.initState();
    if (widget.flowData.dailyConsumption > 0) {
      _dailyConsumptionController.text = widget.flowData.dailyConsumption
          .toStringAsFixed(2);
    }
  }

  double _calculatePanels({bool showError = true}) {
    final loc = AppLocalizations.of(context)!;
    final result = _calculator.numberOfPanels(
      dailyConsumptionWh: readCalculatorDouble(_dailyConsumptionController),
      panelPowerWatts: readCalculatorDouble(_panelPowerController),
      peakSunHours: readCalculatorDouble(_sunHoursController),
      systemEfficiencyPercent: _systemEfficiency,
      isOffGrid: _isOffGrid,
    );

    setState(() {
      _numberOfPanels = result;
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
    _panelPowerController.dispose();
    _sunHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return CalculatorPageScaffold(
      title: loc.numberOfPanelsTitle,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _isOffGrid ? loc.systemTypeOffGrid : loc.systemTypeOnGrid,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Switch.adaptive(
                value: _isOffGrid,
                onChanged: (value) {
                  setState(() {
                    _isOffGrid = value;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CalculatorInputField(
          labelText: loc.totalDailyConsumption,
          hintText: loc.dailyConsumptionWhHint,
          controller: _dailyConsumptionController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.wh,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.singlePanelPower,
          hintText: loc.panelPowerWattsHint,
          controller: _panelPowerController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.watt,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.peakSunHours,
          hintText: loc.peakSunHoursHint,
          controller: _sunHoursController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: 18),
        Text(
          loc.systemEfficiency,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Slider(
          value: _systemEfficiency,
          min: 50,
          max: 100,
          divisions: 50,
          label: '${_systemEfficiency.toStringAsFixed(0)}%',
          onChanged: (value) {
            setState(() {
              _systemEfficiency = value;
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
            child: Text('${_systemEfficiency.toStringAsFixed(0)}%'),
          ),
        ),
        const SizedBox(height: 18),
        CalculatorPrimaryButton(
          text: loc.calculate,
          icon: Icons.calculate_outlined,
          onPressed: _calculatePanels,
        ),
        const SizedBox(height: 18),
        CalculatorResultCard(
          title: loc.numberOfPanelsRequired,
          value: formatCalculatorNumber(_numberOfPanels, fractionDigits: 0),
          unit: loc.panel,
          icon: Icons.grid_view_rounded,
        ),
        const SizedBox(height: 14),
        CalculatorPrimaryButton(
          text: loc.nextBatteryCapacity,
          icon: Icons.arrow_forward_rounded,
          onPressed: () {
            final panels = _calculatePanels(showError: false);
            if (panels <= 0) {
              _showInputError(loc);
              return;
            }

            context.push(
              RouteNames.batteryCapacity,
              extra: widget.flowData.copyWith(
                dailyConsumption: readCalculatorDouble(
                  _dailyConsumptionController,
                ),
                numberOfPanels: panels,
              ),
            );
          },
        ),
      ],
    );
  }
}
