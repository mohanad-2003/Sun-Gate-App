import 'package:dio/dio.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAllAsRead();
  Future<void> markAsRead(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await dio.get(ApiConstants.getNotifications);

    final List list = response.data['data']['docs'] ?? [];
    print(response.data);

    return list.map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await dio.get(ApiConstants.unreadCount);

    return response.data['data']['unreadCount'] ?? 0;
  }

  @override
  Future<void> markAllAsRead() async {
    await dio.post(ApiConstants.markAllAsRead);
  }

  @override
  Future<void> markAsRead(String id) async {
    await dio.patch('/api/notifications/$id/read');
  }
}
