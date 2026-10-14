import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL dari .env file
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://172.16.95.199:8000/api/v1';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  // Get token dari SharedPreferences
  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  // Simpan token ke SharedPreferences
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Hapus token
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  // Simpan user data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(userData));
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_data');
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  // Headers default
  Map<String, String> _getHeaders({bool needsAuth = false}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (needsAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // POST request
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool needsAuth = false,
  }) async {
    if (needsAuth) await getToken();

    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: _getHeaders(needsAuth: needsAuth),
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  // GET request
  Future<http.Response> get(
    String endpoint, {
    bool needsAuth = false,
    Map<String, String>? queryParams,
  }) async {
    if (needsAuth) await getToken();

    var url = Uri.parse('$baseUrl$endpoint');
    if (queryParams != null) {
      url = url.replace(queryParameters: queryParams);
    }

    final response = await http.get(
      url,
      headers: _getHeaders(needsAuth: needsAuth),
    );

    return response;
  }

  // PUT request
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool needsAuth = false,
  }) async {
    if (needsAuth) await getToken();

    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: _getHeaders(needsAuth: needsAuth),
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  // DELETE request
  Future<http.Response> delete(
    String endpoint, {
    bool needsAuth = false,
  }) async {
    if (needsAuth) await getToken();

    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.delete(
      url,
      headers: _getHeaders(needsAuth: needsAuth),
    );

    return response;
  }
}
