
import 'package:sun_gate_app/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getMyProfile();

  Future<UserProfileEntity> updateProfile({
    String? firstName,
    String? lastName,
    String? birthDate,
    String? gender,
    String? location,
    String? whatsappNumber,
  });

  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<String> uploadProfilePicture({
    required String filePath,
  });
}