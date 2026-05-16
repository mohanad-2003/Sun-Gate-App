class ProductEntity {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String condition;
  final String status;
  final String sellAs;
  final List<String> images;
  final String? ownerCompanyId;
  final bool? isOwnedByCurrentUser;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.condition,
    required this.status,
    required this.sellAs,
    required this.images,
    this.ownerCompanyId,
    this.isOwnedByCurrentUser,
  });
}
