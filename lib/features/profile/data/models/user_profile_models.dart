import 'package:sun_gate_app/features/profile/domain/entities/user_profile_entity.dart';

class UserProfileModels extends UserProfileEntity {
  UserProfileModels({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.fullName,
    required super.email,
    required super.authProvider,
    super.googleId,
    super.profileImage,
    super.imageUrl,
    required super.isEmailVarified,
    super.birthDate,
    super.gender,
    super.location,
    super.whatsappnumbers,
    super.createdAt,
    super.updatedAt,
  });

  factory UserProfileModels.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString().trim() ?? '';
    final lastName = json['lastName']?.toString().trim() ?? '';
    final fullNameValue = json['fullName']?.toString().trim() ?? '';

    final calculatedFullName = fullNameValue.isNotEmpty
        ? fullNameValue
        : '$firstName $lastName'.trim();

    return UserProfileModels(
      id: json['_id']?.toString() ?? '',
      firstName: firstName,
      lastName: lastName,
      fullName: calculatedFullName,
      email: json['email']?.toString() ?? '',
      authProvider: json['authProvider']?.toString() ?? '',
      googleId: json['googleId']?.toString(),
      profileImage: json['profileImage']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      isEmailVarified:
          (json['isEmailVerified'] as bool?) ??
          (json['isEmailVarified'] as bool?) ??
          false,
      birthDate: json['birthDate']?.toString(),
      gender: json['gender']?.toString(),
      location: json['location']?.toString(),
      whatsappnumbers:
          json['whatsappNumbers']?.toString() ??
          json['whatsappnumbers']?.toString(),
      createdAt: json['createdAt']?.toString() ?? json['cratedAt']?.toString(),
      updatedAt: json['updatedAt']?.toString() ?? json['updateAt']?.toString(),
    );
  }
}
