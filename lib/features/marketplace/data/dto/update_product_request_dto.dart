class UpdateProductRequestDto {
  final String? title;
  final String? description;
  final String? category;
  final double? price;
  final String? condition;
  final String? status;
  final bool? replaceImages;

  const UpdateProductRequestDto({
    this.title,
    this.description,
    this.category,
    this.price,
    this.condition,
    this.status,
    this.replaceImages,
  });

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (condition != null) 'condition': condition,
      if (status != null) 'status': status,
      if (replaceImages != null) 'replaceImages': replaceImages,
    };
  }
}
