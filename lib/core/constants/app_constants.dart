/// Application Constants
/// 
/// This file contains all application-wide constants including:
/// - API endpoints
/// - App metadata
/// - Validation rules
/// - UI constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // App Metadata
  static const String appName = 'Campus Téranga';
  static const String appVersion = '2.0.0';
  static const String appBuildNumber = '1';
  static const String appPackageName = 'com.campusteranga.app';

  // API Configuration
  static const String productionApiUrl = 'https://campus-teranga-backend.onrender.com/api';
  static const String stagingApiUrl = 'https://campus-teranga-backend-staging.onrender.com/api';
  static const String developmentApiUrl = 'http://192.168.1.2:3000/api';

  // API Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPhoneLength = 9;
  static const int maxPhoneLength = 15;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 16.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Supported Languages
  static const List<String> supportedLanguages = ['en', 'fr'];
  static const String defaultLanguage = 'fr';

  // Supported Countries
  static const List<String> supportedCountries = ['SN', 'ML', 'CI', 'BF', 'NE'];
  static const String defaultCountry = 'SN';

  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred.';
  static const String timeoutErrorMessage = 'Request timeout. Please try again.';
}
