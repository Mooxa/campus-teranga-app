import '../../../../core/errors/failures.dart';
import '../../../../core/validators/input_validators.dart';
import '../entities/auth_result_entity.dart';
import '../repositories/auth_repository.dart';

/// Register Use Case
/// 
/// This use case handles user registration business logic
/// following clean architecture principles.

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  /// Execute user registration
  Future<({Failure? failure, AuthResultEntity? result})> call({
    required String fullName,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    String? email,
  }) async {
    // Validate inputs
    final validation = InputValidators.validateRegistrationInputs(
      fullName: fullName,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
      email: email,
    );

    if (!validation['isValid'] as bool) {
      final errors = validation['errors'] as Map<String, ValidationFailure>;
      final firstError = errors.values.first;
      return (failure: firstError, result: null);
    }

    final sanitized = validation['sanitized'] as Map<String, String>;

    // Call repository
    return await _repository.register(
      fullName: sanitized['fullName']!,
      phoneNumber: sanitized['phoneNumber']!,
      password: sanitized['password']!,
      email: sanitized['email'],
    );
  }
}
