import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sun_gate_app/core/network/dio_provider.dart';
import 'package:sun_gate_app/core/services/location_helper_service.dart';
import 'package:sun_gate_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:sun_gate_app/features/profile/data/repositories/profile_repositories_imp.dart';
import 'package:sun_gate_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:sun_gate_app/features/profile/domain/usecase/update_birth_date_usecase.dart';
import 'package:sun_gate_app/features/profile/domain/usecase/update_location_usecase.dart';
import 'profile_state.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSourceImpl(dio: ref.read(dioProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.read(profileRemoteDataSourceProvider),
  );
});
final updateBirthDateUseCaseProvider = Provider(
  (ref) => UpdateBirthDateUseCase(ref.read(profileRepositoryProvider)),
);

final updateLocationUseCaseProvider = Provider(
  (ref) => UpdateLocationUseCase(ref.read(profileRepositoryProvider)),
);
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
      return ProfileController(
        repository: ref.read(profileRepositoryProvider),
        updateBirthDateUseCase: ref.read(updateBirthDateUseCaseProvider),
        updateLocationUseCase: ref.read(updateLocationUseCaseProvider),
      );
    });

class ProfileController extends StateNotifier<ProfileState> {
  final ProfileRepository repository;
  final UpdateBirthDateUseCase updateBirthDateUseCase;
  final UpdateLocationUseCase updateLocationUseCase;

  ProfileController({
    required this.repository,
    required this.updateBirthDateUseCase,
    required this.updateLocationUseCase,
  }) : super(ProfileState.initial());

  Future<void> getMyProfile() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final profile = await repository.getMyProfile();

      state = state.copyWith(isLoading: false, profile: profile);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void setGooglePhoto(String? photo) {
    state = state.copyWith(googlePhoto: photo);
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? gender,
    String? location,
    String? birthDate,
    String? whatsappNumber,
  }) async {
    state = state.copyWith(isSaving: true);

    try {
      final profile = await repository.updateProfile(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        location: location,
        birthDate: birthDate,
        whatsappNumber: whatsappNumber,
      );

      state = state.copyWith(
        isSaving: false,
        profile: profile,
        successMessage: 'Profile updated successfully',
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final message = await repository.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      state = state.copyWith(isSaving: false, successMessage: message);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> uploadProfilePicture({required String filePath}) async {
    state = state.copyWith(
      isSaving: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final imageUrl = await repository.uploadProfilePicture(
        filePath: filePath,
      );

      final current = state.profile;
      if (current != null) {
        state = state.copyWith(
          isSaving: false,
          profile: current.copyWith(imageUrl: imageUrl),
          successMessage: 'Profile picture updated successfully',
        );
      } else {
        await getMyProfile();
      }
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> updateBirthDate(DateTime date) async {
    state = state.copyWith(isSaving: true);

    try {
      await updateBirthDateUseCase(date);

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Birth date updated',
      );

      await getMyProfile();
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
    }
  }

  Future<void> updateLocation() async {
    state = state.copyWith(isSaving: true);

    try {
      await updateLocationUseCase();

      state = state.copyWith(
        isSaving: false,
        successMessage: 'Location updated',
      );

      await getMyProfile();
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
    }
  }
  Future<String> getLocationForCompleteProfile() async {
  final location = await LocationHelper.getCurrentLocationName();
  return location;
}
}
