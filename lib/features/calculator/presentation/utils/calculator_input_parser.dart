import 'package:flutter/widgets.dart';

double readCalculatorDouble(TextEditingController controller) {
  final normalized = controller.text.trim().replaceAll(',', '.');
  return double.tryParse(normalized) ?? 0;
}

String formatCalculatorNumber(double value, {int fractionDigits = 2}) {
  if (value == 0) return '0';
  return value.toStringAsFixed(fractionDigits);
}
