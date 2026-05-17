class AdminArticleEntity {
  final String id;
  final String title;
  final String body;
  final String? coverUrl;
  final String? authorId;
  final String? createdAt;

  const AdminArticleEntity({
    required this.id,
    required this.title,
    required this.body,
    this.coverUrl,
    this.authorId,
    this.createdAt,
  });
}
