class CalculatorDevice {
  final String name;
  final double powerWatts;
  final double hoursPerDay;

  const CalculatorDevice({
    required this.name,
    required this.powerWatts,
    required this.hoursPerDay,
  });

  double get dailyConsumptionWh => powerWatts * hoursPerDay;
}
