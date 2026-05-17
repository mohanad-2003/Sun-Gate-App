class AdminAccountEntity {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String accountStatus;
  final String? phoneWhatsapp;
  final String? location;
  final String? profileImageUrl;

  const AdminAccountEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.accountStatus,
    this.phoneWhatsapp,
    this.location,
    this.profileImageUrl,
  });

  bool get isActive => accountStatus.toLowerCase() == 'active';
  bool get isSuspended => accountStatus.toLowerCase() == 'suspended';
}
