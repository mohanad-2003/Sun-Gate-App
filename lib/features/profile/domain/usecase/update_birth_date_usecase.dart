import 'package:sun_gate_app/features/profile/domain/repositories/profile_repository.dart';

class UpdateBirthDateUseCase {
  final ProfileRepository repository;

  UpdateBirthDateUseCase(this.repository);

  Future<void> call(DateTime date) async {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    final formatted = "${date.year}-$month-$day";

    await repository.updateProfile(birthDate: formatted);
  }
}