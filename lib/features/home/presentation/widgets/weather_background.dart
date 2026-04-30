import 'package:flutter/material.dart';
import 'dart:math';

class WeatherBackground extends StatelessWidget {
  final String condition;

  const WeatherBackground({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    if (condition.toLowerCase().contains("rain")) {
      return const RainAnimation();
    } else {
      return const SunAnimation();
    }
  }
}

class RainAnimation extends StatefulWidget {
  const RainAnimation({super.key});

  @override
  State<RainAnimation> createState() => _RainAnimationState();
}

class _RainAnimationState extends State<RainAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return CustomPaint(
          painter: RainPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class RainPainter extends CustomPainter {
  final double progress;
  RainPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue.withAlpha(120);

    final random = Random(1);

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() * size.height + progress * 300) %
          size.height;

      canvas.drawLine(
        Offset(x, y),
        Offset(x + 2, y + 10),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SunAnimation extends StatelessWidget {
  const SunAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.orange.withAlpha(200),
            Colors.transparent,
          ],
          radius: 0.8,
          center: Alignment.topLeft,
        ),
      ),
    );
  }
}