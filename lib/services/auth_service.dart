import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String nim,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/register',
        body: {
          'name': name,
          'nim': nim,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil',
          'user': data['user'],
        };
      } else {
        String errorMsg = data['message'] ?? 'Registrasi gagal';
        if (data['errors'] != null && data['errors'] is Map) {
          final errorsMap = data['errors'] as Map<String, dynamic>;
          final firstKey = errorsMap.keys.firstOrNull;
          if (firstKey != null && errorsMap[firstKey] is List && (errorsMap[firstKey] as List).isNotEmpty) {
            errorMsg = (errorsMap[firstKey] as List).first.toString();
          }
        }
        return {
          'success': false,
          'message': errorMsg,
        };
      }
    } catch (e) {
      if (e is http.ClientException) {
        return {
          'success': false,
          'message': 'Tidak dapat terhubung ke server. Pastikan backend berjalan.',
        };
      }
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String login,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        body: {
          'login': login,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        
        // Login langsung tanpa OTP
        await _apiService.setToken(data['token']);
        await _apiService.saveUserData(data['user']);
        
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'message': error['message'] ?? 'Login gagal',
        };
      }
    } catch (e) {
      if (e is http.ClientException) {
        return {
          'success': false,
          'message': 'Tidak dapat terhubung ke server. Pastikan backend berjalan.',
        };
      }
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // Call API logout
      await _apiService.post(
        '/auth/logout',
        needsAuth: true,
      );
    } catch (e) {
      // Tetap clear token meskipun API gagal
    } finally {
      // Clear local data
      await _apiService.clearToken();
    }
  }

  // Check if user logged in
  Future<bool> isLoggedIn() async {
    final token = await _apiService.getToken();
    return token != null && token.isNotEmpty;
  }

  // Get current user dari local storage
  Future<UserModel?> getCurrentUser() async {
    final userData = await _apiService.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  // Verify token dengan API (optional)
  Future<bool> verifyToken() async {
    try {
      final response = await _apiService.get(
        '/me',
        needsAuth: true,
      );
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
