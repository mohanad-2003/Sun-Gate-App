class ApiConstants {
  static const String baseUrl =
      "https://back-end-graduation-project-production.up.railway.app";
  static final String login = '/api/auth/login';
  static final String register = '/api/auth/register';
  static const String verifyEmail = '/api/auth/verify-email';
  static final String googleLogin = '/api/auth/google-login';
  static final String forgotPassword = '/api/auth/forgot-password';
  static final String resetPassword = '/api/auth/reset-password';
  static final String getMyProfile = '/api/users/me';
  static const String updateMyProfile = '/api/users/me';
  static final String changePassword = '/api/users/change-password';
  static final String uploadProfilePicture = '/api/users/profile/picture';
  static final String home = '/api/home';
  static const String verifyResetOtp = '/api/auth/verify-password-reset-token';
  static const getNotifications = '/api/notifications';
  static const unreadCount = '/api/notifications/unread-count';
  static const markAllAsRead = '/api/notifications/read-all';
  static const markAsRead = '/api/notifications/'; // +{id}/read
  static const updateFcmToken = '/api/users/me/fcm-token';
  static const String companies = '/api/companies';
  static const String myCompany = '/api/companies/me';

  static String updateCompany(String companyId) => '/api/companies/$companyId';

  static String uploadCompanyLogo(String companyId) =>
      '/api/companies/$companyId/logo';
}
