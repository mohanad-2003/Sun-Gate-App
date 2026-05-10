import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/app/localization/app_localizations.dart';
import 'package:sun_gate_app/features/calculator/presentation/controllers/device_list_controller.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';

class DeviceInputRow extends ConsumerWidget {
  final int index;
  final DeviceInputModel device;

  const DeviceInputRow({super.key, required this.index, required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 380;
    final canRemove = ref.watch(deviceListProvider).length > 1;

    if (isCompact) {
      return Column(
        children: [
          CalculatorInputField(
            labelText: loc.device,
            hintText: loc.deviceHint,
            controller: device.deviceController,
          ),
          const SizedBox(height: 10),
          CalculatorInputField(
            labelText: loc.power,
            hintText: loc.powerWattsHint,
            controller: device.powerController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 10),
          CalculatorInputField(
            labelText: loc.hours,
            hintText: loc.hoursHint,
            controller: device.hoursController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            suffixIcon: canRemove
                ? IconButton(
                    tooltip: loc.remove,
                    onPressed: () {
                      ref.read(deviceListProvider.notifier).removeDevice(index);
                    },
                    icon: const Icon(Icons.delete_outline_rounded),
                  )
                : null,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: CalculatorInputField(
            labelText: loc.device,
            hintText: loc.deviceHint,
            controller: device.deviceController,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: CalculatorInputField(
            labelText: loc.power,
            hintText: loc.powerWattsHint,
            controller: device.powerController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: CalculatorInputField(
            labelText: loc.hours,
            hintText: loc.hoursHint,
            controller: device.hoursController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          tooltip: loc.remove,
          visualDensity: VisualDensity.compact,
          onPressed: canRemove
              ? () {
                  ref.read(deviceListProvider.notifier).removeDevice(index);
                }
              : null,
          icon: const Icon(Icons.delete_outline_rounded),
        ),
      ],
    );
  }
}
