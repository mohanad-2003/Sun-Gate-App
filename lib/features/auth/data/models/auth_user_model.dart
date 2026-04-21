import 'package:sun_gate_app/features/auth/domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  final String? googleId;
  final String? profileImage;
  final String? imageUri;
  final String? authProvider;
  final bool? isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  const AuthUserModel({
    required super.id,
    required super.email,
    required super.fullName,
    super.firstName,
    super.lastName,
    super.birthday,
    super.location,
    this.googleId,
    this.profileImage,
    this.imageUri,
    this.authProvider,
    this.isEmailVerified,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString();
    final lastName = json['lastName']?.toString();

    return AuthUserModel(
      id: json['_id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName'] != null
          ? json['fullName'].toString()
          : '${firstName ?? ''} ${lastName ?? ''}'.trim(),
      firstName: firstName,
      lastName: lastName,
      birthday: json['birthDate']?.toString(),
      location: json['location']?.toString(),
      googleId: json['googleId']?.toString(),
      profileImage: json['profileImage']?.toString(),
      imageUri: json['imageUri']?.toString(),
      authProvider: json['authProvider']?.toString(),
      isEmailVerified: json['isEmailVerified'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}
