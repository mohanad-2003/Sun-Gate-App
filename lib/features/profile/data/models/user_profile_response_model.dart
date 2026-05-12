import 'package:sun_gate_app/features/profile/data/models/user_profile_models.dart';

class UserProfileResponseModel {
  final bool success;
  final UserProfileModels profile;

  const UserProfileResponseModel({
    required this.success,
    required this.profile,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final profileJson =
        data is Map<String, dynamic>
            ? ((data['user'] as Map<String, dynamic>?) ??
                  (data['company'] as Map<String, dynamic>?) ??
                  data)
            : <String, dynamic>{};

    return UserProfileResponseModel(
      success: json['success'] as bool? ?? false,
      profile: UserProfileModels.fromJson(profileJson),
    );
  }
}
