import 'package:sun_gate_app/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:sun_gate_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:sun_gate_app/features/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> getNotifications() {
    return remoteDataSource.getAllNotifications();
  }

  @override
  Future<int> getUnreadCount() {
    return remoteDataSource.getUnreadCount();
  }

  @override
  Future<void> markAllAsRead() {
    return remoteDataSource.markAllAsRead();
  }

  @override
  Future<void> markAsRead(String id) {
    return remoteDataSource.markAsRead(id);
  }
}
