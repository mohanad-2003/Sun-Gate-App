import 'package:sun_gate_app/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.isRead,
    super.createdAt,
    super.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final readValue = json['isRead'] ?? json['read'] ?? json['is_read'];

    return NotificationModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: _firstNonEmptyString([
        json['title'],
        json['subject'],
        json['heading'],
      ]),
      body: _firstNonEmptyString([
        json['body'],
        json['message'],
        json['content'],
        json['text'],
        json['description'],
      ]),
      isRead: readValue is bool
          ? readValue
          : readValue?.toString().toLowerCase() == 'true',
      createdAt:
          json['createdAt']?.toString() ?? json['created_at']?.toString(),
      type: json['type']?.toString() ?? json['category']?.toString(),
    );
  }

  static String _firstNonEmptyString(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return '';
  }
}
