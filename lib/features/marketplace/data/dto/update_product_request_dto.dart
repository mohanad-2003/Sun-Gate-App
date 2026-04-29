class UpdateProductRequestDto {
  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final String? condition;
  final String? status;
  final String? sellAs;
  final bool? replaceImages;
  final List<String>? existingImageUrls;

  const UpdateProductRequestDto({
    this.title,
    this.description,
    this.category,
    this.price,
    this.condition,
    this.status,
    this.sellAs,
    this.replaceImages,
    this.existingImageUrls,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (condition != null) 'condition': condition,
      if (status != null) 'status': status,
      if (sellAs != null) 'sellAs': sellAs,
      if (replaceImages != null) 'replaceImages': replaceImages,
      if (existingImageUrls != null) 'existingImageUrls': existingImageUrls,
    };
  }
}