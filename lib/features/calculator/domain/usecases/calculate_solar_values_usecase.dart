import 'dart:math' as math;

import 'package:sun_gate_app/features/calculator/domain/entities/calculator_device.dart';

class CalculateSolarValuesUseCase {
  const CalculateSolarValuesUseCase();

  double dailyConsumption(Iterable<CalculatorDevice> devices) {
    return devices.fold<double>(
      0,
      (total, device) => total + device.dailyConsumptionWh,
    );
  }

  double numberOfPanels({
    required double dailyConsumptionWh,
    required double panelPowerWatts,
    required double peakSunHours,
    required double systemEfficiencyPercent,
    required bool isOffGrid,
    double safetyMarginPercent = 0,
    double panelDeratingPercent = 100,
    double batteryChargeLossPercent = 0,
    double seasonProductionFactorPercent = 100,
  }) {
    if (!_allPositive([
      dailyConsumptionWh,
      panelPowerWatts,
      peakSunHours,
      systemEfficiencyPercent,
    ])) {
      return 0;
    }

    final efficiency = (systemEfficiencyPercent / 100).clamp(0.01, 1.0);
    final safePanelDeratingPercent = panelDeratingPercent <= 0
        ? 100.0
        : panelDeratingPercent;
    final safeSeasonProductionFactorPercent = seasonProductionFactorPercent <= 0
        ? 100.0
        : seasonProductionFactorPercent;
    final panelDerating = (safePanelDeratingPercent / 100)
        .clamp(0.01, 1.0)
        .toDouble();
    final seasonFactor = (safeSeasonProductionFactorPercent / 100)
        .clamp(0.01, 2.0)
        .toDouble();
    final usableChargeFactor =
        (1 - (batteryChargeLossPercent.clamp(0, 95).toDouble() / 100))
            .clamp(0.01, 1.0)
            .toDouble();
    final safetyMargin =
        1 + (safetyMarginPercent.clamp(0, 100).toDouble() / 100);
    final offGridReserve = isOffGrid ? 1.15 : 1.0;
    final adjustedDailyConsumption =
        (dailyConsumptionWh * offGridReserve * safetyMargin) /
        usableChargeFactor;
    final productionPerPanel =
        panelPowerWatts *
        peakSunHours *
        efficiency *
        panelDerating *
        seasonFactor;
    return (adjustedDailyConsumption / productionPerPanel).ceilToDouble();
  }

  double basicBatteryCapacityAh({
    required double dailyConsumptionWh,
    required double systemVoltage,
    required double inverterEfficiencyPercent,
    required double minimumTemperatureC,
  }) {
    if (!_allPositive([
      dailyConsumptionWh,
      systemVoltage,
      inverterEfficiencyPercent,
    ])) {
      return 0;
    }

    final efficiency = (inverterEfficiencyPercent / 100).clamp(0.01, 1.0);
    final temperatureFactor = _temperatureCorrection(minimumTemperatureC);
    return dailyConsumptionWh /
        (systemVoltage * efficiency * temperatureFactor);
  }

  double advancedBatteryCapacityAh({
    required double dailyConsumptionWh,
    required double systemVoltage,
    required double daysOfAutonomy,
    required double depthOfDischargePercent,
    required double inverterEfficiencyPercent,
    required double minimumTemperatureC,
  }) {
    if (!_allPositive([
      dailyConsumptionWh,
      systemVoltage,
      daysOfAutonomy,
      depthOfDischargePercent,
      inverterEfficiencyPercent,
    ])) {
      return 0;
    }

    final dod = (depthOfDischargePercent / 100).clamp(0.01, 1.0);
    final efficiency = (inverterEfficiencyPercent / 100).clamp(0.01, 1.0);
    final temperatureFactor = _temperatureCorrection(minimumTemperatureC);

    return (dailyConsumptionWh * daysOfAutonomy) /
        (systemVoltage * dod * efficiency * temperatureFactor);
  }

  TiltAnglesResult tiltAngles({
    required double latitude,
    required DateTime selectedDate,
  }) {
    if (latitude == 0) {
      return const TiltAnglesResult.empty();
    }

    final absoluteLatitude = latitude.abs();
    final annual = absoluteLatitude;
    final summer = math.max(0.0, absoluteLatitude - 15);
    final winter = absoluteLatitude + 15;
    final month = selectedDate.month;
    final selected = month == 12 || month <= 2
        ? winter
        : month >= 4 && month <= 8
        ? summer
        : annual;

    return TiltAnglesResult(
      annual: annual,
      summer: summer,
      winter: winter,
      selected: selected,
    );
  }

  double systemEfficiency({
    required double theoreticalProductionWh,
    required double actualProductionWh,
  }) {
    if (theoreticalProductionWh <= 0 || actualProductionWh < 0) {
      return 0;
    }

    return (actualProductionWh / theoreticalProductionWh) * 100;
  }

  double returnOnInvestmentYears({
    required double totalSystemCost,
    required double expectedDailyOutputWh,
    required double pricePerKwh,
  }) {
    if (!_allPositive([totalSystemCost, expectedDailyOutputWh, pricePerKwh])) {
      return 0;
    }

    final annualSavings = (expectedDailyOutputWh / 1000) * pricePerKwh * 365;
    if (annualSavings <= 0) return 0;

    return totalSystemCost / annualSavings;
  }

  InverterCapacityResult inverterCapacity({
    required double continuousPowerWatts,
    required double maximumStartWatts,
    required double powerFactor,
    required double inverterEfficiencyPercent,
    required double dcInputVoltage,
    required double safetyFactorPercent,
  }) {
    if (!_allPositive([
      continuousPowerWatts,
      powerFactor,
      inverterEfficiencyPercent,
      dcInputVoltage,
    ])) {
      return const InverterCapacityResult.empty();
    }

    final safePowerFactor = powerFactor.clamp(0.1, 1.0).toDouble();
    final efficiency = (inverterEfficiencyPercent / 100)
        .clamp(0.01, 1.0)
        .toDouble();
    final reserve = 1 + (safetyFactorPercent.clamp(0, 100).toDouble() / 100);
    final continuousVa = (continuousPowerWatts / safePowerFactor) * reserve;
    final surgeVa = maximumStartWatts <= 0
        ? 0.0
        : (maximumStartWatts / safePowerFactor);
    final requiredVa = math.max(continuousVa, surgeVa);
    final requiredWatts = (requiredVa * safePowerFactor) / efficiency;
    final dcCurrent = requiredWatts / dcInputVoltage;

    return InverterCapacityResult(
      requiredWatts: requiredWatts,
      requiredVa: requiredVa,
      dcCurrent: dcCurrent,
    );
  }

  WireCrossSectionResult wireCrossSection({
    required double loadPowerWatts,
    required double systemVoltage,
    required double distanceMeters,
  }) {
    if (!_allPositive([loadPowerWatts, systemVoltage, distanceMeters])) {
      return const WireCrossSectionResult.empty();
    }

    const copperResistivity = 0.0175;
    const maxVoltageDropPercent = 0.03;
    final current = loadPowerWatts / systemVoltage;
    final voltageDrop = systemVoltage * maxVoltageDropPercent;
    final rawSection =
        (2 * distanceMeters * current * copperResistivity) / voltageDrop;
    final recommendedSection = _nextCableSize(rawSection);
    final breaker = (current * 1.25 / 5).ceil() * 5.0;

    return WireCrossSectionResult(
      current: current,
      rawSectionMm2: rawSection,
      recommendedSectionMm2: recommendedSection,
      breakerAmpere: breaker,
    );
  }

  ChargeControllerResult chargeController({
    required double batteryVoltage,
    required double shortCircuitCurrentPerPanel,
    required double panelsInParallel,
  }) {
    if (!_allPositive([
      batteryVoltage,
      shortCircuitCurrentPerPanel,
      panelsInParallel,
    ])) {
      return const ChargeControllerResult.empty();
    }

    final requiredCurrent =
        shortCircuitCurrentPerPanel * panelsInParallel * 1.25;
    return ChargeControllerResult(
      requiredCurrent: requiredCurrent,
      supportedArrayPower: requiredCurrent * batteryVoltage,
    );
  }

  bool _allPositive(Iterable<double> values) {
    return values.every((value) => value > 0);
  }

  double _temperatureCorrection(double temperatureC) {
    if (temperatureC >= 25) return 1;
    if (temperatureC >= 15) return 0.95;
    if (temperatureC >= 5) return 0.90;
    if (temperatureC >= -5) return 0.80;
    return 0.70;
  }

  double _nextCableSize(double requiredSection) {
    const standardSizes = <double>[
      1.5,
      2.5,
      4,
      6,
      10,
      16,
      25,
      35,
      50,
      70,
      95,
      120,
    ];

    for (final size in standardSizes) {
      if (size >= requiredSection) return size;
    }

    return requiredSection;
  }
}

class TiltAnglesResult {
  final double annual;
  final double summer;
  final double winter;
  final double selected;

  const TiltAnglesResult({
    required this.annual,
    required this.summer,
    required this.winter,
    required this.selected,
  });

  const TiltAnglesResult.empty()
    : annual = 0,
      summer = 0,
      winter = 0,
      selected = 0;
}

class InverterCapacityResult {
  final double requiredWatts;
  final double requiredVa;
  final double dcCurrent;

  const InverterCapacityResult({
    required this.requiredWatts,
    required this.requiredVa,
    required this.dcCurrent,
  });

  const InverterCapacityResult.empty()
    : requiredWatts = 0,
      requiredVa = 0,
      dcCurrent = 0;
}

class WireCrossSectionResult {
  final double current;
  final double rawSectionMm2;
  final double recommendedSectionMm2;
  final double breakerAmpere;

  const WireCrossSectionResult({
    required this.current,
    required this.rawSectionMm2,
    required this.recommendedSectionMm2,
    required this.breakerAmpere,
  });

  const WireCrossSectionResult.empty()
    : current = 0,
      rawSectionMm2 = 0,
      recommendedSectionMm2 = 0,
      breakerAmpere = 0;
}

class ChargeControllerResult {
  final double requiredCurrent;
  final double supportedArrayPower;

  const ChargeControllerResult({
    required this.requiredCurrent,
    required this.supportedArrayPower,
  });

  const ChargeControllerResult.empty()
    : requiredCurrent = 0,
      supportedArrayPower = 0;
}
