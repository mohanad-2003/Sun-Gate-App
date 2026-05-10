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

const _seasonOptions = <_SeasonOption>[
  _SeasonOption(_SeasonOptionType.annual, 100),
  _SeasonOption(_SeasonOptionType.summer, 110),
  _SeasonOption(_SeasonOptionType.springAutumn, 90),
  _SeasonOption(_SeasonOptionType.winter, 75),
];

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
  final _safetyMarginController = TextEditingController(text: '0');
  final _panelDeratingController = TextEditingController(text: '100');
  final _batteryChargeLossController = TextEditingController(text: '0');
  final _availableRoofAreaController = TextEditingController();
  final _panelAreaController = TextEditingController();
  final _panelVoltageController = TextEditingController();
  final _panelCurrentController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isOffGrid = true;
  _SeasonOption _selectedSeason = _seasonOptions.first;
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
      safetyMarginPercent: readCalculatorDouble(_safetyMarginController),
      panelDeratingPercent: readCalculatorDouble(_panelDeratingController),
      batteryChargeLossPercent: readCalculatorDouble(
        _batteryChargeLossController,
      ),
      seasonProductionFactorPercent: _selectedSeason.productionFactorPercent,
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
    _safetyMarginController.dispose();
    _panelDeratingController.dispose();
    _batteryChargeLossController.dispose();
    _availableRoofAreaController.dispose();
    _panelAreaController.dispose();
    _panelVoltageController.dispose();
    _panelCurrentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String? _buildResultDetails() {
    if (_numberOfPanels <= 0) return null;

    final loc = AppLocalizations.of(context)!;
    final details = <String>[];
    final peakSunHours = readCalculatorDouble(_sunHoursController);
    final effectiveSunHours =
        peakSunHours * (_selectedSeason.productionFactorPercent / 100);
    if (peakSunHours > 0) {
      details.add(
        '${loc.effectiveSunHours}: ${formatCalculatorNumber(effectiveSunHours)} h',
      );
    }

    final availableRoofArea = readCalculatorDouble(
      _availableRoofAreaController,
    );
    final panelArea = readCalculatorDouble(_panelAreaController);
    if (availableRoofArea > 0 && panelArea > 0) {
      final requiredArea = _numberOfPanels * panelArea;
      final roofStatus = requiredArea <= availableRoofArea
          ? loc.fitsAvailableRoofArea
          : loc.exceedsAvailableRoofArea;
      details.add(
        '${loc.roofArea}: ${formatCalculatorNumber(requiredArea)} m2 ${loc.requiredLabel}, $roofStatus',
      );
    }

    final panelVoltage = readCalculatorDouble(_panelVoltageController);
    final panelCurrent = readCalculatorDouble(_panelCurrentController);
    if (panelVoltage > 0 && panelCurrent > 0) {
      final checkedPanelPower = panelVoltage * panelCurrent;
      details.add(
        '${loc.panelVoltageCurrentCheck}: ${formatCalculatorNumber(checkedPanelPower)} W',
      );
    }

    final location = _locationController.text.trim();
    if (location.isNotEmpty) {
      details.add('${loc.locationNote}: $location');
    }

    if (details.isEmpty) return null;
    return details.join('\n');
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
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.safetyMarginReserveFactor,
          hintText: loc.safetyMarginReserveFactorHint,
          controller: _safetyMarginController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: '%',
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.panelDeratingFactor,
          hintText: loc.panelDeratingFactorHint,
          controller: _panelDeratingController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: '%',
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.batteryChargeLosses,
          hintText: loc.batteryChargeLossesHint,
          controller: _batteryChargeLossController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: '%',
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.availableRoofArea,
          hintText: loc.availableRoofAreaHint,
          controller: _availableRoofAreaController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: 'm2',
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.panelArea,
          hintText: loc.panelAreaHint,
          controller: _panelAreaController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: 'm2',
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.panelVoltage,
          hintText: loc.panelVoltageHint,
          controller: _panelVoltageController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.volt,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.panelCurrent,
          hintText: loc.panelCurrentHint,
          controller: _panelCurrentController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffixText: loc.ampere,
        ),
        const SizedBox(height: 14),
        CalculatorInputField(
          labelText: loc.location,
          hintText: loc.cityOrSiteName,
          controller: _locationController,
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<_SeasonOption>(
          value: _selectedSeason,
          decoration: InputDecoration(
            labelText: loc.monthSeason,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
          ),
          items: _seasonOptions
              .map(
                (season) => DropdownMenuItem(
                  value: season,
                  child: Text(_seasonLabel(loc, season.type)),
                ),
              )
              .toList(),
          onChanged: (season) {
            if (season == null) return;
            setState(() {
              _selectedSeason = season;
            });
          },
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
          subtitle: _buildResultDetails(),
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

class _SeasonOption {
  final _SeasonOptionType type;
  final double productionFactorPercent;

  const _SeasonOption(this.type, this.productionFactorPercent);
}

enum _SeasonOptionType { annual, summer, springAutumn, winter }

String _seasonLabel(AppLocalizations loc, _SeasonOptionType type) {
  return switch (type) {
    _SeasonOptionType.annual => loc.annualAverage,
    _SeasonOptionType.summer => loc.summerHighSun,
    _SeasonOptionType.springAutumn => loc.springAutumn,
    _SeasonOptionType.winter => loc.winterLowSun,
  };
}
