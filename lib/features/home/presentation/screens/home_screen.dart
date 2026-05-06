import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/home_mock_data_provider.dart';
import 'package:sun_gate_app/features/home/presentation/controllers/weather_provider.dart';
import 'package:sun_gate_app/features/home/presentation/widgets/home_header_section.dart';
import 'package:sun_gate_app/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:sun_gate_app/features/profile/presentation/controllers/profile_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(profileControllerProvider.notifier).getMyProfile();
      ref.read(notificationControllerProvider.notifier).loadUnreadCount();

      final locale = Localizations.localeOf(context).languageCode;
      ref.read(homeControllerProvider.notifier).loadProducts();
      ref.read(weatherProvider.notifier).fetchWeather(locale);
      ref.read(weatherProvider.notifier).startAutoRefresh(locale);

      Future.microtask(() {
        ref.read(homeControllerProvider.notifier).loadProducts();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SingleChildScrollView(child: HomeHeaderSection()),
    );
  }
}
