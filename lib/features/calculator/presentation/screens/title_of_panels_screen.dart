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

class TiltOfPanelsScreen extends StatefulWidget {
  final CalculatorFlowData flowData;
  const TiltOfPanelsScreen({super.key, required this.flowData});

  @override
  State<TiltOfPanelsScreen> createState() => _TiltOfPanelsScreenState();
}

class _TiltOfPanelsScreenState extends State<TiltOfPanelsScreen> {
  final _calculator = const CalculateSolarValuesUseCase();
  final _latitudeController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TiltAnglesResult _tiltAngles = const TiltAnglesResult.empty();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dateController.text = MaterialLocalizations.of(
      context,
    ).formatCompactDate(_selectedDate);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _selectedDate = picked;
      _dateController.text = MaterialLocalizations.of(
        context,
      ).formatCompactDate(picked);
    });
  }

  TiltAnglesResult _calculateTilt({bool showError = true}) {
    final loc = AppLocalizations.of(context)!;
    final result = _calculator.tiltAngles(
      latitude: readCalculatorDouble(_latitudeController),
      selectedDate: _selectedDate,
    );

    setState(() {
      _tiltAngles = result;
    });

    if (showError && result.selected <= 0) {
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
    _latitudeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final loc = AppLocalizations.of(context)!;

    return CalculatorPageScaffold(
      title: loc.tiltOfPanelsTitle,
      children: [
        CalculatorInputField(
          labelText: loc.latitude,
          hintText: loc.latitudeHint,
          controller: _latitudeController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: true,
          ),
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.selectDate,
          hintText: loc.chooseDate,
          controller: _dateController,
          readOnly: true,
          onTap: _pickDate,
          suffixIcon: IconButton(
            tooltip: loc.chooseDate,
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ),
        const SizedBox(height: 18),
        CalculatorPrimaryButton(
          text: loc.calculate,
          icon: Icons.calculate_outlined,
          onPressed: _calculateTilt,
        ),
        const SizedBox(height: 18),
        CalculatorResultCard(
          title: loc.selectedDateTilt,
          value: formatCalculatorNumber(
            _tiltAngles.selected,
            fractionDigits: 1,
          ),
          unit: loc.degree,
          icon: Icons.wb_sunny_outlined,
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.55),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.optimalTiltAngle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              _TiltResultRow(
                label: loc.annualTilt,
                value: _tiltAngles.annual,
                unit: loc.degree,
              ),
              const SizedBox(height: 8),
              _TiltResultRow(
                label: loc.summerTilt,
                value: _tiltAngles.summer,
                unit: loc.degree,
              ),
              const SizedBox(height: 8),
              _TiltResultRow(
                label: loc.winterTilt,
                value: _tiltAngles.winter,
                unit: loc.degree,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        CalculatorPrimaryButton(
          text: loc.nextSystemEfficiency,
          icon: Icons.arrow_forward_rounded,
          onPressed: () {
            final result = _calculateTilt(showError: false);
            if (result.selected <= 0) {
              _showInputError(loc);
              return;
            }

            context.push(
              RouteNames.systemEfficiency,
              extra: widget.flowData.copyWith(tiltAngle: result.selected),
            );
          },
        ),
      ],
    );
  }
}

class _TiltResultRow extends StatelessWidget {
  final String label;
  final double value;
  final String unit;

  const _TiltResultRow({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          '${formatCalculatorNumber(value, fractionDigits: 1)} $unit',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
