import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_gate_app/core/network/dio_provider.dart';
import 'package:sun_gate_app/core/notifications/device_notification_service.dart';
import 'package:sun_gate_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sun_gate_app/features/auth/data/providers/auth_data_providers.dart';
import 'package:sun_gate_app/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:sun_gate_app/features/notifications/data/repositories/notification_repositories_impl.dart';
import 'package:sun_gate_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:sun_gate_app/features/notifications/domain/repositories/notification_repository.dart';
import 'notification_state.dart';

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
      return NotificationRemoteDataSourceImpl(dio: ref.read(dioProvider));
    });

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    remoteDataSource: ref.read(notificationRemoteDataSourceProvider),
  );
});

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationState>((ref) {
      return NotificationController(
        repository: ref.read(notificationRepositoryProvider),
        deviceNotifications: ref.read(deviceNotificationServiceProvider),
        authLocal: ref.read(authLocalDataSourceProvider),
      );
    });

class NotificationController extends StateNotifier<NotificationState> {
  static const _deliveredIdsKey = 'delivered_notification_ids';

  final NotificationRepository repository;
  final DeviceNotificationService deviceNotifications;
  final AuthLocalDataSource authLocal;

  Set<String> _deliveredIds = {};
  bool _bootstrapped = false;

  NotificationController({
    required this.repository,
    required this.deviceNotifications,
    required this.authLocal,
  }) : super(NotificationState.initial()) {
    _loadDeliveredIds();
  }

  Future<void> _loadDeliveredIds() async {
    final prefs = await SharedPreferences.getInstance();
    _deliveredIds = (prefs.getStringList(_deliveredIdsKey) ?? []).toSet();
  }

  Future<void> _saveDeliveredIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_deliveredIdsKey, _deliveredIds.toList());
  }

  Future<void> resetDeliveryTracking() async {
    _deliveredIds = {};
    _bootstrapped = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deliveredIdsKey);
    state = NotificationState.initial();
  }

  Future<void> syncFromServer({
    bool bootstrap = false,
    bool showDeviceAlerts = false,
  }) async {
    final token = await authLocal.getAccessToken();
    if (token == null || token.isEmpty) return;

    try {
      final notifications = await repository.getNotifications();
      final unreadCount = await repository.getUnreadCount();

      state = state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
        errorMessage: null,
      );

      final shouldBootstrap = bootstrap || !_bootstrapped;
      if (shouldBootstrap) {
        _deliveredIds.addAll(notifications.map((item) => item.id));
        _bootstrapped = true;
        await _saveDeliveredIds();
        return;
      }

      if (!showDeviceAlerts) return;

      for (final notification in notifications) {
        if (notification.isRead || _deliveredIds.contains(notification.id)) {
          continue;
        }

        await deviceNotifications.show(
          id: notification.id.hashCode,
          title: notification.title,
          body: notification.body,
          payload: notification.id,
        );
        _deliveredIds.add(notification.id);
      }

      await _saveDeliveredIds();
    } catch (_) {}
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final notifications = await repository.getNotifications();
      final unreadCount = await repository.getUnreadCount();

      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
        unreadCount: unreadCount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> loadUnreadCount() async {
    try {
      final unreadCount = await repository.getUnreadCount();
      state = state.copyWith(unreadCount: unreadCount);
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    try {
      await repository.markAsRead(id);
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == id) {
          return _NotificationViewData.fromEntity(notification, isRead: true);
        }
        return notification;
      }).toList();

      final unreadCount = await repository.getUnreadCount();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> markAllAsRead() async {
    state = state.copyWith(isMarking: true, errorMessage: null);

    try {
      await repository.markAllAsRead();

      final updatedNotifications = state.notifications.map((notification) {
        return _NotificationViewData.fromEntity(notification, isRead: true);
      }).toList();

      final unreadCount = await repository.getUnreadCount();

      state = state.copyWith(
        isMarking: false,
        notifications: updatedNotifications,
        unreadCount: unreadCount,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        isMarking: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }
}

class _NotificationViewData extends NotificationEntity {
  _NotificationViewData({
    required super.id,
    required super.title,
    required super.body,
    required super.isRead,
    super.createdAt,
    super.type,
  });

  factory _NotificationViewData.fromEntity(
    NotificationEntity entity, {
    required bool isRead,
  }) {
    return _NotificationViewData(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      isRead: isRead,
      createdAt: entity.createdAt,
      type: entity.type,
    );
  }
}
