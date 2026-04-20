class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final String? message;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.message,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    String? message,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
    );
  }

  factory AuthState.initial() => const AuthState();
}
