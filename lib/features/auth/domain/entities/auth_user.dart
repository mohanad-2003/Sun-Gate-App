class AuthUser {
  final String id;
  final String email;
  final String fullName;
  final String? firstName;
  final String? lastName;
  final String? birthday;
  final String? location;

  const AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    this.firstName,
    this.lastName,
    this.birthday,
    this.location,
  });
}
