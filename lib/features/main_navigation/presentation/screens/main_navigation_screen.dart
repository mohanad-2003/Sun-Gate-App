import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:sun_gate_app/features/home/presentation/screens/home_screen.dart';
import 'package:sun_gate_app/features/main_navigation/presentation/controllers/home_bottom_nav_provider.dart';
import 'package:sun_gate_app/features/main_navigation/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:sun_gate_app/features/marketplace/presentation/controllers/market_place_controller.dart';
import 'package:sun_gate_app/features/marketplace/presentation/screen/market_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(marketPlaceControllerProvider.notifier).getMyCompany(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavProvider);
    final pages = const [
      HomeScreen(),
      CalculatorScreen(),
      InstructionsScreen(),
      SuppliersScreen(),
      MarketScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(bottomNavProvider.notifier).state = index,
      ),
    );
  }
}

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Instructions Screen')));
  }
}

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Suppliers Screen')));
  }
}
