import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import 'storage_service.dart';

/// API Client
/// 
/// This class handles all HTTP communication with the backend
/// following clean architecture principles and security best practices.

class ApiClient {
  final StorageService _storageService;
  final Connectivity _connectivity;
  late final http.Client _client;

  // Base URL configuration
  static String get _baseUrl {
    const environment = String.fromEnvironment('FLUTTER_APP_ENV', defaultValue: 'development');
    switch (environment) {
      case 'production':
        return AppConstants.productionApiUrl;
      case 'staging':
        return AppConstants.stagingApiUrl;
      default:
        return AppConstants.developmentApiUrl;
    }
  }

  ApiClient({
    required StorageService storageService,
    Connectivity? connectivity,
    http.Client? client,
  }) : _storageService = storageService,
       _connectivity = connectivity ?? Connectivity(),
       _client = client ?? http.Client();

  /// Get authentication headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'User-Agent': 'Campus-Teranga-App/${AppConstants.appVersion}',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Check network connectivity
  Future<bool> _isConnected() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      if (kDebugMode) {
        print('Connectivity check failed: $e');
      }
      return false;
    }
  }

  /// Handle HTTP response and convert to appropriate result
  Future<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (kDebugMode) {
      print('API Response: ${response.statusCode} - ${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          return fromJson(data);
        } catch (e) {
          throw const ServerException(
            message: 'Invalid response format',
            code: 'INVALID_RESPONSE_FORMAT',
          );
        }

      case 400:
        final errorData = _parseErrorResponse(response.body);
        throw ValidationException(
          message: errorData['message'] ?? 'Bad request',
          code: errorData['code'] ?? 'BAD_REQUEST',
          details: errorData,
        );

      case 401:
        // Clear stored token on unauthorized
        await _storageService.clearToken();
        throw const AuthException(
          message: 'Authentication required',
          code: 'UNAUTHORIZED',
        );

      case 403:
        throw const AuthException(
          message: 'Access forbidden',
          code: 'FORBIDDEN',
        );

      case 404:
        throw const ServerException(
          message: 'Resource not found',
          code: 'NOT_FOUND',
        );

      case 422:
        final errorData = _parseErrorResponse(response.body);
        throw ValidationException(
          message: errorData['message'] ?? 'Validation failed',
          code: errorData['code'] ?? 'VALIDATION_FAILED',
          details: errorData,
        );

      case 429:
        throw const ServerException(
          message: 'Too many requests. Please try again later.',
          code: 'RATE_LIMITED',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        throw const ServerException(
          message: 'Server error. Please try again later.',
          code: 'SERVER_ERROR',
        );

      default:
        throw ServerException(
          message: 'Unexpected error: ${response.statusCode}',
          code: 'UNEXPECTED_ERROR',
          details: {'statusCode': response.statusCode, 'body': response.body},
        );
    }
  }

  /// Parse error response from server
  Map<String, dynamic> _parseErrorResponse(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      return {'message': 'Unknown error occurred'};
    }
  }

  /// Convert exceptions to failures
  Failure _handleException(dynamic exception) {
    if (exception is SocketException) {
      return const NetworkFailure(
        message: AppConstants.networkErrorMessage,
        code: 'NO_INTERNET',
      );
    }

    if (exception is HttpException) {
      return const NetworkFailure(
        message: AppConstants.networkErrorMessage,
        code: 'HTTP_ERROR',
      );
    }

    if (exception is FormatException) {
      return const ServerFailure(
        message: 'Invalid response format',
        code: 'INVALID_FORMAT',
      );
    }

    if (exception is ValidationException) {
      return ValidationFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    }

    if (exception is AuthException) {
      return AuthFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    }

    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    }

    if (exception is NetworkException) {
      return NetworkFailure(
        message: exception.message,
        code: exception.code,
        details: exception.details,
      );
    }

    return UnknownFailure(
      message: AppConstants.unknownErrorMessage,
      details: exception,
    );
  }

  /// Make HTTP request with proper error handling
  Future<T> _makeRequest<T>(
    Future<http.Response> Function() request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    // Check connectivity
    if (!await _isConnected()) {
      throw const NetworkFailure(
        message: AppConstants.networkErrorMessage,
        code: 'NO_CONNECTIVITY',
      );
    }

    try {
      final response = await request().timeout(
        const Duration(milliseconds: AppConstants.connectTimeout),
      );

      return await _handleResponse(response, fromJson);
    } on SocketException {
      throw const NetworkFailure(
        message: AppConstants.networkErrorMessage,
        code: 'NO_INTERNET',
      );
    } on HttpException {
      throw const NetworkFailure(
        message: AppConstants.networkErrorMessage,
        code: 'HTTP_ERROR',
      );
    } on FormatException {
      throw const ServerFailure(
        message: 'Invalid response format',
        code: 'INVALID_FORMAT',
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw _handleException(e);
    }
  }

  /// GET request
  Future<T> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, String>? queryParams,
  }) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(
      queryParameters: queryParams,
    );

    return _makeRequest(
      () => _client.get(uri, headers: await _getHeaders()),
      fromJson,
    );
  }

  /// POST request
  Future<T> post<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final body = jsonEncode(data);

    return _makeRequest(
      () => _client.post(
        uri,
        headers: await _getHeaders(),
        body: body,
      ),
      fromJson,
    );
  }

  /// PUT request
  Future<T> put<T>(
    String endpoint,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final body = jsonEncode(data);

    return _makeRequest(
      () => _client.put(
        uri,
        headers: await _getHeaders(),
        body: body,
      ),
      fromJson,
    );
  }

  /// DELETE request
  Future<T> delete<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final uri = Uri.parse('$_baseUrl$endpoint');

    return _makeRequest(
      () => _client.delete(uri, headers: await _getHeaders()),
      fromJson,
    );
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}
