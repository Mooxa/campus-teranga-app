import '../../../../core/errors/failures.dart';
import '../entities/auth_result_entity.dart';
import '../entities/user_entity.dart';

/// Authentication Repository Interface
/// 
/// This abstract class defines the contract for authentication operations
/// following clean architecture principles.

abstract class AuthRepository {
  /// Register a new user
  Future<({Failure? failure, AuthResultEntity? result})> register({
    required String fullName,
    required String phoneNumber,
    required String password,
    String? email,
  });

  /// Login an existing user
  Future<({Failure? failure, AuthResultEntity? result})> login({
    required String phoneNumber,
    required String password,
  });

  /// Logout the current user
  Future<({Failure? failure, bool? success})> logout();

  /// Get current user information
  Future<({Failure? failure, UserEntity? user})> getCurrentUser();

  /// Check if user is authenticated
  Future<({Failure? failure, bool? isAuthenticated})> isAuthenticated();

  /// Refresh authentication token
  Future<({Failure? failure, String? token})> refreshToken();

  /// Update user profile
  Future<({Failure? failure, UserEntity? user})> updateProfile({
    required String userId,
    String? fullName,
    String? email,
  });

  /// Change user password
  Future<({Failure? failure, bool? success})> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  /// Request password reset
  Future<({Failure? failure, bool? success})> requestPasswordReset({
    required String phoneNumber,
  });

  /// Verify password reset code
  Future<({Failure? failure, bool? success})> verifyPasswordResetCode({
    required String phoneNumber,
    required String code,
  });

  /// Reset password with code
  Future<({Failure? failure, bool? success})> resetPassword({
    required String phoneNumber,
    required String code,
    required String newPassword,
  });
}
