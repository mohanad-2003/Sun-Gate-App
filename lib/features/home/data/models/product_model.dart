class ProductModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.images,
  });

  String get imageUrl => images.isNotEmpty ? images.first : '';

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'],
      price: (json['price'] as num?)?.toDouble() ?? 0,
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
