class UserProfileEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String authProvider;
  final String? googleId;
  final String? profileImage;
  final String? imageUrl;
  final bool isEmailVarified;
  final String? birthDate;
  final String? gender;
  final String? location;
  final String? whatsappnumbers;
  final String? createdAt;
  final String? updatedAt;

  UserProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.email,
    required this.authProvider,
    this.googleId,
    this.profileImage,
    this.imageUrl,
    required this.isEmailVarified,
    this.birthDate,
    this.gender,
    this.location,
    this.whatsappnumbers,
    this.createdAt,
    this.updatedAt,
  });
  String get displasyName {
    if (fullName.trim().isNotEmpty) return fullName;
    final combined = '$firstName $lastName'.trim();
    if (combined.isNotEmpty) return combined;
    return email;
  }
  
  UserProfileEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? fullName,
    String? email,
    String? authProvider,
    String? googleId,
    String? profileImage,
    String? imageUrl,
    bool? isEmailVarified,
    String? birthDate,
    String? gender,
    String? whatsappNumbers,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      authProvider: authProvider ?? this.authProvider,
      googleId: googleId ?? this.googleId,
      profileImage: profileImage ?? this.profileImage,
      imageUrl: imageUrl ?? this.imageUrl,
      isEmailVarified: isEmailVarified ?? this.isEmailVarified,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      whatsappnumbers: whatsappNumbers ?? whatsappnumbers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
