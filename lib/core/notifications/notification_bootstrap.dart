import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sun_gate_app/app/router/app_router.dart';
import 'package:sun_gate_app/app/router/route_names.dart';
import 'package:sun_gate_app/core/notifications/device_notification_service.dart';
import 'package:sun_gate_app/features/auth/data/providers/auth_data_providers.dart';
import 'package:sun_gate_app/features/notifications/presentation/controllers/notification_controller.dart';

/// Wraps the app to keep in-app + device notifications in sync while logged in.
class NotificationBootstrap extends ConsumerStatefulWidget {
  final Widget child;

  const NotificationBootstrap({super.key, required this.child});

  @override
  ConsumerState<NotificationBootstrap> createState() =>
      _NotificationBootstrapState();
}

class _NotificationBootstrapState extends ConsumerState<NotificationBootstrap>
    with WidgetsBindingObserver {
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_sync(showDeviceAlerts: true));
    }
  }

  Future<void> _start() async {
    await ref.read(deviceNotificationServiceProvider).initialize(
      onTap: (_) {
        AppRouter.router.push(RouteNames.notifications);
      },
    );

    await _sync(bootstrap: true);
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 45),
      (_) => _sync(showDeviceAlerts: true),
    );
  }

  Future<void> _sync({
    bool bootstrap = false,
    bool showDeviceAlerts = false,
  }) async {
    final token = await ref.read(authLocalDataSourceProvider).getAccessToken();
    if (token == null || token.isEmpty) return;

    await ref.read(notificationControllerProvider.notifier).syncFromServer(
          bootstrap: bootstrap,
          showDeviceAlerts: showDeviceAlerts,
        );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Call after actions that may create a server-side notification.
void refreshAppNotifications(WidgetRef ref) {
  unawaited(
    ref.read(notificationControllerProvider.notifier).syncFromServer(
          showDeviceAlerts: true,
        ),
  );
}
