import '../../../../core/errors/failures.dart';
import '../../../../core/validators/input_validators.dart';
import '../entities/auth_result_entity.dart';
import '../repositories/auth_repository.dart';

/// Login Use Case
/// 
/// This use case handles user login business logic
/// following clean architecture principles.

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Execute user login
  Future<({Failure? failure, AuthResultEntity? result})> call({
    required String phoneNumber,
    required String password,
  }) async {
    // Validate phone number
    final phoneValidation = InputValidators.validatePhoneNumber(phoneNumber);
    if (phoneValidation != null) {
      return (failure: phoneValidation, result: null);
    }

    // Validate password
    final passwordValidation = InputValidators.validatePassword(password);
    if (passwordValidation != null) {
      return (failure: passwordValidation, result: null);
    }

    // Sanitize inputs
    final sanitizedPhone = InputValidators.sanitizePhoneNumber(phoneNumber);

    // Call repository
    return await _repository.login(
      phoneNumber: sanitizedPhone,
      password: password,
    );
  }
}
