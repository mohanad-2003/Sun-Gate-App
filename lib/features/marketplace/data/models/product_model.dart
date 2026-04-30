import 'package:sun_gate_app/features/marketplace/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.price,
    required super.condition,
    required super.status,
    required super.sellAs,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      condition: json['condition']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      sellAs: json['sellAs']?.toString() ?? '',
      images: List<String>.from(json['images'] ?? const []),
    );
  }
}
