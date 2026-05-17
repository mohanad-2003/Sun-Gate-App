import 'package:dio/dio.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import 'package:sun_gate_app/features/notifications/data/models/notification_model.dart';
import 'package:sun_gate_app/features/notifications/data/models/notifications_page_result.dart';

abstract class NotificationRemoteDataSource {
  Future<NotificationsPageResult> getNotificationsPage({
    int page = 1,
    int limit = 20,
  });

  Future<List<NotificationModel>> getAllNotifications({int limit = 50});

  Future<int> getUnreadCount();

  Future<void> markAllAsRead();

  Future<void> markAsRead(String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  static const _maxPages = 20;

  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _extractDocs(dynamic responseData) {
    final root = _asMap(responseData);
    final data = root['data'];

    dynamic docs;
    if (data is Map<String, dynamic>) {
      docs = data['docs'] ?? data['items'] ?? data['results'] ?? data['rows'];
    } else if (data is List) {
      docs = data;
    }

    docs ??= root['docs'] ?? root['items'] ?? root['results'];

    if (docs is! List) return const [];

    return docs
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  NotificationsPageResult _parsePage(dynamic responseData) {
    final root = _asMap(responseData);
    final data = _asMap(root['data']);
    final docs = _extractDocs(responseData);

    return NotificationsPageResult(
      notifications: docs.map(NotificationModel.fromJson).toList(),
      page: (data['page'] as num?)?.toInt() ?? 1,
      totalPages: (data['totalPages'] as num?)?.toInt() ?? 1,
      totalDocs: (data['totalDocs'] as num?)?.toInt() ?? docs.length,
      hasNextPage: data['hasNextPage'] == true ||
          ((data['nextPage'] as num?)?.toInt() ?? 0) > 0,
    );
  }

  @override
  Future<NotificationsPageResult> getNotificationsPage({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      ApiConstants.getNotifications,
      queryParameters: {
        'page': page,
        'limit': limit.clamp(1, 50),
      },
    );

    return _parsePage(response.data);
  }

  @override
  Future<List<NotificationModel>> getAllNotifications({int limit = 50}) async {
    final all = <NotificationModel>[];
    var page = 1;
    var hasNext = true;

    while (hasNext && page <= _maxPages) {
      final result = await getNotificationsPage(page: page, limit: limit);
      all.addAll(result.notifications);
      hasNext = result.hasNextPage && result.notifications.isNotEmpty;
      page++;
    }

    return all;
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await dio.get(ApiConstants.unreadCount);
    final root = _asMap(response.data);
    final data = _asMap(root['data']);

    return (data['unreadCount'] as num?)?.toInt() ??
        (root['unreadCount'] as num?)?.toInt() ??
        0;
  }

  @override
  Future<void> markAllAsRead() async {
    await dio.post(ApiConstants.markAllAsRead);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final id = notificationId.trim();
    if (id.isEmpty) {
      throw ArgumentError('notificationId is required');
    }

    await dio.patch(ApiConstants.markNotificationRead(id));
  }
}
