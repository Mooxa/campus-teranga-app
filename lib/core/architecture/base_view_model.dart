import 'package:flutter/foundation.dart';
import '../errors/failures.dart';

/// Base ViewModel
/// 
/// This abstract class provides common functionality for all ViewModels
/// including loading states, error handling, and state management.

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isInitialized = false;
  Failure? _error;

  // Getters
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  Failure? get error => _error;
  bool get hasError => _error != null;

  // Loading state management
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  // Error state management
  void setError(Failure? error) {
    if (_error != error) {
      _error = error;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  // Initialization state
  void setInitialized(bool initialized) {
    if (_isInitialized != initialized) {
      _isInitialized = initialized;
      notifyListeners();
    }
  }

  // Initialize method to be overridden by subclasses
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    setLoading(true);
    clearError();
    
    try {
      await onInitialize();
      setInitialized(true);
    } catch (e) {
      setError(UnknownFailure(
        message: e.toString(),
        details: e,
      ));
    } finally {
      setLoading(false);
    }
  }

  // Method to be overridden by subclasses
  Future<void> onInitialize() async {}

  // Refresh method
  Future<void> refresh() async {
    setInitialized(false);
    await initialize();
  }

  // Dispose method
  @override
  void dispose() {
    super.dispose();
  }

  // Helper method for safe async operations
  Future<T?> safeAsyncOperation<T>(
    Future<T> Function() operation, {
    String? errorMessage,
  }) async {
    try {
      return await operation();
    } catch (e) {
      setError(UnknownFailure(
        message: errorMessage ?? 'Operation failed: ${e.toString()}',
        details: e,
      ));
      return null;
    }
  }

  // Helper method for safe sync operations
  T? safeSyncOperation<T>(
    T Function() operation, {
    String? errorMessage,
  }) {
    try {
      return operation();
    } catch (e) {
      setError(UnknownFailure(
        message: errorMessage ?? 'Operation failed: ${e.toString()}',
        details: e,
      ));
      return null;
    }
  }
}