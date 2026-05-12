import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Sun Gate'**
  String get appName;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordsMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get passwordsMatch;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @legal_and_policies.
  ///
  /// In en, this message translates to:
  /// **'Legal and Policies'**
  String get legal_and_policies;

  /// No description provided for @help_and_center.
  ///
  /// In en, this message translates to:
  /// **'Help & Center'**
  String get help_and_center;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @userEmail.
  ///
  /// In en, this message translates to:
  /// **'user@example.com'**
  String get userEmail;

  /// No description provided for @legalCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'SunGate Legal Center'**
  String get legalCenterTitle;

  /// No description provided for @legalCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please read these policies carefully before using the application and services.'**
  String get legalCenterSubtitle;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: April 2026'**
  String get lastUpdated;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get needHelp;

  /// No description provided for @legalSupportNote.
  ///
  /// In en, this message translates to:
  /// **'If you have any legal questions or privacy concerns, please contact our support team.'**
  String get legalSupportNote;

  /// No description provided for @termsOfUseTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Terms of Use'**
  String get termsOfUseTitle;

  /// No description provided for @termsOfUseContent.
  ///
  /// In en, this message translates to:
  /// **'By using SunGate, you agree to comply with the application terms, applicable laws, and responsible usage of all available features. Users are expected to provide accurate account information and avoid misuse of the platform.'**
  String get termsOfUseContent;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyContent.
  ///
  /// In en, this message translates to:
  /// **'We collect only the information necessary to provide and improve our services. This may include account details, profile information, and usage-related data. We do not sell your personal information to third parties.'**
  String get privacyPolicyContent;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Account and Security'**
  String get accountSecurityTitle;

  /// No description provided for @accountSecurityContent.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your login credentials. Any activity performed through your account is considered your responsibility unless reported otherwise.'**
  String get accountSecurityContent;

  /// No description provided for @userContentDataTitle.
  ///
  /// In en, this message translates to:
  /// **'4. User Content and Data'**
  String get userContentDataTitle;

  /// No description provided for @userContentDataContent.
  ///
  /// In en, this message translates to:
  /// **'Any data, profile information, images, or content uploaded by the user must be lawful, accurate, and appropriate. We reserve the right to remove content that violates our service guidelines.'**
  String get userContentDataContent;

  /// No description provided for @serviceChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Changes to the Service'**
  String get serviceChangesTitle;

  /// No description provided for @serviceChangesContent.
  ///
  /// In en, this message translates to:
  /// **'SunGate may update, improve, suspend, or modify parts of the service at any time to enhance the user experience, maintain security, or comply with technical and legal requirements.'**
  String get serviceChangesContent;

  /// No description provided for @policyUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Policy Updates'**
  String get policyUpdatesTitle;

  /// No description provided for @policyUpdatesContent.
  ///
  /// In en, this message translates to:
  /// **'We may revise these legal policies from time to time. Updated versions will be reflected inside the application with a new last-updated date. Continued use of the service means acceptance of the revised policies.'**
  String get policyUpdatesContent;

  /// No description provided for @helpSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupportTitle;

  /// No description provided for @helpSupportCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support Center'**
  String get helpSupportCenterTitle;

  /// No description provided for @helpSupportCenterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find answers to common questions and contact our support team if you need more help.'**
  String get helpSupportCenterSubtitle;

  /// No description provided for @searchForHelp.
  ///
  /// In en, this message translates to:
  /// **'Search for help...'**
  String get searchForHelp;

  /// No description provided for @stillNeedHelp.
  ///
  /// In en, this message translates to:
  /// **'Still need help?'**
  String get stillNeedHelp;

  /// No description provided for @helpSupportContactNote.
  ///
  /// In en, this message translates to:
  /// **'Our support team is here to assist you with account issues, password recovery, and general questions.'**
  String get helpSupportContactNote;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @faqUpdateProfileQuestion.
  ///
  /// In en, this message translates to:
  /// **'How can I update my profile information?'**
  String get faqUpdateProfileQuestion;

  /// No description provided for @faqUpdateProfileAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to your profile screen, open User Info, edit the fields you want, then press Save Changes.'**
  String get faqUpdateProfileAnswer;

  /// No description provided for @faqChangePasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do I change my password?'**
  String get faqChangePasswordQuestion;

  /// No description provided for @faqChangePasswordAnswer.
  ///
  /// In en, this message translates to:
  /// **'Open the Change Password screen from your profile menu, enter your current password and then your new password.'**
  String get faqChangePasswordAnswer;

  /// No description provided for @faqForgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password. What should I do?'**
  String get faqForgotPasswordQuestion;

  /// No description provided for @faqForgotPasswordAnswer.
  ///
  /// In en, this message translates to:
  /// **'Use the Forgot Password option on the login screen. A reset code will be sent to your registered email address.'**
  String get faqForgotPasswordAnswer;

  /// No description provided for @faqUploadProfileImageQuestion.
  ///
  /// In en, this message translates to:
  /// **'How can I upload a new profile picture?'**
  String get faqUploadProfileImageQuestion;

  /// No description provided for @faqUploadProfileImageAnswer.
  ///
  /// In en, this message translates to:
  /// **'Go to User Info and tap on your current profile image. Then choose a new image and save your changes.'**
  String get faqUploadProfileImageAnswer;

  /// No description provided for @faqCantLoginQuestion.
  ///
  /// In en, this message translates to:
  /// **'Why can’t I log into my account?'**
  String get faqCantLoginQuestion;

  /// No description provided for @faqCantLoginAnswer.
  ///
  /// In en, this message translates to:
  /// **'Make sure your email and password are correct. If your email is not verified yet, complete email verification first.'**
  String get faqCantLoginAnswer;

  /// No description provided for @faqContactSupportQuestion.
  ///
  /// In en, this message translates to:
  /// **'How can I contact support?'**
  String get faqContactSupportQuestion;

  /// No description provided for @faqContactSupportAnswer.
  ///
  /// In en, this message translates to:
  /// **'You can contact our support team through the contact information shown at the bottom of this page.'**
  String get faqContactSupportAnswer;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure?'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out from your account.'**
  String get logoutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @userInfo.
  ///
  /// In en, this message translates to:
  /// **'User Info'**
  String get userInfo;

  /// No description provided for @changeYourPicture.
  ///
  /// In en, this message translates to:
  /// **'Change your picture'**
  String get changeYourPicture;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose from your files'**
  String get chooseFromFiles;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @changePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from the current password'**
  String get changePasswordHint;

  /// No description provided for @pleaseEnterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your old password'**
  String get pleaseEnterOldPassword;

  /// No description provided for @pleaseFillAllPasswordFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all password fields'**
  String get pleaseFillAllPasswordFields;

  /// No description provided for @newPasswordMustBeDifferent.
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from the current password'**
  String get newPasswordMustBeDifferent;

  /// No description provided for @pleaseChooseStrongerPassword.
  ///
  /// In en, this message translates to:
  /// **'Please choose a stronger password'**
  String get pleaseChooseStrongerPassword;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @calculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator'**
  String get calculator;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instruction'**
  String get instructions;

  /// No description provided for @suppliser.
  ///
  /// In en, this message translates to:
  /// **'Suppliser'**
  String get suppliser;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Hi, Welcome Back ! 👋'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sun Gate welcomes you'**
  String get loginWelcomeSubtitle;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmailAddress;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account ? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpTitle;

  /// No description provided for @completeAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Account'**
  String get completeAccountTitle;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your new account'**
  String get createNewAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @acceptPolicy.
  ///
  /// In en, this message translates to:
  /// **'Accept the app\'s policy and privacy'**
  String get acceptPolicy;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account ? '**
  String get alreadyHaveAccount;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registrationSuccess;

  /// No description provided for @pleaseEnterFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterFullName;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recover your account password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetEmailSent;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We have just sent you a 6 digit code via your email'**
  String get otpSubtitle;

  /// No description provided for @didNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code ? '**
  String get didNotReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in'**
  String get resendIn;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get seconds;

  /// No description provided for @continues.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continues;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'Code resent successfully'**
  String get codeResent;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create a New Password'**
  String get createNewPassword;

  /// No description provided for @enterNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPasswordSubtitle;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully'**
  String get passwordResetSuccess;

  /// No description provided for @emailMissing.
  ///
  /// In en, this message translates to:
  /// **'Email is missing. Please go back and try again.'**
  String get emailMissing;

  /// No description provided for @tokenMissing.
  ///
  /// In en, this message translates to:
  /// **'Reset code is missing. Please go back and try again.'**
  String get tokenMissing;

  /// No description provided for @homeBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Solutions For A Brighter Future'**
  String get homeBannerTitle;

  /// No description provided for @startExplore.
  ///
  /// In en, this message translates to:
  /// **'Start Explore'**
  String get startExplore;

  /// No description provided for @hiUser.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name} !'**
  String hiUser(Object name);

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @popularCompanies.
  ///
  /// In en, this message translates to:
  /// **'Popular Companies'**
  String get popularCompanies;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @defaultUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUser;

  /// No description provided for @categoryBatteries.
  ///
  /// In en, this message translates to:
  /// **'Batteries'**
  String get categoryBatteries;

  /// No description provided for @categoryInverters.
  ///
  /// In en, this message translates to:
  /// **'Inverters'**
  String get categoryInverters;

  /// No description provided for @categoryPanels.
  ///
  /// In en, this message translates to:
  /// **'Panels'**
  String get categoryPanels;

  /// No description provided for @categorySuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get categorySuppliers;

  /// No description provided for @companyLuminanceName.
  ///
  /// In en, this message translates to:
  /// **'Luminance Solar'**
  String get companyLuminanceName;

  /// No description provided for @companyLuminanceShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Expert installation of high-efficiency panels'**
  String get companyLuminanceShortDescription;

  /// No description provided for @companyLuminanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Luminance Solar specializes in modern solar panel systems for homes and small businesses with strong performance and reliable maintenance support.'**
  String get companyLuminanceDescription;

  /// No description provided for @companyLuminanceLocation.
  ///
  /// In en, this message translates to:
  /// **'Amman, Jordan'**
  String get companyLuminanceLocation;

  /// No description provided for @companyVoltGuardName.
  ///
  /// In en, this message translates to:
  /// **'VoltGuard Com'**
  String get companyVoltGuardName;

  /// No description provided for @companyVoltGuardShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Advanced battery and inverter management'**
  String get companyVoltGuardShortDescription;

  /// No description provided for @companyVoltGuardDescription.
  ///
  /// In en, this message translates to:
  /// **'VoltGuard provides advanced inverter solutions and backup battery systems suitable for residential and commercial energy needs.'**
  String get companyVoltGuardDescription;

  /// No description provided for @companyVoltGuardLocation.
  ///
  /// In en, this message translates to:
  /// **'Zarqa, Jordan'**
  String get companyVoltGuardLocation;

  /// No description provided for @companyEcoVoltName.
  ///
  /// In en, this message translates to:
  /// **'EcoVolt Solar'**
  String get companyEcoVoltName;

  /// No description provided for @companyEcoVoltShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Residential and commercial solar solutions'**
  String get companyEcoVoltShortDescription;

  /// No description provided for @companyEcoVoltDescription.
  ///
  /// In en, this message translates to:
  /// **'EcoVolt Solar focuses on complete solar energy solutions including design, supply, installation, and after-sales support.'**
  String get companyEcoVoltDescription;

  /// No description provided for @companyEcoVoltLocation.
  ///
  /// In en, this message translates to:
  /// **'Irbid, Jordan'**
  String get companyEcoVoltLocation;

  /// No description provided for @companyZenithName.
  ///
  /// In en, this message translates to:
  /// **'Zenith Power'**
  String get companyZenithName;

  /// No description provided for @companyZenithShortDescription.
  ///
  /// In en, this message translates to:
  /// **'High-performance lithium battery solutions'**
  String get companyZenithShortDescription;

  /// No description provided for @companyZenithDescription.
  ///
  /// In en, this message translates to:
  /// **'Zenith Power delivers high-capacity battery systems and smart energy storage units designed for dependable long-term use.'**
  String get companyZenithDescription;

  /// No description provided for @companyZenithLocation.
  ///
  /// In en, this message translates to:
  /// **'Aqaba, Jordan'**
  String get companyZenithLocation;

  /// No description provided for @companySunCoreName.
  ///
  /// In en, this message translates to:
  /// **'SunCore Energy'**
  String get companySunCoreName;

  /// No description provided for @companySunCoreShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Reliable solar products for modern projects'**
  String get companySunCoreShortDescription;

  /// No description provided for @companySunCoreDescription.
  ///
  /// In en, this message translates to:
  /// **'SunCore Energy serves solar projects with quality modules, trusted installation materials, and strong technical consultation.'**
  String get companySunCoreDescription;

  /// No description provided for @companySunCoreLocation.
  ///
  /// In en, this message translates to:
  /// **'Nablus, Palestine'**
  String get companySunCoreLocation;

  /// No description provided for @companyNovaGridName.
  ///
  /// In en, this message translates to:
  /// **'NovaGrid Solutions'**
  String get companyNovaGridName;

  /// No description provided for @companyNovaGridShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Smart renewable systems and supplier services'**
  String get companyNovaGridShortDescription;

  /// No description provided for @companyNovaGridDescription.
  ///
  /// In en, this message translates to:
  /// **'NovaGrid Solutions combines smart controllers, renewable products, and supply services for scalable clean-energy setups.'**
  String get companyNovaGridDescription;

  /// No description provided for @companyNovaGridLocation.
  ///
  /// In en, this message translates to:
  /// **'Ramallah, Palestine'**
  String get companyNovaGridLocation;

  /// No description provided for @productDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Detail'**
  String get productDetailTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it Works'**
  String get howItWorks;

  /// No description provided for @contactOwner.
  ///
  /// In en, this message translates to:
  /// **'Contact owner'**
  String get contactOwner;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @ownerRoleLuminanceEngineer.
  ///
  /// In en, this message translates to:
  /// **'Luminance Engineer'**
  String get ownerRoleLuminanceEngineer;

  /// No description provided for @ownerRoleSunGridManager.
  ///
  /// In en, this message translates to:
  /// **'SunGrid Manager'**
  String get ownerRoleSunGridManager;

  /// No description provided for @ownerRoleEcoVoltManager.
  ///
  /// In en, this message translates to:
  /// **'EcoVolt Manager'**
  String get ownerRoleEcoVoltManager;

  /// No description provided for @productP1Name.
  ///
  /// In en, this message translates to:
  /// **'Solar Battery Pack'**
  String get productP1Name;

  /// No description provided for @productP1Description.
  ///
  /// In en, this message translates to:
  /// **'High-capacity battery for solar systems.'**
  String get productP1Description;

  /// No description provided for @productP1How1.
  ///
  /// In en, this message translates to:
  /// **'Stores solar energy efficiently.'**
  String get productP1How1;

  /// No description provided for @productP1How2.
  ///
  /// In en, this message translates to:
  /// **'Provides backup power.'**
  String get productP1How2;

  /// No description provided for @productP1How3.
  ///
  /// In en, this message translates to:
  /// **'Optimized for long-term use.'**
  String get productP1How3;

  /// No description provided for @ownerAhmadSaleh.
  ///
  /// In en, this message translates to:
  /// **'Ahmad Saleh'**
  String get ownerAhmadSaleh;

  /// No description provided for @roleLuminanceEngineer.
  ///
  /// In en, this message translates to:
  /// **'Solar Engineer'**
  String get roleLuminanceEngineer;

  /// No description provided for @productP2Name.
  ///
  /// In en, this message translates to:
  /// **'Hybrid Inverter'**
  String get productP2Name;

  /// No description provided for @productP2Description.
  ///
  /// In en, this message translates to:
  /// **'Smart inverter for hybrid solar systems.'**
  String get productP2Description;

  /// No description provided for @productP2How1.
  ///
  /// In en, this message translates to:
  /// **'Converts DC to AC power.'**
  String get productP2How1;

  /// No description provided for @productP2How2.
  ///
  /// In en, this message translates to:
  /// **'Manages energy flow.'**
  String get productP2How2;

  /// No description provided for @productP2How3.
  ///
  /// In en, this message translates to:
  /// **'Supports battery integration.'**
  String get productP2How3;

  /// No description provided for @productP3Name.
  ///
  /// In en, this message translates to:
  /// **'Solar Panel Kit'**
  String get productP3Name;

  /// No description provided for @productP3Description.
  ///
  /// In en, this message translates to:
  /// **'Complete panel kit for homes.'**
  String get productP3Description;

  /// No description provided for @productP3How1.
  ///
  /// In en, this message translates to:
  /// **'Captures sunlight.'**
  String get productP3How1;

  /// No description provided for @productP3How2.
  ///
  /// In en, this message translates to:
  /// **'Generates electricity.'**
  String get productP3How2;

  /// No description provided for @productP3How3.
  ///
  /// In en, this message translates to:
  /// **'Works in all weather conditions.'**
  String get productP3How3;

  /// No description provided for @ownerMohamoudAli.
  ///
  /// In en, this message translates to:
  /// **'Mohamoud Ali'**
  String get ownerMohamoudAli;

  /// No description provided for @roleSunGridManager.
  ///
  /// In en, this message translates to:
  /// **'Grid Manager'**
  String get roleSunGridManager;

  /// No description provided for @productP4Name.
  ///
  /// In en, this message translates to:
  /// **'Lithium Battery Pro'**
  String get productP4Name;

  /// No description provided for @productP4Description.
  ///
  /// In en, this message translates to:
  /// **'Advanced lithium battery solution.'**
  String get productP4Description;

  /// No description provided for @productP4How1.
  ///
  /// In en, this message translates to:
  /// **'Fast charging capability.'**
  String get productP4How1;

  /// No description provided for @productP4How2.
  ///
  /// In en, this message translates to:
  /// **'Long lifespan.'**
  String get productP4How2;

  /// No description provided for @productP4How3.
  ///
  /// In en, this message translates to:
  /// **'High efficiency storage.'**
  String get productP4How3;

  /// No description provided for @productP5Name.
  ///
  /// In en, this message translates to:
  /// **'Eco Solar System'**
  String get productP5Name;

  /// No description provided for @productP5Description.
  ///
  /// In en, this message translates to:
  /// **'Eco-friendly solar solution.'**
  String get productP5Description;

  /// No description provided for @productP5How1.
  ///
  /// In en, this message translates to:
  /// **'Reduces energy costs.'**
  String get productP5How1;

  /// No description provided for @productP5How2.
  ///
  /// In en, this message translates to:
  /// **'Uses renewable resources.'**
  String get productP5How2;

  /// No description provided for @productP5How3.
  ///
  /// In en, this message translates to:
  /// **'Low maintenance system.'**
  String get productP5How3;

  /// No description provided for @ownerOmarKhaled.
  ///
  /// In en, this message translates to:
  /// **'Omar Khaled'**
  String get ownerOmarKhaled;

  /// No description provided for @roleEcoVoltManager.
  ///
  /// In en, this message translates to:
  /// **'Eco Manager'**
  String get roleEcoVoltManager;

  /// No description provided for @productP6Name.
  ///
  /// In en, this message translates to:
  /// **'Smart Energy Controller'**
  String get productP6Name;

  /// No description provided for @productP6Description.
  ///
  /// In en, this message translates to:
  /// **'Smart controller for energy systems.'**
  String get productP6Description;

  /// No description provided for @productP6How1.
  ///
  /// In en, this message translates to:
  /// **'Monitors energy usage.'**
  String get productP6How1;

  /// No description provided for @productP6How2.
  ///
  /// In en, this message translates to:
  /// **'Optimizes performance.'**
  String get productP6How2;

  /// No description provided for @productP6How3.
  ///
  /// In en, this message translates to:
  /// **'Improves efficiency.'**
  String get productP6How3;

  /// No description provided for @productP7Name.
  ///
  /// In en, this message translates to:
  /// **'Zenith Battery Unit'**
  String get productP7Name;

  /// No description provided for @productP7Description.
  ///
  /// In en, this message translates to:
  /// **'Premium battery storage unit.'**
  String get productP7Description;

  /// No description provided for @productP7How1.
  ///
  /// In en, this message translates to:
  /// **'Stores excess energy.'**
  String get productP7How1;

  /// No description provided for @productP7How2.
  ///
  /// In en, this message translates to:
  /// **'Ensures stable supply.'**
  String get productP7How2;

  /// No description provided for @productP7How3.
  ///
  /// In en, this message translates to:
  /// **'Supports smart grids.'**
  String get productP7How3;

  /// No description provided for @ownerSaraNabil.
  ///
  /// In en, this message translates to:
  /// **'Sara Nabil'**
  String get ownerSaraNabil;

  /// No description provided for @roleZenithSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Energy Specialist'**
  String get roleZenithSpecialist;

  /// No description provided for @productP8Name.
  ///
  /// In en, this message translates to:
  /// **'Solar Charging Station'**
  String get productP8Name;

  /// No description provided for @productP8Description.
  ///
  /// In en, this message translates to:
  /// **'Portable solar charging system.'**
  String get productP8Description;

  /// No description provided for @productP8How1.
  ///
  /// In en, this message translates to:
  /// **'Charges devices using sunlight.'**
  String get productP8How1;

  /// No description provided for @productP8How2.
  ///
  /// In en, this message translates to:
  /// **'Compact design.'**
  String get productP8How2;

  /// No description provided for @productP8How3.
  ///
  /// In en, this message translates to:
  /// **'Easy to install.'**
  String get productP8How3;

  /// No description provided for @productP9Name.
  ///
  /// In en, this message translates to:
  /// **'SunCore Panel System'**
  String get productP9Name;

  /// No description provided for @productP9Description.
  ///
  /// In en, this message translates to:
  /// **'High-efficiency solar panels.'**
  String get productP9Description;

  /// No description provided for @productP9How1.
  ///
  /// In en, this message translates to:
  /// **'Absorbs maximum sunlight.'**
  String get productP9How1;

  /// No description provided for @productP9How2.
  ///
  /// In en, this message translates to:
  /// **'Generates clean energy.'**
  String get productP9How2;

  /// No description provided for @productP9How3.
  ///
  /// In en, this message translates to:
  /// **'Durable and reliable.'**
  String get productP9How3;

  /// No description provided for @ownerAliHasan.
  ///
  /// In en, this message translates to:
  /// **'Ali Hasan'**
  String get ownerAliHasan;

  /// No description provided for @roleSunCoreSupervisor.
  ///
  /// In en, this message translates to:
  /// **'Supervisor'**
  String get roleSunCoreSupervisor;

  /// No description provided for @productP10Name.
  ///
  /// In en, this message translates to:
  /// **'Grid Tie Inverter'**
  String get productP10Name;

  /// No description provided for @productP10Description.
  ///
  /// In en, this message translates to:
  /// **'Connects solar system to grid.'**
  String get productP10Description;

  /// No description provided for @productP10How1.
  ///
  /// In en, this message translates to:
  /// **'Syncs with grid power.'**
  String get productP10How1;

  /// No description provided for @productP10How2.
  ///
  /// In en, this message translates to:
  /// **'Exports excess energy.'**
  String get productP10How2;

  /// No description provided for @productP10How3.
  ///
  /// In en, this message translates to:
  /// **'Improves efficiency.'**
  String get productP10How3;

  /// No description provided for @productP11Name.
  ///
  /// In en, this message translates to:
  /// **'Nova Smart Controller'**
  String get productP11Name;

  /// No description provided for @productP11Description.
  ///
  /// In en, this message translates to:
  /// **'Advanced smart controller.'**
  String get productP11Description;

  /// No description provided for @productP11How1.
  ///
  /// In en, this message translates to:
  /// **'Automates energy control.'**
  String get productP11How1;

  /// No description provided for @productP11How2.
  ///
  /// In en, this message translates to:
  /// **'Tracks consumption.'**
  String get productP11How2;

  /// No description provided for @productP11How3.
  ///
  /// In en, this message translates to:
  /// **'Enhances performance.'**
  String get productP11How3;

  /// No description provided for @ownerRamiAdel.
  ///
  /// In en, this message translates to:
  /// **'Rami Adel'**
  String get ownerRamiAdel;

  /// No description provided for @roleNovaGridEngineer.
  ///
  /// In en, this message translates to:
  /// **'Electrical Engineer'**
  String get roleNovaGridEngineer;

  /// No description provided for @productP12Name.
  ///
  /// In en, this message translates to:
  /// **'Portable Solar Kit'**
  String get productP12Name;

  /// No description provided for @productP12Description.
  ///
  /// In en, this message translates to:
  /// **'Lightweight solar kit.'**
  String get productP12Description;

  /// No description provided for @productP12How1.
  ///
  /// In en, this message translates to:
  /// **'Easy to carry.'**
  String get productP12How1;

  /// No description provided for @productP12How2.
  ///
  /// In en, this message translates to:
  /// **'Quick installation.'**
  String get productP12How2;

  /// No description provided for @productP12How3.
  ///
  /// In en, this message translates to:
  /// **'Perfect for outdoor use.'**
  String get productP12How3;

  /// No description provided for @selectAccountTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account as'**
  String get selectAccountTypeTitle;

  /// No description provided for @selectAccountTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the account type that fits your needs.'**
  String get selectAccountTypeSubtitle;

  /// No description provided for @userAccount.
  ///
  /// In en, this message translates to:
  /// **'User Account'**
  String get userAccount;

  /// No description provided for @userAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register as a normal Sun Gate user.'**
  String get userAccountSubtitle;

  /// No description provided for @companyAccount.
  ///
  /// In en, this message translates to:
  /// **'Company Account'**
  String get companyAccount;

  /// No description provided for @companyAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register your company and upload verification details.'**
  String get companyAccountSubtitle;

  /// No description provided for @companySignUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Company Account'**
  String get companySignUpTitle;

  /// No description provided for @companySignUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the company registration form.'**
  String get companySignUpSubtitle;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @enterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Enter company name'**
  String get enterCompanyName;

  /// No description provided for @establishmentDate.
  ///
  /// In en, this message translates to:
  /// **'Establishment Date'**
  String get establishmentDate;

  /// No description provided for @enterEstablishmentDate.
  ///
  /// In en, this message translates to:
  /// **'Enter establishment date'**
  String get enterEstablishmentDate;

  /// No description provided for @documentUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload verification document'**
  String get documentUploadLabel;

  /// No description provided for @logoUploadLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload company logo'**
  String get logoUploadLabel;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get chooseFile;

  /// No description provided for @signUpAsUser.
  ///
  /// In en, this message translates to:
  /// **'Sign up as a user instead'**
  String get signUpAsUser;

  /// No description provided for @pleaseEnterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the company name'**
  String get pleaseEnterCompanyName;

  /// No description provided for @enableGpsMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable GPS to get your location.'**
  String get enableGpsMessage;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Please grant location permission to use this feature.'**
  String get locationPermissionMessage;

  /// No description provided for @companyDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} Detail'**
  String companyDetailTitle(Object name);

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'({count} reviews)'**
  String reviewsCount(Object count);

  /// No description provided for @listItems.
  ///
  /// In en, this message translates to:
  /// **'List Items'**
  String get listItems;

  /// No description provided for @noProductsForCompany.
  ///
  /// In en, this message translates to:
  /// **'No products available for this company yet.'**
  String get noProductsForCompany;

  /// No description provided for @market.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get market;

  /// No description provided for @searchInMarket.
  ///
  /// In en, this message translates to:
  /// **'Search in our market app'**
  String get searchInMarket;

  /// No description provided for @itemsYouCanBuy.
  ///
  /// In en, this message translates to:
  /// **'Items you can buy'**
  String get itemsYouCanBuy;

  /// No description provided for @marketDescription.
  ///
  /// In en, this message translates to:
  /// **'Browse the available products in our market and explore suitable solar solutions, batteries, inverters, and related energy items.'**
  String get marketDescription;

  /// No description provided for @listItem.
  ///
  /// In en, this message translates to:
  /// **'List Items'**
  String get listItem;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @suppliersList.
  ///
  /// In en, this message translates to:
  /// **'Suppliers List'**
  String get suppliersList;

  /// No description provided for @suppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliers;

  /// No description provided for @noProductsForCategory.
  ///
  /// In en, this message translates to:
  /// **'No products available for this category.'**
  String get noProductsForCategory;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter First Name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter Last Name'**
  String get enterLastName;

  /// No description provided for @pleaseEnterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please Enter First Name'**
  String get pleaseEnterFirstName;

  /// No description provided for @pleaseEnterLastName.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Last Name'**
  String get pleaseEnterLastName;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @enterBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Select your birth date'**
  String get enterBirthDate;

  /// No description provided for @enterLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter your location'**
  String get enterLocation;

  /// No description provided for @solarCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Solar Calculator'**
  String get solarCalculatorTitle;

  /// No description provided for @solarCalculatorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate system size, storage, wiring, and investment values from one place.'**
  String get solarCalculatorSubtitle;

  /// No description provided for @calculatorInvalidInputs.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid positive values.'**
  String get calculatorInvalidInputs;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @deviceConsumptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Device consumption'**
  String get deviceConsumptionTitle;

  /// No description provided for @deviceConsumptionMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calculate daily energy usage from device power and operating hours.'**
  String get deviceConsumptionMenuSubtitle;

  /// No description provided for @numberOfPanelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Number of panels'**
  String get numberOfPanelsTitle;

  /// No description provided for @numberOfPanelsMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate the required solar panel count.'**
  String get numberOfPanelsMenuSubtitle;

  /// No description provided for @batteryCapacityTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery capacity'**
  String get batteryCapacityTitle;

  /// No description provided for @batteryCapacityMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Size the battery bank for daily storage.'**
  String get batteryCapacityMenuSubtitle;

  /// No description provided for @batteryCapacityAdvancedTitle.
  ///
  /// In en, this message translates to:
  /// **'Battery capacity - Advanced'**
  String get batteryCapacityAdvancedTitle;

  /// No description provided for @batteryCapacityAdvancedMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Include autonomy days, discharge depth, efficiency, and temperature.'**
  String get batteryCapacityAdvancedMenuSubtitle;

  /// No description provided for @inverterCapacityTitle.
  ///
  /// In en, this message translates to:
  /// **'Inverter Capacity'**
  String get inverterCapacityTitle;

  /// No description provided for @inverterCapacityMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate inverter power, VA rating, and DC input current.'**
  String get inverterCapacityMenuSubtitle;

  /// No description provided for @wireCrossSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Wire cross-section'**
  String get wireCrossSectionTitle;

  /// No description provided for @wireCrossSectionMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose cable size from load, voltage, and distance.'**
  String get wireCrossSectionMenuSubtitle;

  /// No description provided for @chargeControllerTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Charge Controller'**
  String get chargeControllerTitle;

  /// No description provided for @chargeControllerMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate controller current for panel strings.'**
  String get chargeControllerMenuSubtitle;

  /// No description provided for @tiltOfPanelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tilt of the panels'**
  String get tiltOfPanelsTitle;

  /// No description provided for @tiltOfPanelsMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the recommended solar panel tilt angle.'**
  String get tiltOfPanelsMenuSubtitle;

  /// No description provided for @systemEfficiencyTitle.
  ///
  /// In en, this message translates to:
  /// **'System efficiency'**
  String get systemEfficiencyTitle;

  /// No description provided for @systemEfficiencyMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compare theoretical and actual production.'**
  String get systemEfficiencyMenuSubtitle;

  /// No description provided for @returnOnInvestmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Return on investment'**
  String get returnOnInvestmentTitle;

  /// No description provided for @returnOnInvestmentMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate payback period from cost, output, and energy price.'**
  String get returnOnInvestmentMenuSubtitle;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @deviceHint.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get deviceHint;

  /// No description provided for @power.
  ///
  /// In en, this message translates to:
  /// **'Power'**
  String get power;

  /// No description provided for @powerWattsHint.
  ///
  /// In en, this message translates to:
  /// **'Power in watts'**
  String get powerWattsHint;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @hoursHint.
  ///
  /// In en, this message translates to:
  /// **'Hours per day'**
  String get hoursHint;

  /// No description provided for @addNewDevice.
  ///
  /// In en, this message translates to:
  /// **'Add a new device'**
  String get addNewDevice;

  /// No description provided for @totalDailyConsumption.
  ///
  /// In en, this message translates to:
  /// **'Total daily consumption'**
  String get totalDailyConsumption;

  /// No description provided for @nextNumberOfPanels.
  ///
  /// In en, this message translates to:
  /// **'Next: Number of panels'**
  String get nextNumberOfPanels;

  /// No description provided for @systemTypeOffGrid.
  ///
  /// In en, this message translates to:
  /// **'System type: Isolated (Off-Grid)'**
  String get systemTypeOffGrid;

  /// No description provided for @systemTypeOnGrid.
  ///
  /// In en, this message translates to:
  /// **'System type: Grid connected'**
  String get systemTypeOnGrid;

  /// No description provided for @dailyConsumptionWhHint.
  ///
  /// In en, this message translates to:
  /// **'Total daily consumption'**
  String get dailyConsumptionWhHint;

  /// No description provided for @singlePanelPower.
  ///
  /// In en, this message translates to:
  /// **'Power of a single solar panel'**
  String get singlePanelPower;

  /// No description provided for @panelPowerWattsHint.
  ///
  /// In en, this message translates to:
  /// **'Panel power'**
  String get panelPowerWattsHint;

  /// No description provided for @peakSunHours.
  ///
  /// In en, this message translates to:
  /// **'Peak hours of the sun'**
  String get peakSunHours;

  /// No description provided for @peakSunHoursHint.
  ///
  /// In en, this message translates to:
  /// **'Peak sun hours'**
  String get peakSunHoursHint;

  /// No description provided for @systemEfficiency.
  ///
  /// In en, this message translates to:
  /// **'System efficiency'**
  String get systemEfficiency;

  /// No description provided for @numberOfPanelsRequired.
  ///
  /// In en, this message translates to:
  /// **'Number of panels required'**
  String get numberOfPanelsRequired;

  /// No description provided for @nextBatteryCapacity.
  ///
  /// In en, this message translates to:
  /// **'Next: Battery capacity'**
  String get nextBatteryCapacity;

  /// No description provided for @safetyMarginReserveFactor.
  ///
  /// In en, this message translates to:
  /// **'Safety margin / Reserve factor'**
  String get safetyMarginReserveFactor;

  /// No description provided for @safetyMarginReserveFactorHint.
  ///
  /// In en, this message translates to:
  /// **'Extra reserve percentage'**
  String get safetyMarginReserveFactorHint;

  /// No description provided for @panelDeratingFactor.
  ///
  /// In en, this message translates to:
  /// **'Panel derating factor'**
  String get panelDeratingFactor;

  /// No description provided for @panelDeratingFactorHint.
  ///
  /// In en, this message translates to:
  /// **'Heat, dust, shade, orientation factor'**
  String get panelDeratingFactorHint;

  /// No description provided for @batteryChargeLosses.
  ///
  /// In en, this message translates to:
  /// **'Battery / charge losses'**
  String get batteryChargeLosses;

  /// No description provided for @batteryChargeLossesHint.
  ///
  /// In en, this message translates to:
  /// **'Charging and storage loss percentage'**
  String get batteryChargeLossesHint;

  /// No description provided for @availableRoofArea.
  ///
  /// In en, this message translates to:
  /// **'Available roof area'**
  String get availableRoofArea;

  /// No description provided for @availableRoofAreaHint.
  ///
  /// In en, this message translates to:
  /// **'Available installation area'**
  String get availableRoofAreaHint;

  /// No description provided for @panelArea.
  ///
  /// In en, this message translates to:
  /// **'Panel area'**
  String get panelArea;

  /// No description provided for @panelAreaHint.
  ///
  /// In en, this message translates to:
  /// **'Area of one panel'**
  String get panelAreaHint;

  /// No description provided for @panelVoltage.
  ///
  /// In en, this message translates to:
  /// **'Panel voltage'**
  String get panelVoltage;

  /// No description provided for @panelVoltageHint.
  ///
  /// In en, this message translates to:
  /// **'Voltage of one panel'**
  String get panelVoltageHint;

  /// No description provided for @panelCurrent.
  ///
  /// In en, this message translates to:
  /// **'Panel current'**
  String get panelCurrent;

  /// No description provided for @panelCurrentHint.
  ///
  /// In en, this message translates to:
  /// **'Current of one panel'**
  String get panelCurrentHint;

  /// No description provided for @cityOrSiteName.
  ///
  /// In en, this message translates to:
  /// **'City or site name'**
  String get cityOrSiteName;

  /// No description provided for @monthSeason.
  ///
  /// In en, this message translates to:
  /// **'Month / season'**
  String get monthSeason;

  /// No description provided for @annualAverage.
  ///
  /// In en, this message translates to:
  /// **'Annual average'**
  String get annualAverage;

  /// No description provided for @summerHighSun.
  ///
  /// In en, this message translates to:
  /// **'Summer / high sun'**
  String get summerHighSun;

  /// No description provided for @springAutumn.
  ///
  /// In en, this message translates to:
  /// **'Spring or autumn'**
  String get springAutumn;

  /// No description provided for @winterLowSun.
  ///
  /// In en, this message translates to:
  /// **'Winter / low sun'**
  String get winterLowSun;

  /// No description provided for @effectiveSunHours.
  ///
  /// In en, this message translates to:
  /// **'Effective sun hours'**
  String get effectiveSunHours;

  /// No description provided for @roofArea.
  ///
  /// In en, this message translates to:
  /// **'Roof area'**
  String get roofArea;

  /// No description provided for @requiredLabel.
  ///
  /// In en, this message translates to:
  /// **'required'**
  String get requiredLabel;

  /// No description provided for @fitsAvailableRoofArea.
  ///
  /// In en, this message translates to:
  /// **'fits the available roof area'**
  String get fitsAvailableRoofArea;

  /// No description provided for @exceedsAvailableRoofArea.
  ///
  /// In en, this message translates to:
  /// **'exceeds the available roof area'**
  String get exceedsAvailableRoofArea;

  /// No description provided for @panelVoltageCurrentCheck.
  ///
  /// In en, this message translates to:
  /// **'Panel V x A check'**
  String get panelVoltageCurrentCheck;

  /// No description provided for @locationNote.
  ///
  /// In en, this message translates to:
  /// **'Location note'**
  String get locationNote;

  /// No description provided for @systemVoltage.
  ///
  /// In en, this message translates to:
  /// **'System voltage'**
  String get systemVoltage;

  /// No description provided for @systemVoltageHint.
  ///
  /// In en, this message translates to:
  /// **'System voltage'**
  String get systemVoltageHint;

  /// No description provided for @inverterEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Inverter efficiency'**
  String get inverterEfficiency;

  /// No description provided for @inverterEfficiencyHint.
  ///
  /// In en, this message translates to:
  /// **'Inverter efficiency'**
  String get inverterEfficiencyHint;

  /// No description provided for @minimumExpectedTemperature.
  ///
  /// In en, this message translates to:
  /// **'Minimum expected temperature'**
  String get minimumExpectedTemperature;

  /// No description provided for @minimumTemperatureHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum temperature'**
  String get minimumTemperatureHint;

  /// No description provided for @requiredBatteryCapacity.
  ///
  /// In en, this message translates to:
  /// **'Required battery capacity'**
  String get requiredBatteryCapacity;

  /// No description provided for @nextTiltOfPanels.
  ///
  /// In en, this message translates to:
  /// **'Next: Tilt of panels'**
  String get nextTiltOfPanels;

  /// No description provided for @daysOfAutonomy.
  ///
  /// In en, this message translates to:
  /// **'Days of autonomy'**
  String get daysOfAutonomy;

  /// No description provided for @daysOfAutonomyHint.
  ///
  /// In en, this message translates to:
  /// **'Days of autonomy'**
  String get daysOfAutonomyHint;

  /// No description provided for @depthOfDischarge.
  ///
  /// In en, this message translates to:
  /// **'Depth of discharge (DOD)'**
  String get depthOfDischarge;

  /// No description provided for @depthOfDischargeHint.
  ///
  /// In en, this message translates to:
  /// **'Depth of discharge'**
  String get depthOfDischargeHint;

  /// No description provided for @latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get latitude;

  /// No description provided for @latitudeHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 31.6'**
  String get latitudeHint;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose date'**
  String get chooseDate;

  /// No description provided for @selectedDateTilt.
  ///
  /// In en, this message translates to:
  /// **'Selected date tilt'**
  String get selectedDateTilt;

  /// No description provided for @optimalTiltAngle.
  ///
  /// In en, this message translates to:
  /// **'Optimal tilt angle throughout the year'**
  String get optimalTiltAngle;

  /// No description provided for @annualTilt.
  ///
  /// In en, this message translates to:
  /// **'Annual tilt'**
  String get annualTilt;

  /// No description provided for @summerTilt.
  ///
  /// In en, this message translates to:
  /// **'Summer tilt'**
  String get summerTilt;

  /// No description provided for @winterTilt.
  ///
  /// In en, this message translates to:
  /// **'Winter tilt'**
  String get winterTilt;

  /// No description provided for @nextSystemEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Next: System efficiency'**
  String get nextSystemEfficiency;

  /// No description provided for @theoreticalProduction.
  ///
  /// In en, this message translates to:
  /// **'Theoretical production'**
  String get theoreticalProduction;

  /// No description provided for @theoreticalProductionHint.
  ///
  /// In en, this message translates to:
  /// **'Theoretical production'**
  String get theoreticalProductionHint;

  /// No description provided for @actualProduction.
  ///
  /// In en, this message translates to:
  /// **'Actual production'**
  String get actualProduction;

  /// No description provided for @actualProductionHint.
  ///
  /// In en, this message translates to:
  /// **'Actual production'**
  String get actualProductionHint;

  /// No description provided for @nextReturnOnInvestment.
  ///
  /// In en, this message translates to:
  /// **'Next: Return on investment'**
  String get nextReturnOnInvestment;

  /// No description provided for @totalSystemCost.
  ///
  /// In en, this message translates to:
  /// **'Total system cost'**
  String get totalSystemCost;

  /// No description provided for @totalSystemCostHint.
  ///
  /// In en, this message translates to:
  /// **'Total system cost'**
  String get totalSystemCostHint;

  /// No description provided for @expectedDailyOutput.
  ///
  /// In en, this message translates to:
  /// **'Expected daily output'**
  String get expectedDailyOutput;

  /// No description provided for @expectedDailyOutputHint.
  ///
  /// In en, this message translates to:
  /// **'Expected daily output'**
  String get expectedDailyOutputHint;

  /// No description provided for @pricePerKilowattHour.
  ///
  /// In en, this message translates to:
  /// **'Price per kilowatt-hour'**
  String get pricePerKilowattHour;

  /// No description provided for @pricePerKilowattHourHint.
  ///
  /// In en, this message translates to:
  /// **'Price per kilowatt-hour'**
  String get pricePerKilowattHourHint;

  /// No description provided for @estimatedPaybackPeriod.
  ///
  /// In en, this message translates to:
  /// **'Estimated payback period'**
  String get estimatedPaybackPeriod;

  /// No description provided for @viewFinalSummary.
  ///
  /// In en, this message translates to:
  /// **'View final summary'**
  String get viewFinalSummary;

  /// No description provided for @totalContinuousPowerDevices.
  ///
  /// In en, this message translates to:
  /// **'Total continuous power of devices'**
  String get totalContinuousPowerDevices;

  /// No description provided for @totalContinuousPowerHint.
  ///
  /// In en, this message translates to:
  /// **'Watts'**
  String get totalContinuousPowerHint;

  /// No description provided for @maximumInstantaneousStart.
  ///
  /// In en, this message translates to:
  /// **'Maximum expected instantaneous start'**
  String get maximumInstantaneousStart;

  /// No description provided for @maximumInstantaneousStartHint.
  ///
  /// In en, this message translates to:
  /// **'Watts'**
  String get maximumInstantaneousStartHint;

  /// No description provided for @powerFactor.
  ///
  /// In en, this message translates to:
  /// **'Power factor'**
  String get powerFactor;

  /// No description provided for @powerFactorHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 0.8'**
  String get powerFactorHint;

  /// No description provided for @dcInputVoltage.
  ///
  /// In en, this message translates to:
  /// **'System voltage (DC input voltage)'**
  String get dcInputVoltage;

  /// No description provided for @dcInputVoltageHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 12'**
  String get dcInputVoltageHint;

  /// No description provided for @inverterSafetyFactor.
  ///
  /// In en, this message translates to:
  /// **'Inverter safety factor'**
  String get inverterSafetyFactor;

  /// No description provided for @requiredContinuousPower.
  ///
  /// In en, this message translates to:
  /// **'Required continuous power'**
  String get requiredContinuousPower;

  /// No description provided for @dcCurrent.
  ///
  /// In en, this message translates to:
  /// **'DC current'**
  String get dcCurrent;

  /// No description provided for @totalLoadPower.
  ///
  /// In en, this message translates to:
  /// **'Total load power'**
  String get totalLoadPower;

  /// No description provided for @totalLoadPowerHint.
  ///
  /// In en, this message translates to:
  /// **'Total load power'**
  String get totalLoadPowerHint;

  /// No description provided for @distanceFromSourceLoad.
  ///
  /// In en, this message translates to:
  /// **'Distance from source/load'**
  String get distanceFromSourceLoad;

  /// No description provided for @distanceFromSourceLoadHint.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distanceFromSourceLoadHint;

  /// No description provided for @requiredCableSection.
  ///
  /// In en, this message translates to:
  /// **'Required cable section'**
  String get requiredCableSection;

  /// No description provided for @recommendedBreaker.
  ///
  /// In en, this message translates to:
  /// **'Recommended breaker'**
  String get recommendedBreaker;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @chargeControllerType.
  ///
  /// In en, this message translates to:
  /// **'Charge controller type'**
  String get chargeControllerType;

  /// No description provided for @batterySystemVoltage.
  ///
  /// In en, this message translates to:
  /// **'Battery system voltage'**
  String get batterySystemVoltage;

  /// No description provided for @batterySystemVoltageHint.
  ///
  /// In en, this message translates to:
  /// **'Battery voltage'**
  String get batterySystemVoltageHint;

  /// No description provided for @shortCircuitCurrentPerPanel.
  ///
  /// In en, this message translates to:
  /// **'Short-circuit current per panel'**
  String get shortCircuitCurrentPerPanel;

  /// No description provided for @shortCircuitCurrentHint.
  ///
  /// In en, this message translates to:
  /// **'Short-circuit current'**
  String get shortCircuitCurrentHint;

  /// No description provided for @panelsInParallel.
  ///
  /// In en, this message translates to:
  /// **'Panels in parallel'**
  String get panelsInParallel;

  /// No description provided for @panelsInParallelHint.
  ///
  /// In en, this message translates to:
  /// **'Number of panels in parallel'**
  String get panelsInParallelHint;

  /// No description provided for @requiredControllerCurrent.
  ///
  /// In en, this message translates to:
  /// **'Required controller current'**
  String get requiredControllerCurrent;

  /// No description provided for @supportedArrayPower.
  ///
  /// In en, this message translates to:
  /// **'Supported array power'**
  String get supportedArrayPower;

  /// No description provided for @calculationSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculation Summary'**
  String get calculationSummaryTitle;

  /// No description provided for @systemOverview.
  ///
  /// In en, this message translates to:
  /// **'System overview'**
  String get systemOverview;

  /// No description provided for @systemOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A compact summary of the main calculated solar system values.'**
  String get systemOverviewSubtitle;

  /// No description provided for @quickRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Quick recommendation'**
  String get quickRecommendation;

  /// No description provided for @summaryRecommendationPrefix.
  ///
  /// In en, this message translates to:
  /// **'The estimated system needs around'**
  String get summaryRecommendationPrefix;

  /// No description provided for @summaryEfficiencyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Estimated efficiency is'**
  String get summaryEfficiencyPrefix;

  /// No description provided for @summaryRoiPrefix.
  ///
  /// In en, this message translates to:
  /// **'Expected payback period is'**
  String get summaryRoiPrefix;

  /// No description provided for @efficiencyGauge.
  ///
  /// In en, this message translates to:
  /// **'Efficiency gauge'**
  String get efficiencyGauge;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @needsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs improvement'**
  String get needsImprovement;

  /// No description provided for @systemComparisonChart.
  ///
  /// In en, this message translates to:
  /// **'System comparison chart'**
  String get systemComparisonChart;

  /// No description provided for @systemComparisonChartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A visual comparison between the main calculated values.'**
  String get systemComparisonChartSubtitle;

  /// No description provided for @use.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get use;

  /// No description provided for @panels.
  ///
  /// In en, this message translates to:
  /// **'Panels'**
  String get panels;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @tilt.
  ///
  /// In en, this message translates to:
  /// **'Tilt'**
  String get tilt;

  /// No description provided for @wh.
  ///
  /// In en, this message translates to:
  /// **'Wh'**
  String get wh;

  /// No description provided for @wattHour.
  ///
  /// In en, this message translates to:
  /// **'watt-hour'**
  String get wattHour;

  /// No description provided for @watt.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get watt;

  /// No description provided for @volt.
  ///
  /// In en, this message translates to:
  /// **'V'**
  String get volt;

  /// No description provided for @voltAmpere.
  ///
  /// In en, this message translates to:
  /// **'VA'**
  String get voltAmpere;

  /// No description provided for @ampere.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get ampere;

  /// No description provided for @ampereHour.
  ///
  /// In en, this message translates to:
  /// **'Ah'**
  String get ampereHour;

  /// No description provided for @meter.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get meter;

  /// No description provided for @squareMillimeter.
  ///
  /// In en, this message translates to:
  /// **'mm²'**
  String get squareMillimeter;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get celsius;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'°'**
  String get degree;

  /// No description provided for @panel.
  ///
  /// In en, this message translates to:
  /// **'panel'**
  String get panel;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountPermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete Account Permanently'**
  String get deleteAccountPermanently;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Your account and all your data will be permanently deleted.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountPostsWarning.
  ///
  /// In en, this message translates to:
  /// **'Delete Account Post Warning'**
  String get deleteAccountPostsWarning;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @dangerZoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone Description'**
  String get dangerZoneDescription;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
