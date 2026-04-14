import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/data/models/calculate_flow_data.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_app_bar.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_input_field.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_primary_button.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_result_card.dart';

class TiltOfPanelsScreen extends StatefulWidget {
  final CalculatorFlowData flowData;
  const TiltOfPanelsScreen({super.key, required this.flowData});

  @override
  State<TiltOfPanelsScreen> createState() => _TiltOfPanelsScreenState();
}

class _TiltOfPanelsScreenState extends State<TiltOfPanelsScreen> {
  final TextEditingController _latitudeController = TextEditingController();

  String _selectedSeason = 'Annual';
  double _tiltAngle = 0;

  final List<String> _seasons = const ['Annual', 'Summer', 'Winter'];

  void _calculateTilt() {
    final latitude = double.tryParse(_latitudeController.text.trim()) ?? 0;

    if (latitude <= 0) {
      setState(() {
        _tiltAngle = 0;
      });
      return;
    }

    double result;

    switch (_selectedSeason) {
      case 'Summer':
        result = latitude - 15;
        break;
      case 'Winter':
        result = latitude + 15;
        break;
      case 'Annual':
      default:
        result = latitude;
        break;
    }

    if (result < 0) result = 0;

    setState(() {
      _tiltAngle = result;
    });
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CalculatorAppBar(title: 'Return on investment'),
      body: SafeArea(
        top: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            20,
          ),
          children: [
            Text(
              'Enter the site latitude and choose the season to estimate the recommended panel tilt angle.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),

            CalculatorInputField(
              hintText: 'Latitude (e.g. 32.22)',
              controller: _latitudeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.65),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSeason,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(14),
                  items: _seasons.map((season) {
                    return DropdownMenuItem<String>(
                      value: season,
                      child: Text(season),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedSeason = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 18),

            CalculatorPrimaryButton(
              text: 'Calculate',
              onPressed: _calculateTilt,
            ),

            const SizedBox(height: 18),

            CalculatorResultCard(
              title: 'Recommended tilt angle',
              value: _tiltAngle.toStringAsFixed(1),
              unit: '°',
            ),

            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant.withOpacity(0.55),
                ),
              ),
              child: Text(
                'Formula used:\n'
                'Annual tilt = Latitude\n'
                'Summer tilt = Latitude - 15\n'
                'Winter tilt = Latitude + 15',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
            ),
            const SizedBox(height: 12),

            CalculatorPrimaryButton(
              text: 'Next: System efficiency',
              onPressed: () {
                final updatedData = widget.flowData.copyWith(
                  tiltAngle: _tiltAngle,
                );

                context.push(RouteNames.systemEfficiency, extra: updatedData);
              },
            ),
          ],
        ),
      ),
    );
  }
}
