class ApiConstants {
  static const String baseUrl =
      "https://back-end-graduation-project-production.up.railway.app";
  static final String login = '/api/auth/login';
  static final String register = '/api/auth/register';
  static final String veriyfyEmail = '/api/auth/verify-email';
  static final String googleLogin = '/api/auth/google-login';
  static final String forgotPassword = '/api/auth/forgot-password';
  static final String resetPassword = '/api/auth/reset-password';
  static final String getMyProfile = '/api/users/me';
  static final String updateMyProfile = '/api/users/me';
  static final String changePassword = '/api/users/change-password';
  static final String uploadProfilePicture = '/api/users/profile/picture';
}
