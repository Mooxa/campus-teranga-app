class AppConfig {
  // API Configuration
  static const String productionApiUrl = 'https://campus-teranga-backend.onrender.com/api';
  static const String developmentApiUrl = 'http://127.0.0.1:3000/api';
  
  // Current environment - set to 'production' for production builds
  static const String environment = 'production';
  
  // Get the appropriate API URL based on environment
  static String get apiUrl {
    switch (environment) {
      case 'production':
        return productionApiUrl;
      case 'development':
        return developmentApiUrl;
      default:
        return productionApiUrl;
    }
  }
  
  // App Information
  static const String appName = 'Campus Téranga';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Votre guide complet pour réussir vos études au Sénégal';
  
  // API Configuration
  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;
  
  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePushNotifications = true;
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 4.0;
  
  // Animation Configuration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  
  // Network Configuration
  static const bool enableNetworkLogging = false; // Set to false for production
  static const bool enableHttpLogging = false; // Set to false for production
  
  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // Security Configuration
  static const bool enableCertificatePinning = true;
  static const bool enableHttpsOnly = true;
}
