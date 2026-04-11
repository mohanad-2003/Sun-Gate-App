class CompanyModel {
  final String id;
  final String name;
  final String imagePath;
  final String shortDescription;
  final List<String> tags;

  const CompanyModel({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.shortDescription,
    required this.tags,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? '',
      shortDescription: json['shortDescription']?.toString() ?? '',
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'shortDescription': shortDescription,
      'tags': tags,
    };
  }
}
