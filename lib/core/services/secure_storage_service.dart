import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

/// Secure Storage Service
/// 
/// This service handles secure storage of sensitive data like tokens
/// and user credentials using flutter_secure_storage.

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
      synchronizable: false,
    ),
  );

  /// Store authentication token securely
  Future<void> storeToken(String token) async {
    try {
      await _storage.write(key: AppConstants.tokenKey, value: token);
    } catch (e) {
      throw CacheException(
        message: 'Failed to store authentication token',
        code: 'TOKEN_STORE_FAILED',
        details: e,
      );
    }
  }

  /// Retrieve authentication token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: AppConstants.tokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve authentication token',
        code: 'TOKEN_RETRIEVE_FAILED',
        details: e,
      );
    }
  }

  /// Clear authentication token
  Future<void> clearToken() async {
    try {
      await _storage.delete(key: AppConstants.tokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear authentication token',
        code: 'TOKEN_CLEAR_FAILED',
        details: e,
      );
    }
  }

  /// Store user data securely
  Future<void> storeUserData(Map<String, dynamic> userData) async {
    try {
      final jsonString = jsonEncode(userData);
      await _storage.write(key: AppConstants.userKey, value: jsonString);
    } catch (e) {
      throw CacheException(
        message: 'Failed to store user data',
        code: 'USER_DATA_STORE_FAILED',
        details: e,
      );
    }
  }

  /// Retrieve user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final jsonString = await _storage.read(key: AppConstants.userKey);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve user data',
        code: 'USER_DATA_RETRIEVE_FAILED',
        details: e,
      );
    }
  }

  /// Clear user data
  Future<void> clearUserData() async {
    try {
      await _storage.delete(key: AppConstants.userKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear user data',
        code: 'USER_DATA_CLEAR_FAILED',
        details: e,
      );
    }
  }

  /// Store theme preference
  Future<void> storeThemeMode(bool isDarkMode) async {
    try {
      await _storage.write(
        key: AppConstants.themeKey,
        value: isDarkMode.toString(),
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to store theme preference',
        code: 'THEME_STORE_FAILED',
        details: e,
      );
    }
  }

  /// Retrieve theme preference
  Future<bool?> getThemeMode() async {
    try {
      final themeString = await _storage.read(key: AppConstants.themeKey);
      if (themeString == null) return null;
      return themeString.toLowerCase() == 'true';
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve theme preference',
        code: 'THEME_RETRIEVE_FAILED',
        details: e,
      );
    }
  }

  /// Store language preference
  Future<void> storeLanguage(String languageCode) async {
    try {
      await _storage.write(key: AppConstants.languageKey, value: languageCode);
    } catch (e) {
      throw CacheException(
        message: 'Failed to store language preference',
        code: 'LANGUAGE_STORE_FAILED',
        details: e,
      );
    }
  }

  /// Retrieve language preference
  Future<String?> getLanguage() async {
    try {
      return await _storage.read(key: AppConstants.languageKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve language preference',
        code: 'LANGUAGE_RETRIEVE_FAILED',
        details: e,
      );
    }
  }

  /// Store any secure data
  Future<void> storeSecureData(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to store secure data',
        code: 'SECURE_DATA_STORE_FAILED',
        details: e,
      );
    }
  }

  /// Retrieve any secure data
  Future<String?> getSecureData(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to retrieve secure data',
        code: 'SECURE_DATA_RETRIEVE_FAILED',
        details: e,
      );
    }
  }

  /// Clear any secure data
  Future<void> clearSecureData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear secure data',
        code: 'SECURE_DATA_CLEAR_FAILED',
        details: e,
      );
    }
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear all stored data',
        code: 'CLEAR_ALL_FAILED',
        details: e,
      );
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
