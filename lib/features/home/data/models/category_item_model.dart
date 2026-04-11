class CategoryItemModel {
  final String id;
  final String title;
  final String imagePath;

  CategoryItemModel({
    required this.id,
    required this.title,
    required this.imagePath,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {"id": id, 'title': title, 'imagePath': imagePath};
  }
}
