class BasicMessageResponseModel {
  final bool success;
  final String message;

  BasicMessageResponseModel({required this.success, required this.message});

  factory BasicMessageResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return BasicMessageResponseModel(
      success: json['success'] as bool? ?? false,
      message:
          data?['message']?.toString() ?? json['message']?.toString() ?? '',
    );
  }
}
