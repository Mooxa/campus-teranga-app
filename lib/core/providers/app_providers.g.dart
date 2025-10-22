// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'7cd30c9640ca952d1bcf1772c709fc45dc47c8b3';

/// Shared Preferences Provider
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeFutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = AutoDisposeFutureProviderRef<SharedPreferences>;
String _$secureStorageHash() => r'0a150805d095fa29fccebb6a2af261f0cb7e8e76';

/// Secure Storage Provider
///
/// Copied from [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider =
    AutoDisposeProvider<FlutterSecureStorage>.internal(
  secureStorage,
  name: r'secureStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageRef = AutoDisposeProviderRef<FlutterSecureStorage>;
String _$connectivityServiceHash() =>
    r'2514faa3d7f3227d473e300af7d0188339855ef3';

/// Connectivity Service Provider
///
/// Copied from [connectivityService].
@ProviderFor(connectivityService)
final connectivityServiceProvider =
    AutoDisposeProvider<ConnectivityService>.internal(
  connectivityService,
  name: r'connectivityServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ConnectivityServiceRef = AutoDisposeProviderRef<ConnectivityService>;
String _$storageServiceHash() => r'c16ffbaabb7a511435f7c1635ce090831c18a61e';

/// Storage Service Provider
///
/// Copied from [storageService].
@ProviderFor(storageService)
final storageServiceProvider =
    AutoDisposeFutureProvider<StorageService>.internal(
  storageService,
  name: r'storageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageServiceRef = AutoDisposeFutureProviderRef<StorageService>;
String _$apiServiceHash() => r'0e208292796791069e643c6202dd4e274e9a4202';

/// API Service Provider
///
/// Copied from [apiService].
@ProviderFor(apiService)
final apiServiceProvider = AutoDisposeFutureProvider<ApiService>.internal(
  apiService,
  name: r'apiServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$apiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiServiceRef = AutoDisposeFutureProviderRef<ApiService>;
String _$authServiceHash() => r'5891c8cdffe685ce59454e5213b4faa86e8b6b83';

/// Auth Service Provider
///
/// Copied from [authService].
@ProviderFor(authService)
final authServiceProvider = AutoDisposeFutureProvider<AuthService>.internal(
  authService,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthServiceRef = AutoDisposeFutureProviderRef<AuthService>;
String _$currentUserHash() => r'8cdd62bafc41520a6d50813bb7c3ad958028b6d7';

/// Current User Provider
///
/// Copied from [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider =
    AutoDisposeNotifierProvider<CurrentUser, User?>.internal(
  CurrentUser.new,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUser = AutoDisposeNotifier<User?>;
String _$authStateHash() => r'2a8da312b784dd69731f4f670e05ce741f5b9651';

/// Authentication State Provider
///
/// Copied from [AuthState].
@ProviderFor(AuthState)
final authStateProvider = AutoDisposeNotifierProvider<AuthState, bool>.internal(
  AuthState.new,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthState = AutoDisposeNotifier<bool>;
String _$connectivityStateHash() => r'd3df4274ea16add4cdfc22b9bde661688f88cebc';

/// Connectivity State Provider
///
/// Copied from [ConnectivityState].
@ProviderFor(ConnectivityState)
final connectivityStateProvider =
    AutoDisposeNotifierProvider<ConnectivityState, bool>.internal(
  ConnectivityState.new,
  name: r'connectivityStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectivityState = AutoDisposeNotifier<bool>;
String _$appThemeModeHash() => r'e277a3afddde904df9020c860fc7eb2327398c7d';

/// App Theme Provider
///
/// Copied from [AppThemeMode].
@ProviderFor(AppThemeMode)
final appThemeModeProvider =
    AutoDisposeNotifierProvider<AppThemeMode, bool>.internal(
  AppThemeMode.new,
  name: r'appThemeModeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appThemeModeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppThemeMode = AutoDisposeNotifier<bool>;
String _$loadingStateHash() => r'7756dc38244f37078ca70af076b56dd51083bbc0';

/// Loading State Provider
///
/// Copied from [LoadingState].
@ProviderFor(LoadingState)
final loadingStateProvider =
    AutoDisposeNotifierProvider<LoadingState, bool>.internal(
  LoadingState.new,
  name: r'loadingStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loadingStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoadingState = AutoDisposeNotifier<bool>;
String _$errorStateHash() => r'4b5104843c23bb3de4d863b8b74c82e228f3fb99';

/// Error State Provider
///
/// Copied from [ErrorState].
@ProviderFor(ErrorState)
final errorStateProvider =
    AutoDisposeNotifierProvider<ErrorState, String?>.internal(
  ErrorState.new,
  name: r'errorStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$errorStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ErrorState = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
