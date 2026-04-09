import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/widgets/app_scaffold.dart';
import 'package:sun_gate_app/features/splash/presentation/controllers/splash_controller.dart';
import 'package:sun_gate_app/features/splash/presentation/widgets/splash_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final hasToken = await ref.read(splashControllerProvider).hasAccessToken();

    if (!mounted) return;
    Future.microtask(() {
      if (!mounted) return;

      if (hasToken) {
        context.go(RouteNames.profile);
      } else {
        context.go(RouteNames.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      backgroundColor: Color(0xFF274777),
      child: Center(child: SplashLogo()),
    );
  }
}
