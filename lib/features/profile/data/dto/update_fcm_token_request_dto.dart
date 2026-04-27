class UpdateFcmTokenRequestDto {
  final String fcmToken;
  const UpdateFcmTokenRequestDto({required this.fcmToken});

  Map<String, dynamic> toJson() {
    return {'fcmToken': fcmToken};
  }
}
