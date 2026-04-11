class ProductModel {
  final String id;
  final String companyId;
  final String name;
  final String imagePath;
  final String description;
  final List<String> howItWorks;
  final double price;
  final String ownerName;
  final String ownerRole;
  final String ownerPhone;
  final String ownerEmail;
  final List<String> tags;

  const ProductModel({
    required this.id,
    required this.companyId,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.howItWorks,
    required this.price,
    required this.ownerName,
    required this.ownerRole,
    required this.ownerPhone,
    required this.ownerEmail,
    this.tags = const [],
  });

  ProductModel copyWith({
    String? id,
    String? companyId,
    String? name,
    String? imagePath,
    String? description,
    List<String>? howItWorks,
    double? price,
    String? ownerName,
    String? ownerRole,
    String? ownerPhone,
    String? ownerEmail,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      howItWorks: howItWorks ?? this.howItWorks,
      price: price ?? this.price,
      ownerName: ownerName ?? this.ownerName,
      ownerRole: ownerRole ?? this.ownerRole,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyId': companyId,
      'name': name,
      'imagePath': imagePath,
      'description': description,
      'howItWorks': howItWorks,
      'price': price,
      'ownerName': ownerName,
      'ownerRole': ownerRole,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'tags': tags,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString() ?? '',
      companyId: map['companyId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      imagePath: map['imagePath']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      howItWorks: List<String>.from(map['howItWorks'] ?? const []),
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      ownerName: map['ownerName']?.toString() ?? '',
      ownerRole: map['ownerRole']?.toString() ?? '',
      ownerPhone: map['ownerPhone']?.toString() ?? '',
      ownerEmail: map['ownerEmail']?.toString() ?? '',
      tags: List<String>.from(map['tags'] ?? const []),
    );
  }
}