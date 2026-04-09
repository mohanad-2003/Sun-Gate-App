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
    final firstName = json['firstName']?.toString() ?? '';
    final lastName = json['lastName']?.toString() ?? '';
    final fullNameValue = json['fullName']?.toString() ?? '';
    final calculateFullName = fullNameValue.isNotEmpty
        ? fullNameValue
        : '$firstName,$lastName'.trim();
    return UserProfileModels(
      id: json['_id']?.toString() ?? '',
      firstName: firstName,
      lastName: lastName,
      fullName: calculateFullName,
      email: json['email']?.toString() ?? '',
      authProvider: json['authProvider']?.toString() ?? '',
      googleId: json['googleId']?.toString(),
      profileImage: json['profileImage']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      isEmailVarified: json['isEmailVarified'] as bool? ?? false,
      birthDate: json['birthDate']?.toString(),
      gender: json['gender']?.toString(),
      location: json['location']?.toString(),
      whatsappnumbers: json['whatsappNumbers']?.toString(),
      createdAt: json['cratedAt']?.toString(),
      updatedAt: json['updateAt']?.toString(),
    );
  }
}
