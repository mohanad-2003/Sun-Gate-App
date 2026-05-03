class RegisterRequestDto {
  final String firstName;
  final String lastName;
  final String email;
  final String birthDate;
  final String location;
  const RegisterRequestDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.trim(),
      'birthDate': birthDate,
      'location': location,
    };
  }
}
