import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// User model for the Campus Téranga app
/// 
/// This model represents a user in the system with all necessary
/// information for authentication and profile management.
@JsonSerializable()
class User {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Convert a User instance to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Create a copy of this User with updated fields
  User copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if the user is an admin
  bool get isAdmin => role.toLowerCase() == 'admin';

  /// Check if the user is a regular user
  bool get isUser => role.toLowerCase() == 'user';

  /// Get user's display name
  String get displayName => fullName.isNotEmpty ? fullName : phoneNumber;

  /// Get user's initials for avatar
  String get initials {
    if (fullName.isEmpty) return phoneNumber.substring(0, 2);
    final names = fullName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 2).toUpperCase();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, phoneNumber: $phoneNumber, role: $role)';
  }
}
