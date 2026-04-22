class CategoryItemModel {
  final String id;
  final String titleKey;
  final String imagePath;

  CategoryItemModel({
    required this.id,
    required this.titleKey,
    required this.imagePath,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    return CategoryItemModel(
      id: json['id']?.toString() ?? '',
      titleKey: json['titleKey']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKey': titleKey,
      'imagePath': imagePath,
    };
  }
}