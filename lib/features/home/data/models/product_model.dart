class ProductModel {
  final String id;
  final String companyId;
  final String nameKey;
  final String imagePath;
  final String imageProfile;
  final String descriptionKey;
  final List<String> howItWorksKeys;
  final double price;
  final String ownerNameKey;
  final String ownerRoleKey;
  final String ownerPhone;
  final String ownerEmail;
  final List<String> tagKeys;

  const ProductModel({
    required this.id,
    required this.companyId,
    required this.nameKey,
    required this.imagePath,
    required this.descriptionKey,
    required this.howItWorksKeys,
    required this.price,
    required this.ownerNameKey,
    required this.ownerRoleKey,
    required this.ownerPhone,
    required this.ownerEmail,
    this.tagKeys = const [],
    required this.imageProfile,
  });

  ProductModel copyWith({
    String? id,
    String? companyId,
    String? nameKey,
    String? imagePath,
    String? imageProfile,
    String? descriptionKey,
    List<String>? howItWorksKeys,
    double? price,
    String? ownerNameKey,
    String? ownerRoleKey,
    String? ownerPhone,
    String? ownerEmail,
    List<String>? tagKeys,
  }) {
    return ProductModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      nameKey: nameKey ?? this.nameKey,
      imagePath: imagePath ?? this.imagePath,
      imageProfile: imageProfile ?? this.imageProfile,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      howItWorksKeys: howItWorksKeys ?? this.howItWorksKeys,
      price: price ?? this.price,
      ownerNameKey: ownerNameKey ?? this.ownerNameKey,
      ownerRoleKey: ownerRoleKey ?? this.ownerRoleKey,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      tagKeys: tagKeys ?? this.tagKeys,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyId': companyId,
      'nameKey': nameKey,
      'imagePath': imagePath,
      'imageProfile': imageProfile,
      'descriptionKey': descriptionKey,
      'howItWorksKeys': howItWorksKeys,
      'price': price,
      'ownerNameKey': ownerNameKey,
      'ownerRoleKey': ownerRoleKey,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'tagKeys': tagKeys,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString() ?? '',
      companyId: map['companyId']?.toString() ?? '',
      nameKey: map['nameKey']?.toString() ?? '',
      imagePath: map['imagePath']?.toString() ?? '',
      imageProfile: map['imageProfile']?.toString() ?? '',
      descriptionKey: map['descriptionKey']?.toString() ?? '',
      howItWorksKeys: List<String>.from(map['howItWorksKeys'] ?? const []),
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      ownerNameKey: map['ownerNameKey']?.toString() ?? '',
      ownerRoleKey: map['ownerRoleKey']?.toString() ?? '',
      ownerPhone: map['ownerPhone']?.toString() ?? '',
      ownerEmail: map['ownerEmail']?.toString() ?? '',
      tagKeys: List<String>.from(map['tagKeys'] ?? const []),
    );
  }
}