import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// App Localizations
/// 
/// This class provides localization support for the Flutter application
/// with support for English and French languages.

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('fr', ''),
  ];

  static AppLocalizations? ofNullable(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // App Title
  String get appTitle => _getLocalizedString('appTitle', 'Campus Téranga');

  // Welcome
  String get welcome => _getLocalizedString('welcome', 'Welcome');

  // Authentication
  String get login => _getLocalizedString('login', 'Login');
  String get register => _getLocalizedString('register', 'Register');
  String get email => _getLocalizedString('email', 'Email');
  String get password => _getLocalizedString('password', 'Password');
  String get confirmPassword => _getLocalizedString('confirmPassword', 'Confirm Password');
  String get fullName => _getLocalizedString('fullName', 'Full Name');
  String get phoneNumber => _getLocalizedString('phoneNumber', 'Phone Number');
  String get forgotPassword => _getLocalizedString('forgotPassword', 'Forgot Password?');
  String get dontHaveAccount => _getLocalizedString('dontHaveAccount', "Don't have an account?");
  String get alreadyHaveAccount => _getLocalizedString('alreadyHaveAccount', 'Already have an account?');
  String get signUp => _getLocalizedString('signUp', 'Sign Up');
  String get signIn => _getLocalizedString('signIn', 'Sign In');

  // Status Messages
  String get loading => _getLocalizedString('loading', 'Loading...');
  String get error => _getLocalizedString('error', 'Error');
  String get success => _getLocalizedString('success', 'Success');

  // Error Messages
  String get networkError => _getLocalizedString('networkError', 'Network error. Please check your internet connection.');
  String get serverError => _getLocalizedString('serverError', 'Server error. Please try again later.');
  String get unknownError => _getLocalizedString('unknownError', 'An unknown error occurred.');
  String get validationError => _getLocalizedString('validationError', 'Validation error');

  // Validation Messages
  String get emailRequired => _getLocalizedString('emailRequired', 'Email is required');
  String get emailInvalid => _getLocalizedString('emailInvalid', 'Please enter a valid email address');
  String get passwordRequired => _getLocalizedString('passwordRequired', 'Password is required');
  String get passwordTooShort => _getLocalizedString('passwordTooShort', 'Password must be at least 8 characters long');
  String get passwordMismatch => _getLocalizedString('passwordMismatch', 'Passwords do not match');
  String get nameRequired => _getLocalizedString('nameRequired', 'Full name is required');
  String get phoneRequired => _getLocalizedString('phoneRequired', 'Phone number is required');
  String get phoneInvalid => _getLocalizedString('phoneInvalid', 'Please enter a valid phone number');

  // Success Messages
  String get loginSuccess => _getLocalizedString('loginSuccess', 'Login successful');
  String get registerSuccess => _getLocalizedString('registerSuccess', 'Registration successful');
  String get logoutSuccess => _getLocalizedString('logoutSuccess', 'Logout successful');

  // Navigation
  String get home => _getLocalizedString('home', 'Home');
  String get events => _getLocalizedString('events', 'Events');
  String get formations => _getLocalizedString('formations', 'Formations');
  String get services => _getLocalizedString('services', 'Services');
  String get profile => _getLocalizedString('profile', 'Profile');

  // Settings
  String get settings => _getLocalizedString('settings', 'Settings');
  String get language => _getLocalizedString('language', 'Language');
  String get theme => _getLocalizedString('theme', 'Theme');
  String get lightTheme => _getLocalizedString('lightTheme', 'Light');
  String get darkTheme => _getLocalizedString('darkTheme', 'Dark');
  String get systemTheme => _getLocalizedString('systemTheme', 'System');

  // About
  String get about => _getLocalizedString('about', 'About');
  String get version => _getLocalizedString('version', 'Version');
  String get termsOfService => _getLocalizedString('termsOfService', 'Terms of Service');
  String get privacyPolicy => _getLocalizedString('privacyPolicy', 'Privacy Policy');
  String get contactUs => _getLocalizedString('contactUs', 'Contact Us');

  // Actions
  String get logout => _getLocalizedString('logout', 'Logout');
  String get cancel => _getLocalizedString('cancel', 'Cancel');
  String get ok => _getLocalizedString('ok', 'OK');
  String get yes => _getLocalizedString('yes', 'Yes');
  String get no => _getLocalizedString('no', 'No');
  String get retry => _getLocalizedString('retry', 'Retry');
  String get save => _getLocalizedString('save', 'Save');
  String get edit => _getLocalizedString('edit', 'Edit');
  String get delete => _getLocalizedString('delete', 'Delete');
  String get search => _getLocalizedString('search', 'Search');

  // Results
  String get noResults => _getLocalizedString('noResults', 'No results found');
  String get tryAgain => _getLocalizedString('tryAgain', 'Try again');

  /// Get localized string with fallback
  String _getLocalizedString(String key, String fallback) {
    switch (locale.languageCode) {
      case 'en':
        return AppLocalizationsEn().getString(key) ?? fallback;
      case 'fr':
        return AppLocalizationsFr().getString(key) ?? fallback;
      default:
        return fallback;
    }
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
