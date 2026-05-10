import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/features/calculator/presentation/widgets/calculator_app_bar.dart';
import 'package:sun_gate_app/features/main_navigation/presentation/controllers/home_bottom_nav_provider.dart';
import 'package:sun_gate_app/features/main_navigation/presentation/widgets/app_bottom_nav_bar.dart';

class CalculatorPageScaffold extends ConsumerWidget {
  final String title;
  final List<Widget> children;
  final bool showBottomNavigation;

  const CalculatorPageScaffold({
    super.key,
    required this.title,
    required this.children,
    this.showBottomNavigation = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CalculatorAppBar(title: title),
      bottomNavigationBar: showBottomNavigation
          ? AppBottomNavBar(
              currentIndex: 1,
              onTap: (index) {
                ref.read(bottomNavProvider.notifier).state = index;
                context.go(RouteNames.main);
              },
            )
          : null,
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final horizontalPadding = width < 360 ? 14.0 : 20.0;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    12,
                    horizontalPadding,
                    24,
                  ),
                  children: children,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
