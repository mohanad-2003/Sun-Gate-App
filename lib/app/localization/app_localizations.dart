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
