class CreateProductRequestDto {
  final String title;
  final String description;
  final String category;
  final double price;
  final String condition;
  final String status;
  final String sellAs;
  final List<String> existingImageUrls;

  const CreateProductRequestDto({
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.condition,
    required this.status,
    required this.sellAs,
    this.existingImageUrls = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'condition': condition,
      'status': status,
      'sellAs': sellAs,
      'existingImageUrls': existingImageUrls,
    };
  }
}
