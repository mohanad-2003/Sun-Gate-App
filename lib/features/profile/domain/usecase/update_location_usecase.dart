import 'package:sun_gate_app/core/services/location_helper_service.dart';
import 'package:sun_gate_app/features/profile/domain/repositories/profile_repository.dart';

class UpdateLocationUseCase {
  final ProfileRepository repository;

  UpdateLocationUseCase(this.repository);

  Future<void> call() async {
    final location = await LocationHelper.getCurrentLocationName();

    await repository.updateProfile(location: location);
  }
}
