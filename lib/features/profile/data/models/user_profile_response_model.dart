import 'package:sun_gate_app/features/profile/data/models/user_profile_models.dart';

  
class UserProfileResponseModel {
  final bool success;
  final UserProfileModels profile;

  const UserProfileResponseModel({
    required this.success,
    required this.profile,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UserProfileResponseModel(
      success: json['success'] as bool? ?? false,
      profile: UserProfileModels.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }
}