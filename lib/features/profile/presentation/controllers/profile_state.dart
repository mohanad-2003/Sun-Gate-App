
import 'package:sun_gate_app/features/profile/domain/entities/user_profile_entity.dart';

class ProfileState {
  final bool isLoading;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;
  final UserProfileEntity? profile;

  const ProfileState({
    this.isLoading = false,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
    this.profile,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
    UserProfileEntity? profile,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      successMessage: successMessage,
      profile: profile ?? this.profile,
    );
  }

  factory ProfileState.initial() => const ProfileState();
}