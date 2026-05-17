import 'package:sun_gate_app/features/admin/domain/entities/admin_article_entity.dart';

class AdminArticleModel extends AdminArticleEntity {
  const AdminArticleModel({
    required super.id,
    required super.title,
    required super.body,
    super.coverUrl,
    super.authorId,
    super.createdAt,
  });

  factory AdminArticleModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : <String, dynamic>{};

    return AdminArticleModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body:
          dataMap['body']?.toString() ??
          dataMap['details']?.toString() ??
          dataMap['content']?.toString() ??
          json['body']?.toString() ??
          '',
      coverUrl:
          dataMap['coverUrl']?.toString() ??
          json['coverUrl']?.toString(),
      authorId: json['authorId']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
}
