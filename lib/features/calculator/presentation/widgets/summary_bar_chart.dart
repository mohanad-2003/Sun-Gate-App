import 'package:flutter/material.dart';

class SummaryBarChart extends StatelessWidget {
  final double dailyConsumption;
  final double numberOfPanels;
  final double batteryCapacity;
  final double tiltAngle;

  const SummaryBarChart({
    super.key,
    required this.dailyConsumption,
    required this.numberOfPanels,
    required this.batteryCapacity,
    required this.tiltAngle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final values = <double>[
      dailyConsumption <= 0 ? 0 : dailyConsumption,
      numberOfPanels <= 0 ? 0 : numberOfPanels * 200,
      batteryCapacity <= 0 ? 0 : batteryCapacity,
      tiltAngle <= 0 ? 0 : tiltAngle * 20,
    ];

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final safeMax = maxValue == 0 ? 1.0 : maxValue;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System comparison chart',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A visual comparison between the main calculated values.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ChartBar(
                  label: 'Use',
                  value: values[0] / safeMax,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                _ChartBar(
                  label: 'Panels',
                  value: values[1] / safeMax,
                  color: Colors.orange,
                ),
                const SizedBox(width: 12),
                _ChartBar(
                  label: 'Battery',
                  value: values[2] / safeMax,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                _ChartBar(
                  label: 'Tilt',
                  value: values[3] / safeMax,
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ChartBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clamped = value.clamp(0.0, 1.0);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: clamped,
                child: Container(
                  width: 30,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}