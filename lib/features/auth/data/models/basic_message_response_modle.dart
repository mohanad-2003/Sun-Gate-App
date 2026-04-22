class BasicMessageResponseModel {
  final bool success;
  final String message;
  final String? passwordResetToken;

  const BasicMessageResponseModel({
    required this.success,
    required this.message,
    this.passwordResetToken,
  });

  factory BasicMessageResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    return BasicMessageResponseModel(
      success: json['success'] == true,
      message:
          data?['message']?.toString() ?? json['message']?.toString() ?? '',
      passwordResetToken: data?['passwordResetToken']?.toString(),
    );
  }
}
