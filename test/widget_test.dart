import 'package:flutter_test/flutter_test.dart';
import 'package:sun_gate_app/features/calculator/domain/usecases/calculate_solar_values_usecase.dart';

void main() {
  const calculator = CalculateSolarValuesUseCase();

  test('calculates required off-grid solar panels with reserve', () {
    final panels = calculator.numberOfPanels(
      dailyConsumptionWh: 5000,
      panelPowerWatts: 500,
      peakSunHours: 5,
      systemEfficiencyPercent: 80,
      isOffGrid: true,
    );

    expect(panels, 3);
  });

  test('calculates advanced battery capacity', () {
    final capacity = calculator.advancedBatteryCapacityAh(
      dailyConsumptionWh: 2400,
      systemVoltage: 24,
      daysOfAutonomy: 2,
      depthOfDischargePercent: 50,
      inverterEfficiencyPercent: 90,
      minimumTemperatureC: 10,
    );

    expect(capacity, closeTo(493.83, 0.01));
  });
}
