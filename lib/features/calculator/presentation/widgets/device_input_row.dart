import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/calculator/presentation/controllers/device_list_controller.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';

class DeviceInputRow extends ConsumerWidget {
  final int index;
  final DeviceInputModel device;

  const DeviceInputRow({
    super.key,
    required this.index,
    required this.device,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 380;

    if (isCompact) {
      return Column(
        children: [
          CalculatorInputField(
            hintText: 'Device',
            controller: device.deviceController,
          ),
          const SizedBox(height: 10),
          CalculatorInputField(
            hintText: 'Power',
            controller: device.powerController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          CalculatorInputField(
            hintText: 'Hours',
            controller: device.hoursController,
            keyboardType: TextInputType.number,
            suffixIcon: IconButton(
              onPressed: () {
                ref.read(deviceListProvider.notifier).removeDevice(index);
              },
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: CalculatorInputField(
            hintText: 'Device',
            controller: device.deviceController,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: CalculatorInputField(
            hintText: 'Power',
            controller: device.powerController,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: CalculatorInputField(
            hintText: 'Hours',
            controller: device.hoursController,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            ref.read(deviceListProvider.notifier).removeDevice(index);
          },
          icon: const Icon(Icons.delete_outline_rounded),
        ),
      ],
    );
  }
}