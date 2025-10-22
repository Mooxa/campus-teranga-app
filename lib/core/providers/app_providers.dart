import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

part 'app_providers.g.dart';

/// Shared Preferences Provider
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}

/// Secure Storage Provider
@riverpod
FlutterSecureStorage secureStorage(SecureStorageRef ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
}

/// Connectivity Service Provider
@riverpod
ConnectivityService connectivityService(ConnectivityServiceRef ref) {
  return ConnectivityService();
}

/// Storage Service Provider
@riverpod
StorageService storageService(StorageServiceRef ref) {
  return StorageService(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
}

/// API Service Provider
@riverpod
ApiService apiService(ApiServiceRef ref) {
  return ApiService(
    storageService: ref.watch(storageServiceProvider),
  );
}

/// Auth Service Provider
@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService(
    apiService: ref.watch(apiServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
}

/// Current User Provider
@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  User? build() {
    // Load user from storage on app start
    _loadUser();
    return null;
  }

  Future<void> _loadUser() async {
    final authService = ref.read(authServiceProvider);
    final user = await authService.getCurrentUser();
    if (user != null) {
      state = user;
    }
  }

  Future<void> setUser(User? user) async {
    state = user;
  }

  Future<void> clearUser() async {
    state = null;
  }
}

/// Authentication State Provider
@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() {
    // Initialize with false, will be updated by auth service
    return false;
  }

  Future<void> login(String phoneNumber, String password) async {
    final authService = ref.read(authServiceProvider);
    final user = await authService.login(phoneNumber, password);
    if (user != null) {
      ref.read(currentUserProvider.notifier).setUser(user);
      state = true;
    }
  }

  Future<void> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  }) async {
    final authService = ref.read(authServiceProvider);
    final user = await authService.register(
      fullName: fullName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );
    if (user != null) {
      ref.read(currentUserProvider.notifier).setUser(user);
      state = true;
    }
  }

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    ref.read(currentUserProvider.notifier).clearUser();
    state = false;
  }

  Future<void> checkAuthStatus() async {
    final authService = ref.read(authServiceProvider);
    final isAuthenticated = await authService.isAuthenticated();
    state = isAuthenticated;
  }
}

/// Connectivity State Provider
@riverpod
class ConnectivityState extends _$ConnectivityState {
  @override
  bool build() {
    final connectivityService = ref.watch(connectivityServiceProvider);
    return connectivityService.isConnected;
  }

  void updateConnectionStatus(bool isConnected) {
    state = isConnected;
  }
}

/// App Theme Provider
@riverpod
class AppTheme extends _$AppTheme {
  @override
  bool build() {
    // Default to light theme
    return false; // false = light theme, true = dark theme
  }

  void toggleTheme() {
    state = !state;
  }

  void setTheme(bool isDark) {
    state = isDark;
  }
}

/// Loading State Provider
@riverpod
class LoadingState extends _$LoadingState {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

/// Error State Provider
@riverpod
class ErrorState extends _$ErrorState {
  @override
  String? build() {
    return null;
  }

  void setError(String? error) {
    state = error;
  }

  void clearError() {
    state = null;
  }
}
