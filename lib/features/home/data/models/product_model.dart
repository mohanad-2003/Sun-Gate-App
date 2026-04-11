class ProductModel {
  final String id;
  final String name;
  final String imagePath;
  final String shortDescription;
  final double price;

  const ProductModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.shortDescription,
    required this.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? '',
      shortDescription: json['shortDescription']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'shortDescription': shortDescription,
      'price': price,
    };
  }
}
