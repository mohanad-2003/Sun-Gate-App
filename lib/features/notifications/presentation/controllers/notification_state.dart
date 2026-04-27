import 'package:sun_gate_app/features/notifications/domain/entities/notification_entity.dart';

class NotificationState {
  final bool isLoading;
  final bool isMarking;
  final String? errorMessage;
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationState({
    this.isLoading = false,
    this.isMarking = false,
    this.errorMessage,
    this.notifications = const [],
    this.unreadCount = 0,
  });

  NotificationState copyWith({
    bool? isLoading,
    bool? isMarking,
    String? errorMessage,
    List<NotificationEntity>? notifications,
    int? unreadCount,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      isMarking: isMarking ?? this.isMarking,
      errorMessage: errorMessage,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  factory NotificationState.initial() => const NotificationState();
}
