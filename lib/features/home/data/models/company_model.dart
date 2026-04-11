class CompanyModel {
  final String id;
  final String name;
  final String logoPath;
  final String coverImagePath;
  final String shortDescription;
  final String description;
  final String location;
  final double rating;
  final int reviewCount;
  final List<String> tags;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.coverImagePath,
    required this.shortDescription,
    required this.description,
    required this.location,
    required this.rating,
    required this.reviewCount,
    this.tags = const [],
  });

  CompanyModel copyWith({
    String? id,
    String? name,
    String? logoPath,
    String? coverImagePath,
    String? shortDescription,
    String? description,
    String? location,
    double? rating,
    int? reviewCount,
    List<String>? tags,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoPath: logoPath ?? this.logoPath,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logoPath': logoPath,
      'coverImagePath': coverImagePath,
      'shortDescription': shortDescription,
      'description': description,
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      logoPath: map['logoPath']?.toString() ?? '',
      coverImagePath: map['coverImagePath']?.toString() ?? '',
      shortDescription: map['shortDescription']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      tags: List<String>.from(map['tags'] ?? const []),
    );
  }
}