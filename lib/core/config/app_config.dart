/// App Configuration - Centralized configuration management
/// 
/// This file contains all app-wide configuration settings including:
/// - Environment settings (development, staging, production)
/// - API endpoints
/// - Feature flags
/// - App metadata
/// - Performance settings
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // Environment Configuration
  static const String environment = String.fromEnvironment(
    'FLUTTER_APP_ENV', 
    defaultValue: 'production', // Changed to production for deployed backend
  );

  // App Metadata
  static const String appName = 'Campus Téranga';
  static const String appVersion = '2.0.0';
  static const String appBuildNumber = '1';
  static const String appPackageName = 'com.campusteranga.app';
  
  // API Configuration
  static const String productionApiUrl = 'https://campus-teranga-backend.onrender.com/api';
  static const String stagingApiUrl = 'https://campus-teranga-backend-staging.onrender.com/api';
  static const String developmentApiUrl = 'http://127.0.0.1:3000/api';
  
  /// Get the appropriate API URL based on environment
  static String get apiUrl {
    switch (environment) {
      case 'production':
        return productionApiUrl;
      case 'staging':
        return stagingApiUrl;
      case 'development':
        return developmentApiUrl;
      default:
        return developmentApiUrl;
    }
  }

  // Performance Settings
  static const int apiTimeoutSeconds = 30;
  static const int imageCacheMaxAge = 7; // days
  static const int maxRetryAttempts = 3;
  static const int debounceMilliseconds = 300;

  // Feature Flags
  static const bool enableLogging = environment != 'production';
  static const bool enableHttpLogging = environment == 'development';
  static const bool enableAnalytics = environment == 'production';
  static const bool enableCrashReporting = environment == 'production';
  static const bool enablePerformanceMonitoring = environment == 'production';
  
  // UI Configuration
  static const bool enableAnimations = true;
  static const bool enableHapticFeedback = true;
  static const bool enableSoundEffects = true;
  
  // Security Settings
  static const bool enableCertificatePinning = environment == 'production';
  static const bool enableBiometricAuth = true;
  static const bool enablePINAuth = true;
  
  // Offline Settings
  static const bool enableOfflineMode = true;
  static const int offlineDataRetentionDays = 30;
  
  // Localization
  static const String defaultLocale = 'fr_SN';
  static const List<String> supportedLocales = ['fr_SN', 'en_US'];
  
  // Theme Configuration
  static const bool enableDarkMode = true;
  static const bool enableSystemTheme = true;
  
  // Development Tools
  static const bool enableDeveloperMenu = environment != 'production';
  static const bool enableDebugOverlay = environment == 'development';
  
  // Validation
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  
  // App Store Configuration
  static const String appStoreId = '1234567890'; // Replace with actual ID
  static const String playStoreId = 'com.campusteranga.app';
  
  // Social Media Links
  static const String websiteUrl = 'https://campusteranga.com';
  static const String facebookUrl = 'https://facebook.com/campusteranga';
  static const String twitterUrl = 'https://twitter.com/campusteranga';
  static const String instagramUrl = 'https://instagram.com/campusteranga';
  
  // Support Information
  static const String supportEmail = 'support@campusteranga.com';
  static const String privacyPolicyUrl = 'https://campusteranga.com/privacy';
  static const String termsOfServiceUrl = 'https://campusteranga.com/terms';
  
  // Analytics Configuration
  static const String firebaseProjectId = 'campus-teranga-app';
  static const String mixpanelToken = ''; // Add if using Mixpanel
  
  // Push Notifications
  static const bool enablePushNotifications = true;
  static const String fcmSenderId = '123456789012'; // Replace with actual sender ID
  
  // Deep Linking
  static const String deepLinkScheme = 'campusteranga';
  static const String universalLinkDomain = 'campusteranga.com';
  
  /// Get configuration value by key
  static T getValue<T>(String key, T defaultValue) {
    // This could be extended to read from remote config
    switch (key) {
      case 'api_timeout':
        return apiTimeoutSeconds as T;
      case 'enable_logging':
        return enableLogging as T;
      case 'enable_analytics':
        return enableAnalytics as T;
      default:
        return defaultValue;
    }
  }
  
  /// Validate configuration on app startup
  static bool validateConfig() {
    try {
      // Validate required URLs
      if (apiUrl.isEmpty) {
        throw Exception('API URL is not configured');
      }
      
      // Validate app metadata
      if (appName.isEmpty || appVersion.isEmpty) {
        throw Exception('App metadata is incomplete');
      }
      
      return true;
    } catch (e) {
      print('Configuration validation failed: $e');
      return false;
    }
  }
  
  /// Get environment-specific configuration
  static Map<String, dynamic> getEnvironmentConfig() {
    return {
      'environment': environment,
      'apiUrl': apiUrl,
      'enableLogging': enableLogging,
      'enableAnalytics': enableAnalytics,
      'appVersion': appVersion,
    };
  }
}
