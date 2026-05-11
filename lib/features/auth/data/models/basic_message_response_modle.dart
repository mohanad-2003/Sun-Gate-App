class BasicMessageResponseModel {
  final bool success;
  final String message;
  final String? passwordResetToken;
  final String? registrationToken;

  const BasicMessageResponseModel({
    required this.success,
    required this.message,
    this.passwordResetToken,
    this.registrationToken,
  });

  factory BasicMessageResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    return BasicMessageResponseModel(
      success: json['success'] == true,
      message:
          data?['message']?.toString() ?? json['message']?.toString() ?? '',
      passwordResetToken:
          data?['passwordResetToken']?.toString() ??
          json['passwordResetToken']?.toString(),
      registrationToken:
          data?['registrationToken']?.toString() ??
          json['registrationToken']?.toString(),
    );
  }
}
