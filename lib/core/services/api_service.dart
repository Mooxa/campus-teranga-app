import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/app_config.dart';
import 'storage_service.dart';
import '../models/user.dart';
import '../models/formation.dart';
import '../models/service.dart';
import '../models/event.dart';

/// Modern API Service using Dio for HTTP requests
/// 
/// This service provides:
/// - Automatic token management
/// - Request/response interceptors
/// - Error handling
/// - Request timeout management
/// - Logging for debugging
class ApiService {
  late final Dio _dio;
  final StorageService _storageService;
  final Logger _logger = Logger();

  ApiService({required StorageService storageService}) 
      : _storageService = storageService {
    _initializeDio();
  }

  void _initializeDio() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'Campus-Teranga-App/${AppConfig.appVersion}',
      },
    ));

    // Add request interceptor for authentication
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          if (AppConfig.enableHttpLogging) {
            _logger.d('Request: ${options.method} ${options.uri}');
            _logger.d('Headers: ${options.headers}');
            if (options.data != null) {
              _logger.d('Data: ${options.data}');
            }
          }
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (AppConfig.enableHttpLogging) {
            _logger.d('Response: ${response.statusCode} ${response.requestOptions.uri}');
            _logger.d('Data: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (AppConfig.enableHttpLogging) {
            _logger.e('Error: ${error.requestOptions.uri}');
            _logger.e('Message: ${error.message}');
          }
          
          // Handle specific error cases
          if (error.response?.statusCode == 401) {
            // Token expired or invalid, clear stored token
            _storageService.clearToken();
          }
          
          handler.next(error);
        },
      ),
    );
  }

  /// Generic GET request
  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      
      if (response.statusCode == 200) {
        return fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      _logger.e('Unexpected error in GET request: $e');
      return null;
    }
  }

  /// Generic POST request
  Future<T?> post<T>(
    String path, {
    Map<String, dynamic>? data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      _logger.e('Unexpected error in POST request: $e');
      return null;
    }
  }

  /// Generic PUT request
  Future<T?> put<T>(
    String path, {
    Map<String, dynamic>? data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
      );
      
      if (response.statusCode == 200) {
        return fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      _handleDioError(e);
      return null;
    } catch (e) {
      _logger.e('Unexpected error in PUT request: $e');
      return null;
    }
  }

  /// Generic DELETE request
  Future<bool> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response.statusCode == 200;
    } on DioException catch (e) {
      _handleDioError(e);
      return false;
    } catch (e) {
      _logger.e('Unexpected error in DELETE request: $e');
      return false;
    }
  }

  /// Handle Dio errors
  void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        _logger.e('Timeout error: ${error.message}');
        break;
      case DioExceptionType.badResponse:
        _logger.e('Bad response: ${error.response?.statusCode} - ${error.response?.data}');
        break;
      case DioExceptionType.cancel:
        _logger.e('Request cancelled: ${error.message}');
        break;
      case DioExceptionType.connectionError:
        _logger.e('Connection error: ${error.message}');
        break;
      case DioExceptionType.badCertificate:
        _logger.e('Bad certificate: ${error.message}');
        break;
      case DioExceptionType.unknown:
        _logger.e('Unknown error: ${error.message}');
        break;
    }
  }

  // Authentication endpoints
  Future<Map<String, dynamic>?> login(String phoneNumber, String password) async {
    return await post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'phoneNumber': phoneNumber,
        'password': password,
      },
      fromJson: (data) => data,
    );
  }

  Future<Map<String, dynamic>?> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
    required String confirmPassword,
  }) async {
    print('🌐 [API_SERVICE] Register method called');
    print('📝 [API_SERVICE] Registration data:');
    print('   - Full Name: $fullName');
    print('   - Phone: $phoneNumber');
    print('   - Email: ${email ?? "Not provided"}');
    print('   - Password: ${password.length} characters');
    print('   - Confirm Password: ${confirmPassword.length} characters');
    
    final requestData = {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
    
    print('📤 [API_SERVICE] Sending POST request to /auth/register');
    print('📤 [API_SERVICE] Request data: $requestData');
    
    try {
      final result = await post<Map<String, dynamic>>(
        '/auth/register',
        data: requestData,
        fromJson: (data) {
          print('📥 [API_SERVICE] Raw response data: $data');
          return data;
        },
      );
      
      print('📥 [API_SERVICE] Register response received');
      print('📥 [API_SERVICE] Response data: $result');
      
      if (result != null) {
        print('✅ [API_SERVICE] Registration successful');
        print('👤 [API_SERVICE] User data: ${result['user']}');
        print('🔑 [API_SERVICE] Token present: ${result['token'] != null}');
      } else {
        print('❌ [API_SERVICE] Registration failed - null response');
      }
      
      return result;
    } catch (e) {
      print('💥 [API_SERVICE] Register error: $e');
      print('📊 [API_SERVICE] Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  Future<User?> getCurrentUser() async {
    return await get<User>(
      '/auth/me',
      fromJson: (data) => User.fromJson(data['user']),
    );
  }

  // Formations endpoints
  Future<List<Formation>?> getFormations({
    String? type,
    String? city,
  }) async {
    final queryParams = <String, dynamic>{};
    if (type != null) queryParams['type'] = type;
    if (city != null) queryParams['city'] = city;

    final response = await _dio.get('/formations', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Formation.fromJson(json)).toList();
    }
    return null;
  }

  Future<Formation?> getFormation(String id) async {
    return await get<Formation>(
      '/formations/$id',
      fromJson: (data) => Formation.fromJson(data),
    );
  }

  // Services endpoints
  Future<List<Service>?> getServices({
    String? category,
    String? subcategory,
    String? city,
  }) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    if (subcategory != null) queryParams['subcategory'] = subcategory;
    if (city != null) queryParams['city'] = city;

    final response = await _dio.get('/services', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Service.fromJson(json)).toList();
    }
    return null;
  }

  Future<Service?> getService(String id) async {
    return await get<Service>(
      '/services/$id',
      fromJson: (data) => Service.fromJson(data),
    );
  }

  // Events endpoints
  Future<List<Event>?> getEvents({
    String? category,
    bool? upcoming,
  }) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    if (upcoming != null) queryParams['upcoming'] = upcoming;

    final response = await _dio.get('/events', queryParameters: queryParams);
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => Event.fromJson(json)).toList();
    }
    return null;
  }

  Future<Event?> getEvent(String id) async {
    return await get<Event>(
      '/events/$id',
      fromJson: (data) => Event.fromJson(data),
    );
  }

  Future<bool> registerForEvent(String eventId) async {
    return await delete('/events/$eventId/register');
  }

  Future<bool> unregisterFromEvent(String eventId) async {
    return await delete('/events/$eventId/register');
  }

  // Admin endpoints
  Future<Map<String, dynamic>?> getAdminStats() async {
    return await get<Map<String, dynamic>>(
      '/admin/dashboard/stats',
      fromJson: (data) => data,
    );
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
