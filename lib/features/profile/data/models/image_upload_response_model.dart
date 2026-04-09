
class ImageUploadResponseModel {
  final bool success;
  final String imageUrl;

  const ImageUploadResponseModel({
    required this.success,
    required this.imageUrl,
  });

  factory ImageUploadResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return ImageUploadResponseModel(
      success: json['success'] as bool? ?? false,
      imageUrl: data?['imageUrl']?.toString() ?? '',
    );
  }
}
