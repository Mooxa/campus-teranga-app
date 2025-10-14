import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> login(String phoneNumber, String password) async {
    _setLoading(true);
    _clearError();

    try {
      print('Debug: Attempting login for phone: $phoneNumber');
      final response = await _apiService.login(phoneNumber, password);
      print('Debug: Login response: $response');
      _user = User.fromJson(response['user']);
      print('Debug: User created: ${_user?.fullName}, role: ${_user?.role}');
      notifyListeners();
    } catch (e) {
      print('Debug: Login error: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.register(
        fullName: fullName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
      );
      _user = User.fromJson(response['user']);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _apiService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUser() async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _apiService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      _user = null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
