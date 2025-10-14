import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/formation.dart';
import '../models/service.dart';
import '../models/event.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3000/api';
  String? _token;

  ApiService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Auth endpoints
  Future<Map<String, dynamic>> login(String phoneNumber, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phoneNumber,
    String? email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _saveToken(data['token']);
      return data;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<User> getCurrentUser() async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else {
      throw Exception('Failed to get user: ${response.body}');
    }
  }

  Future<void> logout() async {
    await _clearToken();
  }

  // Formations endpoints
  Future<List<Formation>> getFormations({String? type, String? city}) async {
    String url = '$baseUrl/formations';
    List<String> queryParams = [];
    
    if (type != null) queryParams.add('type=$type');
    if (city != null) queryParams.add('city=$city');
    
    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Formation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load formations: ${response.body}');
    }
  }

  Future<Formation> getFormation(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/formations/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Formation.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load formation: ${response.body}');
    }
  }

  // Services endpoints
  Future<List<Service>> getServices({String? category, String? subcategory, String? city}) async {
    String url = '$baseUrl/services';
    List<String> queryParams = [];
    
    if (category != null) queryParams.add('category=$category');
    if (subcategory != null) queryParams.add('subcategory=$subcategory');
    if (city != null) queryParams.add('city=$city');
    
    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services: ${response.body}');
    }
  }

  Future<List<Service>> getServicesByCategory(String category, {String? subcategory, String? city}) async {
    String url = '$baseUrl/services/category/$category';
    List<String> queryParams = [];
    
    if (subcategory != null) queryParams.add('subcategory=$subcategory');
    if (city != null) queryParams.add('city=$city');
    
    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services: ${response.body}');
    }
  }

  Future<Service> getService(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Service.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load service: ${response.body}');
    }
  }

  // Events endpoints
  Future<List<Event>> getEvents({String? category, bool? upcoming}) async {
    String url = '$baseUrl/events';
    List<String> queryParams = [];
    
    if (category != null) queryParams.add('category=$category');
    if (upcoming != null) queryParams.add('upcoming=$upcoming');
    
    if (queryParams.isNotEmpty) {
      url += '?${queryParams.join('&')}';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events: ${response.body}');
    }
  }

  Future<Event> getEvent(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/events/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load event: ${response.body}');
    }
  }

  Future<void> registerForEvent(String eventId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/events/$eventId/register'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register for event: ${response.body}');
    }
  }

  Future<void> unregisterFromEvent(String eventId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/events/$eventId/register'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unregister from event: ${response.body}');
    }
  }

  // Admin endpoints
  Future<Map<String, dynamic>> getAdminStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/dashboard/stats'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load admin stats: ${response.body}');
    }
  }

  // User management
  Future<Map<String, dynamic>> getAdminUsers({
    int page = 1,
    String search = '',
    String role = '',
  }) async {
    String url = '$baseUrl/admin/users?page=$page';
    if (search.isNotEmpty) url += '&search=$search';
    if (role.isNotEmpty) url += '&role=$role';

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'users': (data['users'] as List).map((json) => User.fromJson(json)).toList(),
        'totalPages': data['totalPages'],
        'currentPage': data['currentPage'],
        'total': data['total'],
      };
    } else {
      throw Exception('Failed to load users: ${response.body}');
    }
  }

  Future<void> updateAdminUser(String userId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/users/$userId'),
      headers: _headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  Future<void> deleteAdminUser(String userId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/users/$userId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.body}');
    }
  }

  // Event management
  Future<Map<String, dynamic>> getAdminEvents({
    int page = 1,
    String search = '',
    String category = '',
  }) async {
    String url = '$baseUrl/admin/events?page=$page';
    if (search.isNotEmpty) url += '&search=$search';
    if (category.isNotEmpty) url += '&category=$category';

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'events': (data['events'] as List).map((json) => Event.fromJson(json)).toList(),
        'totalPages': data['totalPages'],
        'currentPage': data['currentPage'],
        'total': data['total'],
      };
    } else {
      throw Exception('Failed to load events: ${response.body}');
    }
  }

  Future<void> updateAdminEvent(String eventId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/events/$eventId'),
      headers: _headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update event: ${response.body}');
    }
  }

  Future<void> deleteAdminEvent(String eventId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/events/$eventId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete event: ${response.body}');
    }
  }

  // Formation management
  Future<Map<String, dynamic>> getAdminFormations({
    int page = 1,
    String search = '',
    String type = '',
  }) async {
    String url = '$baseUrl/admin/formations?page=$page';
    if (search.isNotEmpty) url += '&search=$search';
    if (type.isNotEmpty) url += '&type=$type';

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'formations': (data['formations'] as List).map((json) => Formation.fromJson(json)).toList(),
        'totalPages': data['totalPages'],
        'currentPage': data['currentPage'],
        'total': data['total'],
      };
    } else {
      throw Exception('Failed to load formations: ${response.body}');
    }
  }

  Future<void> updateAdminFormation(String formationId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/formations/$formationId'),
      headers: _headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update formation: ${response.body}');
    }
  }

  Future<void> deleteAdminFormation(String formationId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/formations/$formationId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete formation: ${response.body}');
    }
  }

  // Service management
  Future<Map<String, dynamic>> getAdminServices({
    int page = 1,
    String search = '',
    String category = '',
  }) async {
    String url = '$baseUrl/admin/services?page=$page';
    if (search.isNotEmpty) url += '&search=$search';
    if (category.isNotEmpty) url += '&category=$category';

    final response = await http.get(
      Uri.parse(url),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'services': (data['services'] as List).map((json) => Service.fromJson(json)).toList(),
        'totalPages': data['totalPages'],
        'currentPage': data['currentPage'],
        'total': data['total'],
      };
    } else {
      throw Exception('Failed to load services: ${response.body}');
    }
  }

  Future<void> updateAdminService(String serviceId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/services/$serviceId'),
      headers: _headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update service: ${response.body}');
    }
  }

  Future<void> deleteAdminService(String serviceId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/admin/services/$serviceId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete service: ${response.body}');
    }
  }
}
