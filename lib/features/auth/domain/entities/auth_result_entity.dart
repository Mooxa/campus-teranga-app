import 'user_entity.dart';

/// Authentication Result Entity
/// 
/// This class represents the result of authentication operations
/// including user data and authentication token.

class AuthResultEntity {
  final UserEntity user;
  final String token;
  final bool success;
  final String message;

  const AuthResultEntity({
    required this.user,
    required this.token,
    required this.success,
    required this.message,
  });

  /// Create a copy of this entity with updated fields
  AuthResultEntity copyWith({
    UserEntity? user,
    String? token,
    bool? success,
    String? message,
  }) {
    return AuthResultEntity(
      user: user ?? this.user,
      token: token ?? this.token,
      success: success ?? this.success,
      message: message ?? this.message,
    );
  }

  /// Convert entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'success': success,
      'message': message,
    };
  }

  /// Create entity from JSON
  factory AuthResultEntity.fromJson(Map<String, dynamic> json) {
    return AuthResultEntity(
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResultEntity &&
        other.user == user &&
        other.token == token &&
        other.success == success &&
        other.message == message;
  }

  @override
  int get hashCode {
    return user.hashCode ^
        token.hashCode ^
        success.hashCode ^
        message.hashCode;
  }

  @override
  String toString() {
    return 'AuthResultEntity(user: $user, success: $success, message: $message)';
  }
}
