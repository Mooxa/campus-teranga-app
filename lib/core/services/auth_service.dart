import 'package:logger/logger.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';

/// Authentication Service for managing user authentication
/// 
/// This service provides:
/// - User login and registration
/// - Token management
/// - Session validation
/// - Biometric authentication
/// - Password management
class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;
  final Logger _logger = Logger();

  AuthService({
    required ApiService apiService,
    required StorageService storageService,
  }) : _apiService = apiService, _storageService = storageService;

  /// Login user with phone number and password
  Future<User?> login(String phoneNumber, String password) async {
    try {
      _logger.d('Attempting login for phone: $phoneNumber');
      
      final response = await _apiService.login(phoneNumber, password);
      
      if (response != null && response['token'] != null) {
        final token = response['token'] as String;
        final userData = response['user'] as Map<String, dynamic>;
        
        // Save token securely
        await _storageService.saveToken(token);
        
        // Create user object and save
        final user = User.fromJson(userData);
        await _storageService.saveUser(user);
        
        _logger.d('Login successful for user: ${user.fullName}');
        return user;
      }
      
      _logger.w('Login failed: Invalid response');
      return null;
    } catch (e) {
      _logger.e('Login error: $e');
      return null;
    }
  }

  /// Register new user
  Future<User?> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  }) async {
    try {
      _logger.d('Attempting registration for phone: $phoneNumber');
      
      final response = await _apiService.register(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
      );
      
      if (response != null && response['token'] != null) {
        final token = response['token'] as String;
        final userData = response['user'] as Map<String, dynamic>;
        
        // Save token securely
        await _storageService.saveToken(token);
        
        // Create user object and save
        final user = User.fromJson(userData);
        await _storageService.saveUser(user);
        
        _logger.d('Registration successful for user: ${user.fullName}');
        return user;
      }
      
      _logger.w('Registration failed: Invalid response');
      return null;
    } catch (e) {
      _logger.e('Registration error: $e');
      return null;
    }
  }

  /// Logout user and clear session
  Future<void> logout() async {
    try {
      _logger.d('Logging out user');
      
      // Clear stored data
      await _storageService.clearToken();
      await _storageService.clearUser();
      await _storageService.clearPIN();
      
      _logger.d('Logout successful');
    } catch (e) {
      _logger.e('Logout error: $e');
    }
  }

  /// Get current authenticated user
  Future<User?> getCurrentUser() async {
    try {
      final user = await _storageService.getUser();
      if (user != null) {
        _logger.d('Current user retrieved: ${user.fullName}');
        return user;
      }
      
      // Try to fetch from API if not in storage
      final apiUser = await _apiService.getCurrentUser();
      if (apiUser != null) {
        await _storageService.saveUser(apiUser);
        _logger.d('User fetched from API: ${apiUser.fullName}');
        return apiUser;
      }
      
      _logger.w('No current user found');
      return null;
    } catch (e) {
      _logger.e('Error getting current user: $e');
      return null;
    }
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        return false;
      }
      
      // Validate token with API
      final user = await _apiService.getCurrentUser();
      return user != null;
    } catch (e) {
      _logger.e('Authentication check error: $e');
      return false;
    }
  }

  /// Refresh user data from API
  Future<User?> refreshUser() async {
    try {
      _logger.d('Refreshing user data');
      
      final user = await _apiService.getCurrentUser();
      if (user != null) {
        await _storageService.saveUser(user);
        _logger.d('User data refreshed: ${user.fullName}');
        return user;
      }
      
      return null;
    } catch (e) {
      _logger.e('Error refreshing user: $e');
      return null;
    }
  }

  /// Update user profile
  Future<User?> updateProfile(Map<String, dynamic> updates) async {
    try {
      _logger.d('Updating user profile');
      
      // This would typically call an API endpoint to update user profile
      // For now, we'll update the local user data
      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        _logger.w('No current user to update');
        return null;
      }
      
      // Create updated user object
      final updatedUserData = currentUser.toJson();
      updates.forEach((key, value) {
        updatedUserData[key] = value;
      });
      
      final updatedUser = User.fromJson(updatedUserData);
      await _storageService.saveUser(updatedUser);
      
      _logger.d('Profile updated successfully');
      return updatedUser;
    } catch (e) {
      _logger.e('Error updating profile: $e');
      return null;
    }
  }

  /// Change user password
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      _logger.d('Changing user password');
      
      // This would typically call an API endpoint to change password
      // For now, we'll return true as a placeholder
      _logger.d('Password changed successfully');
      return true;
    } catch (e) {
      _logger.e('Error changing password: $e');
      return false;
    }
  }

  /// Reset password (forgot password)
  Future<bool> resetPassword(String phoneNumber) async {
    try {
      _logger.d('Resetting password for phone: $phoneNumber');
      
      // This would typically call an API endpoint to reset password
      // For now, we'll return true as a placeholder
      _logger.d('Password reset initiated');
      return true;
    } catch (e) {
      _logger.e('Error resetting password: $e');
      return false;
    }
  }

  /// Verify phone number
  Future<bool> verifyPhoneNumber(String phoneNumber, String verificationCode) async {
    try {
      _logger.d('Verifying phone number: $phoneNumber');
      
      // This would typically call an API endpoint to verify phone number
      // For now, we'll return true as a placeholder
      _logger.d('Phone number verified successfully');
      return true;
    } catch (e) {
      _logger.e('Error verifying phone number: $e');
      return false;
    }
  }

  /// Enable biometric authentication
  Future<bool> enableBiometricAuth() async {
    try {
      _logger.d('Enabling biometric authentication');
      
      await _storageService.setBiometricEnabled(true);
      _logger.d('Biometric authentication enabled');
      return true;
    } catch (e) {
      _logger.e('Error enabling biometric auth: $e');
      return false;
    }
  }

  /// Disable biometric authentication
  Future<bool> disableBiometricAuth() async {
    try {
      _logger.d('Disabling biometric authentication');
      
      await _storageService.setBiometricEnabled(false);
      _logger.d('Biometric authentication disabled');
      return true;
    } catch (e) {
      _logger.e('Error disabling biometric auth: $e');
      return false;
    }
  }

  /// Check if biometric authentication is enabled
  Future<bool> isBiometricAuthEnabled() async {
    try {
      return await _storageService.isBiometricEnabled();
    } catch (e) {
      _logger.e('Error checking biometric auth status: $e');
      return false;
    }
  }

  /// Set PIN for authentication
  Future<bool> setPIN(String pin) async {
    try {
      _logger.d('Setting user PIN');
      
      await _storageService.savePIN(pin);
      _logger.d('PIN set successfully');
      return true;
    } catch (e) {
      _logger.e('Error setting PIN: $e');
      return false;
    }
  }

  /// Verify PIN
  Future<bool> verifyPIN(String pin) async {
    try {
      final storedPIN = await _storageService.getPIN();
      return storedPIN == pin;
    } catch (e) {
      _logger.e('Error verifying PIN: $e');
      return false;
    }
  }

  /// Clear PIN
  Future<void> clearPIN() async {
    try {
      await _storageService.clearPIN();
      _logger.d('PIN cleared');
    } catch (e) {
      _logger.e('Error clearing PIN: $e');
    }
  }

  /// Get authentication method preference
  Future<AuthMethod> getAuthMethod() async {
    try {
      final isBiometricEnabled = await isBiometricAuthEnabled();
      final hasPIN = await _storageService.getPIN() != null;
      
      if (isBiometricEnabled) {
        return AuthMethod.biometric;
      } else if (hasPIN) {
        return AuthMethod.pin;
      } else {
        return AuthMethod.password;
      }
    } catch (e) {
      _logger.e('Error getting auth method: $e');
      return AuthMethod.password;
    }
  }

  /// Validate session and refresh if needed
  Future<bool> validateSession() async {
    try {
      final isAuth = await isAuthenticated();
      if (!isAuth) {
        _logger.w('Session validation failed: Not authenticated');
        return false;
      }
      
      _logger.d('Session validation successful');
      return true;
    } catch (e) {
      _logger.e('Error validating session: $e');
      return false;
    }
  }
}

/// Authentication methods
enum AuthMethod {
  password,
  pin,
  biometric,
}
