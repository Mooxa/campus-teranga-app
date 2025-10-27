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
Future<StorageService> storageService(StorageServiceRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return StorageService(
    prefs: prefs,
    secureStorage: ref.watch(secureStorageProvider),
  );
}

/// API Service Provider
@riverpod
Future<ApiService> apiService(ApiServiceRef ref) async {
  final storageService = await ref.watch(storageServiceProvider.future);
  return ApiService(storageService: storageService);
}

/// Auth Service Provider
@riverpod
Future<AuthService> authService(AuthServiceRef ref) async {
  final apiService = await ref.watch(apiServiceProvider.future);
  final storageService = await ref.watch(storageServiceProvider.future);
  return AuthService(
    apiService: apiService,
    storageService: storageService,
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
    final authServiceAsync = ref.read(authServiceProvider);
    authServiceAsync.when(
      data: (authService) async {
        final user = await authService.getCurrentUser();
        if (user != null) {
          state = user;
        }
      },
      loading: () {},
      error: (error, stack) {},
    );
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
    final authServiceAsync = ref.read(authServiceProvider);
    authServiceAsync.when(
      data: (authService) async {
        final user = await authService.login(phoneNumber, password);
        if (user != null) {
          ref.read(currentUserProvider.notifier).setUser(user);
          state = true;
        }
      },
      loading: () {},
      error: (error, stack) {},
    );
  }

  Future<void> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
    required String confirmPassword,
  }) async {
    print('🔗 [AUTH_STATE] Register method called');
    print('📝 [AUTH_STATE] Registration data:');
    print('   - Full Name: $fullName');
    print('   - Phone: $phoneNumber');
    print('   - Email: ${email ?? "Not provided"}');
    print('   - Password: ${password.length} characters');
    print('   - Confirm Password: ${confirmPassword.length} characters');
    
    final authServiceAsync = ref.read(authServiceProvider);
    print('🔍 [AUTH_STATE] Auth service state: ${authServiceAsync.runtimeType}');
    
    authServiceAsync.when(
      data: (authService) async {
        print('✅ [AUTH_STATE] Auth service available, calling register...');
        try {
          final user = await authService.register(
            fullName: fullName,
            phoneNumber: phoneNumber,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
          );
          print('📥 [AUTH_STATE] Register response received');
          print('👤 [AUTH_STATE] User data: ${user?.toString() ?? "null"}');
          
          if (user != null) {
            print('✅ [AUTH_STATE] User created successfully, updating state...');
            ref.read(currentUserProvider.notifier).setUser(user);
            state = true;
            print('🎉 [AUTH_STATE] Registration completed successfully');
          } else {
            print('❌ [AUTH_STATE] User is null - registration failed');
          }
        } catch (e) {
          print('💥 [AUTH_STATE] Error in auth service register: $e');
          print('📊 [AUTH_STATE] Error type: ${e.runtimeType}');
          rethrow;
        }
      },
      loading: () {
        print('⏳ [AUTH_STATE] Auth service is loading...');
      },
      error: (error, stack) {
        print('❌ [AUTH_STATE] Auth service error: $error');
        print('📊 [AUTH_STATE] Error stack: $stack');
      },
    );
  }

  Future<void> logout() async {
    final authServiceAsync = ref.read(authServiceProvider);
    authServiceAsync.when(
      data: (authService) async {
        await authService.logout();
        ref.read(currentUserProvider.notifier).clearUser();
        state = false;
      },
      loading: () {},
      error: (error, stack) {},
    );
  }

  Future<void> checkAuthStatus() async {
    final authServiceAsync = ref.read(authServiceProvider);
    authServiceAsync.when(
      data: (authService) async {
        final isAuthenticated = await authService.isAuthenticated();
        state = isAuthenticated;
      },
      loading: () {},
      error: (error, stack) {},
    );
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
class AppThemeMode extends _$AppThemeMode {
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
