import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class DeviceInputModel {
  final TextEditingController deviceController;
  final TextEditingController powerController;
  final TextEditingController hoursController;

  DeviceInputModel({
    required this.deviceController,
    required this.powerController,
    required this.hoursController,
  });

  double get powerValue => double.tryParse(powerController.text.trim()) ?? 0;
  double get hoursValue => double.tryParse(hoursController.text.trim()) ?? 0;

  double get totalConsumption => powerValue * hoursValue;

  void dispose() {
    deviceController.dispose();
    powerController.dispose();
    hoursController.dispose();
  }
}

class DeviceListNotifier extends StateNotifier<List<DeviceInputModel>> {
  DeviceListNotifier() : super([_createEmptyDevice()]);

  static DeviceInputModel _createEmptyDevice() {
    return DeviceInputModel(
      deviceController: TextEditingController(),
      powerController: TextEditingController(),
      hoursController: TextEditingController(),
    );
  }

  void addDevice() {
    state = [...state, _createEmptyDevice()];
  }

  void removeDevice(int index) {
    if (state.length == 1) return;

    final item = state[index];
    item.dispose();

    final updated = [...state]..removeAt(index);
    state = updated;
  }

  double calculateTotalConsumption() {
    double total = 0;
    for (final device in state) {
      total += device.totalConsumption;
    }
    return total;
  }

  @override
  void dispose() {
    for (final item in state) {
      item.dispose();
    }
    super.dispose();
  }
}

final deviceListProvider =
    StateNotifierProvider<DeviceListNotifier, List<DeviceInputModel>>(
  (ref) => DeviceListNotifier(),
);

final totalDeviceConsumptionProvider = Provider<double>((ref) {
  final devices = ref.watch(deviceListProvider);

  double total = 0;
  for (final device in devices) {
    final power = double.tryParse(device.powerController.text.trim()) ?? 0;
    final hours = double.tryParse(device.hoursController.text.trim()) ?? 0;
    total += power * hours;
  }

  return total;
});