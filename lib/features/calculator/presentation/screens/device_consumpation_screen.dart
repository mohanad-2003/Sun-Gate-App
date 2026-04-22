import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/data/models/calculate_flow_data.dart';
import 'package:sun_gate_app/features/calculator/presentation/controllers/device_list_controller.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_app_bar.dart';
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
  double _totalConsumption = 0;

  void _calculate() {
    final total = ref
        .read(deviceListProvider.notifier)
        .calculateTotalConsumption();

    setState(() {
      _totalConsumption = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final devices = ref.watch(deviceListProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CalculatorAppBar(title: 'Return on investment'),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            20,
          ),
          children: [
            Text(
              'Add your devices, their power, and daily working hours to calculate the total daily consumption.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),

            ...List.generate(
              devices.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == devices.length - 1 ? 0 : 12,
                ),
                child: DeviceInputRow(index: index, device: devices[index]),
              ),
            ),

            const SizedBox(height: 14),

            OutlinedButton.icon(
              onPressed: () {
                ref.read(deviceListProvider.notifier).addDevice();
              },
              icon: const Icon(Icons.add),
              label: const Text('Add a new device'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 18),

            CalculatorPrimaryButton(text: 'Calculate', onPressed: _calculate),

            const SizedBox(height: 18),

            CalculatorResultCard(
              title: 'Total daily consumption',
              value: _totalConsumption.toStringAsFixed(2),
              unit: 'watt-hour',
            ),
            const SizedBox(height: 12),

            CalculatorPrimaryButton(
              text: 'Next: Number of panels',
              onPressed: () {
                final updatedData = widget.flowData.copyWith(
                  dailyConsumption: _totalConsumption,
                );

                context.push(RouteNames.numberOfPanels, extra: updatedData);
              },
            ),
          ],
        ),
      ),
    );
  }
}
