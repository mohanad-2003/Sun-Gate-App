class AuthState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? message;
  final String? resetToken;
  
  const AuthState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    this.message,
    this.resetToken,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoading: false,
      isSuccess: false,
      errorMessage: null,
      message: null,
      resetToken: null,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? message,
    String? resetToken,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      message: message,
      resetToken: resetToken,
    );
  }
}
