import 'package:dio/dio.dart';
import 'package:sun_gate_app/app/constants/api_constants.dart';
import 'package:sun_gate_app/features/auth/data/models/basic_message_response_modle.dart';
import 'package:sun_gate_app/features/profile/data/dto/change_password_request_dto.dart';
import 'package:sun_gate_app/features/profile/data/dto/update_profile_request_dto.dart';
import 'package:sun_gate_app/features/profile/data/models/image_upload_response_model.dart';
import 'package:sun_gate_app/features/profile/data/models/user_profile_response_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileResponseModel> getMyProfile();

  Future<UserProfileResponseModel> updateProfile(
    UpdateProfileRequestDto request,
  );

  Future<BasicMessageResponseModel> changePassword(
    ChangePasswordRequestDto request,
  );

  Future<ImageUploadResponseModel> uploadProfilePicture({
    required String filePath,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileResponseModel> getMyProfile() async {
    try {
      final response = await dio.get(ApiConstants.getMyProfile);

      return UserProfileResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, fallback: 'Failed to load profile'),
      );
    }
  }

  @override
  Future<UserProfileResponseModel> updateProfile(
    UpdateProfileRequestDto request,
  ) async {
    try {
      print(request.toJson());
      final response = await dio.patch(
        ApiConstants.updateMyProfile,
        data: request.toJson(),
      );
      return UserProfileResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, fallback: 'Failed to update profile'),
      );
    }
  }

  @override
  Future<BasicMessageResponseModel> changePassword(
    ChangePasswordRequestDto request,
  ) async {
    try {
      final response = await dio.patch(
        ApiConstants.changePassword,
        data: request.toJson(),
      );

      return BasicMessageResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, fallback: 'Failed to change password'),
      );
    }
  }

  @override
  Future<ImageUploadResponseModel> uploadProfilePicture({
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(filePath),
      });

      final response = await dio.post(
        ApiConstants.uploadProfilePicture,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return ImageUploadResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception(
        _extractErrorMessage(e, fallback: 'Failed to upload profile picture'),
      );
    }
  }

  String _extractErrorMessage(DioException e, {required String fallback}) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    return fallback;
  }

  Future<void> updateFcmToken(String token) async {
    await dio.patch(ApiConstants.updateFcmToken, data: {'fcmToken': token});
  }
}
