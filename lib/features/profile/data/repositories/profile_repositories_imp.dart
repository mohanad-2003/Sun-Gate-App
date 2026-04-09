import 'package:sun_gate_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sun_gate_app/features/profile/data/dto/change_password_request_dto.dart';
import 'package:sun_gate_app/features/profile/data/dto/update_profile_request_dto.dart';
import 'package:sun_gate_app/features/profile/domain/entities/user_profile_entity.dart';
import 'package:sun_gate_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfileEntity> getMyProfile() async {
    final result = await remoteDataSource.getMyProfile();
    return result.profile;
  }

  @override
  Future<UserProfileEntity> updateProfile({
    String? firstName,
    String? lastName,
    String? birthDate,
    String? gender,
    String? location,
    String? whatsappNumber,
  }) async {
    final result = await remoteDataSource.updateProfile(
      UpdateProfileRequestDto(
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        gender: gender,
        location: location,
        whatsappNumbers: whatsappNumber,
      ),
    );

    return result.profile;
  }

  @override
  Future<String> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final result = await remoteDataSource.changePassword(
      ChangePasswordRequestDto(
        oldPassword: oldPassword,
        newPassword: newPassword,
      ),
    );

    return result.message;
  }

  @override
  Future<String> uploadProfilePicture({required String filePath}) async {
    final result = await remoteDataSource.uploadProfilePicture(
      filePath: filePath,
    );

    return result.imageUrl;
  }
}
