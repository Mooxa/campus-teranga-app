import 'dart:io';
import 'app_config.dart';

class BuildConfig {
  static bool get isProduction => AppConfig.environment == 'production';
  static bool get isDevelopment => AppConfig.environment == 'development';
  
  // Platform detection
  static bool get isAndroid => Platform.isAndroid;
  static bool get isIOS => Platform.isIOS;
  static bool get isWeb => Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  
  // Build type detection
  static bool get isDebug => isDevelopment;
  static bool get isRelease => isProduction;
  
  // API Configuration based on build type
  static String get apiBaseUrl {
    if (isProduction) {
      return 'https://campus-teranga-backend.onrender.com/api';
    } else {
      return 'http://127.0.0.1:3000/api';
    }
  }
  
  // Logging configuration
  static bool get enableLogging => isDevelopment;
  static bool get enableNetworkLogging => isDevelopment;
  static bool get enableHttpLogging => isDevelopment;
  
  // Feature flags based on build type
  static bool get enableAnalytics => isProduction;
  static bool get enableCrashReporting => isProduction;
  static bool get enablePushNotifications => isProduction;
  
  // Security settings
  static bool get enableCertificatePinning => isProduction;
  static bool get enableHttpsOnly => isProduction;
  
  // Performance settings
  static bool get enablePerformanceMonitoring => isProduction;
  static bool get enableMemoryProfiling => isDevelopment;
  
  // Debug settings
  static bool get showDebugBanner => isDevelopment;
  static bool get enableHotReload => isDevelopment;
  
  // App version info
  static String get appName => 'Campus Téranga';
  static String get appVersion => '1.0.0';
  static String get buildNumber => '1';
  
  // Environment info
  static String get environment => AppConfig.environment;
  static String get buildType => isProduction ? 'Release' : 'Debug';
  static String get platform => Platform.operatingSystem;
}
