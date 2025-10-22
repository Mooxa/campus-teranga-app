import 'package:flutter/foundation.dart';

/// Base ViewModel class that provides common functionality for all ViewModels
/// 
/// This class implements the MVVM pattern and provides:
/// - State management with ChangeNotifier
/// - Loading state management
/// - Error handling
/// - Common utility methods
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  /// Whether the ViewModel is currently loading
  bool get isLoading => _isLoading;

  /// Current error message, null if no error
  String? get error => _error;

  /// Current success message, null if no success message
  String? get successMessage => _successMessage;

  /// Whether there's an error
  bool get hasError => _error != null;

  /// Whether there's a success message
  bool get hasSuccessMessage => _successMessage != null;

  /// Set loading state
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Set error message
  void setError(String? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  /// Set success message
  void setSuccessMessage(String? message) {
    if (_successMessage != message) {
      _successMessage = message;
      notifyListeners();
    }
  }

  /// Clear all messages (error and success)
  void clearMessages() {
    if (_error != null || _successMessage != null) {
      _error = null;
      _successMessage = null;
      notifyListeners();
    }
  }

  /// Clear only error message
  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  /// Clear only success message
  void clearSuccessMessage() {
    if (_successMessage != null) {
      _successMessage = null;
      notifyListeners();
    }
  }

  /// Execute an async operation with loading state management
  Future<T?> executeWithLoading<T>(
    Future<T> Function() operation, {
    String? loadingMessage,
    String? errorMessage,
    bool showSuccess = false,
  }) async {
    try {
      setLoading(true);
      clearMessages();
      
      final result = await operation();
      
      if (showSuccess && result != null) {
        setSuccessMessage('Operation completed successfully');
      }
      
      return result;
    } catch (e) {
      setError(errorMessage ?? 'An error occurred: ${e.toString()}');
      return null;
    } finally {
      setLoading(false);
    }
  }

  /// Execute an async operation without loading state
  Future<T?> execute<T>(
    Future<T> Function() operation, {
    String? errorMessage,
  }) async {
    try {
      clearMessages();
      return await operation();
    } catch (e) {
      setError(errorMessage ?? 'An error occurred: ${e.toString()}');
      return null;
    }
  }

  @override
  void dispose() {
    clearMessages();
    super.dispose();
  }
}
