import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
