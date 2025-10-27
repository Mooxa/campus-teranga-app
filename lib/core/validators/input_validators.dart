import '../errors/failures.dart';
import '../constants/app_constants.dart';

/// Input Validators
/// 
/// This class provides validation methods for all user inputs
/// following security best practices.

class InputValidators {
  // Private constructor to prevent instantiation
  InputValidators._();

  // Email validation regex
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Phone number validation regex (international format)
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  // Password strength regex (at least 8 chars, 1 uppercase, 1 lowercase, 1 digit)
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
  );

  /// Validate email address
  static ValidationFailure? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return const ValidationFailure(
        message: 'Email is required',
        code: 'EMAIL_REQUIRED',
      );
    }

    final trimmedEmail = email.trim();
    
    if (trimmedEmail.length < 5) {
      return const ValidationFailure(
        message: 'Email is too short',
        code: 'EMAIL_TOO_SHORT',
      );
    }

    if (trimmedEmail.length > 254) {
      return const ValidationFailure(
        message: 'Email is too long',
        code: 'EMAIL_TOO_LONG',
      );
    }

    if (!_emailRegex.hasMatch(trimmedEmail)) {
      return const ValidationFailure(
        message: 'Please enter a valid email address',
        code: 'EMAIL_INVALID_FORMAT',
      );
    }

    return null;
  }

  /// Validate password
  static ValidationFailure? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return const ValidationFailure(
        message: 'Password is required',
        code: 'PASSWORD_REQUIRED',
      );
    }

    if (password.length < AppConstants.minPasswordLength) {
      return ValidationFailure(
        message: 'Password must be at least ${AppConstants.minPasswordLength} characters long',
        code: 'PASSWORD_TOO_SHORT',
      );
    }

    if (password.length > AppConstants.maxPasswordLength) {
      return ValidationFailure(
        message: 'Password must be no more than ${AppConstants.maxPasswordLength} characters long',
        code: 'PASSWORD_TOO_LONG',
      );
    }

    if (!_passwordRegex.hasMatch(password)) {
      return const ValidationFailure(
        message: 'Password must contain at least one uppercase letter, one lowercase letter, and one number',
        code: 'PASSWORD_WEAK',
      );
    }

    return null;
  }

  /// Validate password confirmation
  static ValidationFailure? validatePasswordConfirmation(
    String? password,
    String? confirmation,
  ) {
    if (confirmation == null || confirmation.isEmpty) {
      return const ValidationFailure(
        message: 'Password confirmation is required',
        code: 'PASSWORD_CONFIRMATION_REQUIRED',
      );
    }

    if (password != confirmation) {
      return const ValidationFailure(
        message: 'Passwords do not match',
        code: 'PASSWORD_MISMATCH',
      );
    }

    return null;
  }

  /// Validate full name
  static ValidationFailure? validateFullName(String? name) {
    if (name == null || name.isEmpty) {
      return const ValidationFailure(
        message: 'Full name is required',
        code: 'NAME_REQUIRED',
      );
    }

    final trimmedName = name.trim();
    
    if (trimmedName.length < AppConstants.minNameLength) {
      return ValidationFailure(
        message: 'Name must be at least ${AppConstants.minNameLength} characters long',
        code: 'NAME_TOO_SHORT',
      );
    }

    if (trimmedName.length > AppConstants.maxNameLength) {
      return ValidationFailure(
        message: 'Name must be no more than ${AppConstants.maxNameLength} characters long',
        code: 'NAME_TOO_LONG',
      );
    }

    // Check if name contains only letters, spaces, hyphens, and apostrophes
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$").hasMatch(trimmedName)) {
      return const ValidationFailure(
        message: 'Name can only contain letters, spaces, hyphens, and apostrophes',
        code: 'NAME_INVALID_CHARACTERS',
      );
    }

    // Check if name has at least two words (first and last name)
    if (trimmedName.split(' ').length < 2) {
      return const ValidationFailure(
        message: 'Please enter your first and last name',
        code: 'NAME_INCOMPLETE',
      );
    }

    return null;
  }

  /// Validate phone number
  static ValidationFailure? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return const ValidationFailure(
        message: 'Phone number is required',
        code: 'PHONE_REQUIRED',
      );
    }

    // Remove all non-digit characters except +
    final cleanedPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (cleanedPhone.length < AppConstants.minPhoneLength) {
      return ValidationFailure(
        message: 'Phone number must be at least ${AppConstants.minPhoneLength} digits long',
        code: 'PHONE_TOO_SHORT',
      );
    }

    if (cleanedPhone.length > AppConstants.maxPhoneLength) {
      return ValidationFailure(
        message: 'Phone number must be no more than ${AppConstants.maxPhoneLength} digits long',
        code: 'PHONE_TOO_LONG',
      );
    }

    if (!_phoneRegex.hasMatch(cleanedPhone)) {
      return const ValidationFailure(
        message: 'Please enter a valid phone number',
        code: 'PHONE_INVALID_FORMAT',
      );
    }

    return null;
  }

  /// Sanitize string input
  static String sanitizeString(String? input) {
    if (input == null) return '';
    
    return input
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .replaceAll(RegExp(r'[<>"\']'), ''); // Remove potentially dangerous characters
  }

  /// Sanitize email input
  static String sanitizeEmail(String? email) {
    if (email == null) return '';
    
    return email
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ''); // Remove all spaces
  }

  /// Sanitize phone number input
  static String sanitizePhoneNumber(String? phone) {
    if (phone == null) return '';
    
    return phone
        .replaceAll(RegExp(r'[^\d+]'), '') // Keep only digits and +
        .trim();
  }

  /// Validate and sanitize all registration inputs
  static Map<String, dynamic> validateRegistrationInputs({
    required String? fullName,
    required String? phoneNumber,
    required String? password,
    required String? confirmPassword,
    String? email,
  }) {
    final errors = <String, ValidationFailure>{};
    final sanitized = <String, String>{};

    // Validate and sanitize full name
    final nameError = validateFullName(fullName);
    if (nameError != null) {
      errors['fullName'] = nameError;
    } else {
      sanitized['fullName'] = sanitizeString(fullName);
    }

    // Validate and sanitize phone number
    final phoneError = validatePhoneNumber(phoneNumber);
    if (phoneError != null) {
      errors['phoneNumber'] = phoneError;
    } else {
      sanitized['phoneNumber'] = sanitizePhoneNumber(phoneNumber);
    }

    // Validate and sanitize password
    final passwordError = validatePassword(password);
    if (passwordError != null) {
      errors['password'] = passwordError;
    } else {
      sanitized['password'] = password!;
    }

    // Validate password confirmation
    final confirmPasswordError = validatePasswordConfirmation(password, confirmPassword);
    if (confirmPasswordError != null) {
      errors['confirmPassword'] = confirmPasswordError;
    }

    // Validate and sanitize email (optional)
    if (email != null && email.isNotEmpty) {
      final emailError = validateEmail(email);
      if (emailError != null) {
        errors['email'] = emailError;
      } else {
        sanitized['email'] = sanitizeEmail(email);
      }
    }

    return {
      'errors': errors,
      'sanitized': sanitized,
      'isValid': errors.isEmpty,
    };
  }
}
