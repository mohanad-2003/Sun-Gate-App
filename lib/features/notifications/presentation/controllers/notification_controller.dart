import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/core/network/dio_provider.dart';
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
      );
    });

class NotificationController extends StateNotifier<NotificationState> {
  final NotificationRepository repository;

  NotificationController({required this.repository})
    : super(NotificationState.initial());

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

      final newUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
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

      state = state.copyWith(
        isMarking: false,
        notifications: updatedNotifications,
        unreadCount: 0,
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
    );
  }
}
