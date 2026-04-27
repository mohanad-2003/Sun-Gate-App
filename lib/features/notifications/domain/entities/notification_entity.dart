class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final String? createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    this.createdAt,
  });
}
