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
    final fullNameValue = json['fullName']?.toString().trim() ?? '';
    final companyNameValue = json['companyName']?.toString().trim() ?? '';
    final ownerNameValue = json['ownerName']?.toString().trim() ?? '';
    final normalizedFullName = fullNameValue.isNotEmpty
        ? fullNameValue
        : companyNameValue.isNotEmpty
        ? companyNameValue
        : ownerNameValue;

    final nameParts = normalizedFullName.split(' ');

    final firstNameValue = normalizedFullName.isNotEmpty
        ? nameParts.first
        : json['firstName']?.toString() ?? companyNameValue;

    final lastNameValue = normalizedFullName.isNotEmpty && nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : json['lastName']?.toString() ?? '';

    return UserProfileModels(
      id: json['_id']?.toString() ?? '',
      firstName: firstNameValue,
      lastName: lastNameValue,
      fullName: normalizedFullName.isNotEmpty
          ? normalizedFullName
          : '$firstNameValue $lastNameValue'.trim(),
      email: json['email']?.toString() ?? '',
      authProvider: json['authProvider']?.toString() ?? '',
      googleId: json['googleId']?.toString(),
      profileImage: json['profileImage']?.toString(),
      imageUrl: json['profileImageUrl']?.toString(),
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
