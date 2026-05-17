import 'package:sun_gate_app/features/notifications/data/models/notification_model.dart';

class NotificationsPageResult {
  final List<NotificationModel> notifications;
  final int page;
  final int totalPages;
  final int totalDocs;
  final bool hasNextPage;

  const NotificationsPageResult({
    required this.notifications,
    required this.page,
    required this.totalPages,
    required this.totalDocs,
    required this.hasNextPage,
  });

  factory NotificationsPageResult.empty() {
    return const NotificationsPageResult(
      notifications: [],
      page: 1,
      totalPages: 0,
      totalDocs: 0,
      hasNextPage: false,
    );
  }
}
