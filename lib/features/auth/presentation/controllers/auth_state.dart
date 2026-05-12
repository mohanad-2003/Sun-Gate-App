enum AuthAction {
  none,
  login,
  companyLogin,
  register,
  forgotPassword,
  resetPassword,
  verifyEmail,
  verifyOtp,
  googleLogin,
  assignPassword,
  resendVerification,
  companySendOtp,
  companyVerifyOtp,
  companyRegister,
  logout,
  deleteAccount
}

class AuthState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? message;
  final String? resetToken;
  final AuthAction action;

  const AuthState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
    this.message,
    this.resetToken,
    required this.action,
  });

  factory AuthState.initial() {
    return const AuthState(
      isLoading: false,
      isSuccess: false,
      errorMessage: null,
      message: null,
      resetToken: null,
      action: AuthAction.none,
    );
  }

  AuthState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? message,
    String? resetToken,
    AuthAction? action,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      message: message,
      resetToken: resetToken,
      action: action ?? this.action,
    );
  }
}
