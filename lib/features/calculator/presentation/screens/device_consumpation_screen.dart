import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/domain/entities/calculator_flow_data.dart';
import 'package:sun_gate_app/features/calculator/domain/usecases/calculate_solar_values_usecase.dart';
import 'package:sun_gate_app/features/calculator/presentation/controllers/device_list_controller.dart';
import 'package:sun_gate_app/features/calculator/presentation/utils/calculator_input_parser.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_page_scaffold.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/device_input_row.dart';

class DeviceConsumptionScreen extends ConsumerStatefulWidget {
  final CalculatorFlowData flowData;

  const DeviceConsumptionScreen({super.key, required this.flowData});

  @override
  ConsumerState<DeviceConsumptionScreen> createState() =>
      _DeviceConsumptionScreenState();
}

class _DeviceConsumptionScreenState
    extends ConsumerState<DeviceConsumptionScreen> {
  final _calculator = const CalculateSolarValuesUseCase();
  double _totalConsumption = 0;

  @override
  void initState() {
    super.initState();
    _totalConsumption = widget.flowData.dailyConsumption;
  }

  double _calculate({bool showError = true}) {
    final loc = AppLocalizations.of(context)!;
    final devices = ref.read(deviceListProvider).map((device) {
      return device.toEntity();
    });
    final total = _calculator.dailyConsumption(devices);

    setState(() {
      _totalConsumption = total;
    });

    if (showError && total <= 0) {
      _showInputError(loc);
    }

    return total;
  }

  void _showInputError(AppLocalizations loc) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.calculatorInvalidInputs)));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final devices = ref.watch(deviceListProvider);

    return CalculatorPageScaffold(
      title: loc.deviceConsumptionTitle,
      children: [
        ...List.generate(
          devices.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == devices.length - 1 ? 0 : 14,
            ),
            child: DeviceInputRow(index: index, device: devices[index]),
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () {
            ref.read(deviceListProvider.notifier).addDevice();
          },
          icon: const Icon(Icons.add_rounded),
          label: Text(loc.addNewDevice),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
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
          title: loc.totalDailyConsumption,
          value: formatCalculatorNumber(_totalConsumption),
          unit: loc.wattHour,
          icon: Icons.electric_bolt_rounded,
        ),
        const SizedBox(height: 14),
        CalculatorPrimaryButton(
          text: loc.nextNumberOfPanels,
          icon: Icons.arrow_forward_rounded,
          onPressed: () {
            final total = _calculate(showError: false);
            if (total <= 0) {
              _showInputError(loc);
              return;
            }

            context.push(
              RouteNames.numberOfPanels,
              extra: widget.flowData.copyWith(dailyConsumption: total),
            );
          },
        ),
      ],
    );
  }
}
