import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deviceNotificationServiceProvider = Provider<DeviceNotificationService>(
  (ref) => DeviceNotificationService(),
);

typedef NotificationTapHandler = void Function(String? payload);

class DeviceNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  NotificationTapHandler? _onTap;

  static const _androidChannel = AndroidNotificationChannel(
    'sun_gate_alerts',
    'Sun Gate alerts',
    description: 'Updates about your account, requests, and marketplace activity',
    importance: Importance.high,
  );

  Future<void> initialize({required NotificationTapHandler onTap}) async {
    if (_initialized) return;

    _onTap = onTap;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: (response) {
        _onTap?.call(response.payload);
      },
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) return;

    final resolvedTitle = title.trim().isEmpty ? 'Sun Gate' : title.trim();
    final resolvedBody = body.trim().isEmpty ? 'You have a new update' : body.trim();

    try {
      await _plugin.show(
        id,
        resolvedTitle,
        resolvedBody,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        payload: payload,
      );
    } catch (error, stackTrace) {
      debugPrint('Device notification error: $error');
      debugPrint('$stackTrace');
    }
  }
}
