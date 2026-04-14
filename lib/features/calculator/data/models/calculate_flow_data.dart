class CalculatorFlowData {
  final double dailyConsumption;
  final double numberOfPanels;
  final double batteryCapacity;
  final double tiltAngle;
  final double systemEfficiency;
  final double roiYears;

  const CalculatorFlowData({
    this.dailyConsumption = 0,
    this.numberOfPanels = 0,
    this.batteryCapacity = 0,
    this.tiltAngle = 0,
    this.systemEfficiency = 0,
    this.roiYears = 0,
  });

  CalculatorFlowData copyWith({
    double? dailyConsumption,
    double? numberOfPanels,
    double? batteryCapacity,
    double? tiltAngle,
    double? systemEfficiency,
    double? roiYears,
  }) {
    return CalculatorFlowData(
      dailyConsumption: dailyConsumption ?? this.dailyConsumption,
      numberOfPanels: numberOfPanels ?? this.numberOfPanels,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      tiltAngle: tiltAngle ?? this.tiltAngle,
      systemEfficiency: systemEfficiency ?? this.systemEfficiency,
      roiYears: roiYears ?? this.roiYears,
    );
  }
}