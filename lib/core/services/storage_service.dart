import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../models/user.dart';

/// Secure Storage Service for managing sensitive and non-sensitive data
/// 
/// This service provides:
/// - Secure storage for sensitive data (tokens, credentials)
/// - Regular storage for app preferences and cache
/// - User session management
/// - Data encryption/decryption
class StorageService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage;
  final Logger _logger = Logger();

  StorageService({
    required SharedPreferences prefs,
    required FlutterSecureStorage secureStorage,
  }) : _prefs = prefs, _secureStorage = secureStorage;

  // Keys for secure storage
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';
  static const String _biometricKey = 'biometric_enabled';
  static const String _pinKey = 'user_pin';

  // Keys for regular storage
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';
  static const String _onboardingKey = 'onboarding_completed';
  static const String _firstLaunchKey = 'first_launch';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const String _lastSyncKey = 'last_sync';

  // Authentication Token Management
  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _tokenKey, value: token);
      _logger.d('Auth token saved successfully');
    } catch (e) {
      _logger.e('Failed to save auth token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      _logger.e('Failed to get auth token: $e');
      return null;
    }
  }

  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
      _logger.d('Auth token cleared');
    } catch (e) {
      _logger.e('Failed to clear auth token: $e');
    }
  }

  // Refresh Token Management
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      _logger.d('Refresh token saved successfully');
    } catch (e) {
      _logger.e('Failed to save refresh token: $e');
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      _logger.e('Failed to get refresh token: $e');
      return null;
    }
  }

  // User Data Management
  Future<void> saveUser(User user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _secureStorage.write(key: _userKey, value: userJson);
      _logger.d('User data saved successfully');
    } catch (e) {
      _logger.e('Failed to save user data: $e');
    }
  }

  Future<User?> getUser() async {
    try {
      final userJson = await _secureStorage.read(key: _userKey);
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
      return null;
    } catch (e) {
      _logger.e('Failed to get user data: $e');
      return null;
    }
  }

  Future<void> clearUser() async {
    try {
      await _secureStorage.delete(key: _userKey);
      _logger.d('User data cleared');
    } catch (e) {
      _logger.e('Failed to clear user data: $e');
    }
  }

  // Theme Management
  Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(_themeKey, isDark);
  }

  bool getThemeMode() {
    return _prefs.getBool(_themeKey) ?? false;
  }

  // Language Management
  Future<void> saveLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }

  String getLanguage() {
    return _prefs.getString(_languageKey) ?? 'fr';
  }

  // Onboarding Management
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_onboardingKey, completed);
  }

  bool isOnboardingCompleted() {
    return _prefs.getBool(_onboardingKey) ?? false;
  }

  // First Launch Management
  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    await _prefs.setBool(_firstLaunchKey, isFirstLaunch);
  }

  bool isFirstLaunch() {
    return _prefs.getBool(_firstLaunchKey) ?? true;
  }

  // Cache Management
  Future<void> setCacheTimestamp(DateTime timestamp) async {
    await _prefs.setInt(_cacheTimestampKey, timestamp.millisecondsSinceEpoch);
  }

  DateTime? getCacheTimestamp() {
    final timestamp = _prefs.getInt(_cacheTimestampKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  // Last Sync Management
  Future<void> setLastSync(DateTime timestamp) async {
    await _prefs.setInt(_lastSyncKey, timestamp.millisecondsSinceEpoch);
  }

  DateTime? getLastSync() {
    final timestamp = _prefs.getInt(_lastSyncKey);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  // Biometric Authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(key: _biometricKey, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _secureStorage.read(key: _biometricKey);
      return value == 'true';
    } catch (e) {
      return false;
    }
  }

  // PIN Management
  Future<void> savePIN(String pin) async {
    try {
      await _secureStorage.write(key: _pinKey, value: pin);
    } catch (e) {
      _logger.e('Failed to save PIN: $e');
    }
  }

  Future<String?> getPIN() async {
    try {
      return await _secureStorage.read(key: _pinKey);
    } catch (e) {
      _logger.e('Failed to get PIN: $e');
      return null;
    }
  }

  Future<void> clearPIN() async {
    try {
      await _secureStorage.delete(key: _pinKey);
    } catch (e) {
      _logger.e('Failed to clear PIN: $e');
    }
  }

  // Generic Secure Storage Methods
  Future<void> setSecureValue(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      _logger.e('Failed to set secure value for key $key: $e');
    }
  }

  Future<String?> getSecureValue(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      _logger.e('Failed to get secure value for key $key: $e');
      return null;
    }
  }

  Future<void> removeSecureValue(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      _logger.e('Failed to remove secure value for key $key: $e');
    }
  }

  // Generic Regular Storage Methods
  Future<void> setValue(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  T? getValue<T>(String key) {
    return _prefs.get(key) as T?;
  }

  Future<void> removeValue(String key) async {
    await _prefs.remove(key);
  }

  // Clear all data (for logout)
  Future<void> clearAllData() async {
    try {
      await _secureStorage.deleteAll();
      await _prefs.clear();
      _logger.d('All storage data cleared');
    } catch (e) {
      _logger.e('Failed to clear all data: $e');
    }
  }

  // Clear only secure data
  Future<void> clearSecureData() async {
    try {
      await _secureStorage.deleteAll();
      _logger.d('Secure storage data cleared');
    } catch (e) {
      _logger.e('Failed to clear secure data: $e');
    }
  }

  // Check if data exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  Future<bool> containsSecureKey(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      return false;
    }
  }

  // Get all keys
  Set<String> getAllKeys() {
    return _prefs.getKeys();
  }

  Future<Set<String>> getAllSecureKeys() async {
    try {
      return await _secureStorage.readAll().then((map) => map.keys.toSet());
    } catch (e) {
      return <String>{};
    }
  }
}
