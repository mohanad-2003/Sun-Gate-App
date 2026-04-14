import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/calculator/presentation/screens/calculator_screen.dart';
import 'package:sun_gate_app/features/home/presentation/screens/home_screen.dart';
import 'package:sun_gate_app/features/main_navigation/presentation/controllers/home_bottom_nav_provider.dart';
import 'package:sun_gate_app/features/main_navigation/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:sun_gate_app/features/profile/presentation/screens/profile_screen.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);

    final pages = const [
      HomeScreen(),
      CalculatorScreen(),
      InstructionsPlaceholderScreen(),
      SuppliersPlaceholderScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) => {ref.read(bottomNavProvider.notifier).state = index},
      ),
    );
  }
}



class InstructionsPlaceholderScreen extends StatelessWidget {
  const InstructionsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Instructions Screen')));
  }
}

class SuppliersPlaceholderScreen extends StatelessWidget {
  const SuppliersPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Suppliers Screen')));
  }
}
