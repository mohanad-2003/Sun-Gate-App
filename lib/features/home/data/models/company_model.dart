class CompanyModel {
  final String id;
  final String nameKey;
  final String logoPath;
  final String coverImagePath;
  final String shortDescriptionKey;
  final String descriptionKey;
  final String locationKey;
  final double rating;
  final int reviewCount;
  final List<String> tagKeys;

  const CompanyModel({
    required this.id,
    required this.nameKey,
    required this.logoPath,
    required this.coverImagePath,
    required this.shortDescriptionKey,
    required this.descriptionKey,
    required this.locationKey,
    required this.rating,
    required this.reviewCount,
    this.tagKeys = const [],
  });

  CompanyModel copyWith({
    String? id,
    String? nameKey,
    String? logoPath,
    String? coverImagePath,
    String? shortDescriptionKey,
    String? descriptionKey,
    String? locationKey,
    double? rating,
    int? reviewCount,
    List<String>? tagKeys,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      logoPath: logoPath ?? this.logoPath,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      shortDescriptionKey:
          shortDescriptionKey ?? this.shortDescriptionKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      locationKey: locationKey ?? this.locationKey,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tagKeys: tagKeys ?? this.tagKeys,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameKey': nameKey,
      'logoPath': logoPath,
      'coverImagePath': coverImagePath,
      'shortDescriptionKey': shortDescriptionKey,
      'descriptionKey': descriptionKey,
      'locationKey': locationKey,
      'rating': rating,
      'reviewCount': reviewCount,
      'tagKeys': tagKeys,
    };
  }

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id']?.toString() ?? '',
      nameKey: map['nameKey']?.toString() ?? '',
      logoPath: map['logoPath']?.toString() ?? '',
      coverImagePath: map['coverImagePath']?.toString() ?? '',
      shortDescriptionKey:
          map['shortDescriptionKey']?.toString() ?? '',
      descriptionKey: map['descriptionKey']?.toString() ?? '',
      locationKey: map['locationKey']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
      tagKeys: List<String>.from(map['tagKeys'] ?? const []),
    );
  }
}