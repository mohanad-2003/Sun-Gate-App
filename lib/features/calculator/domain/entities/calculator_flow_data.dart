class CalculatorFlowData {
  final double dailyConsumption;
  final double numberOfPanels;
  final double batteryCapacity;
  final double tiltAngle;
  final double systemEfficiency;
  final double roiYears;
  final double inverterCapacity;
  final double wireCrossSection;
  final double chargeControllerCurrent;

  const CalculatorFlowData({
    this.dailyConsumption = 0,
    this.numberOfPanels = 0,
    this.batteryCapacity = 0,
    this.tiltAngle = 0,
    this.systemEfficiency = 0,
    this.roiYears = 0,
    this.inverterCapacity = 0,
    this.wireCrossSection = 0,
    this.chargeControllerCurrent = 0,
  });

  CalculatorFlowData copyWith({
    double? dailyConsumption,
    double? numberOfPanels,
    double? batteryCapacity,
    double? tiltAngle,
    double? systemEfficiency,
    double? roiYears,
    double? inverterCapacity,
    double? wireCrossSection,
    double? chargeControllerCurrent,
  }) {
    return CalculatorFlowData(
      dailyConsumption: dailyConsumption ?? this.dailyConsumption,
      numberOfPanels: numberOfPanels ?? this.numberOfPanels,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      tiltAngle: tiltAngle ?? this.tiltAngle,
      systemEfficiency: systemEfficiency ?? this.systemEfficiency,
      roiYears: roiYears ?? this.roiYears,
      inverterCapacity: inverterCapacity ?? this.inverterCapacity,
      wireCrossSection: wireCrossSection ?? this.wireCrossSection,
      chargeControllerCurrent:
          chargeControllerCurrent ?? this.chargeControllerCurrent,
    );
  }
}
