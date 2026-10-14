import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Initialize - check if already logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        _user = await _authService.getCurrentUser();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login (langsung token, tanpa OTP)
  Future<Map<String, dynamic>> login({
    required String login,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(
        login: login,
        password: password,
      );

      if (result['success'] == true) {
        // Login langsung berhasil
        final userData = result['user'] as Map<String, dynamic>;
        _user = UserModel.fromJson(userData);
        _isLoading = false;
        notifyListeners();
        return result;
      } else {
        _errorMessage = result['message'] ?? 'Login gagal';
        _isLoading = false;
        notifyListeners();
        return result;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'message': _errorMessage,
      };
    }
  }

  // Set token untuk Google auth
  Future<void> setToken(String token) async {
    await _apiService.setToken(token);
  }

  // Simpan user data untuk Google auth
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _apiService.saveUserData(userData);
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String nim,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.register(
      name: name,
      nim: nim,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    _isLoading = false;
    if (result['success'] != true) {
      _errorMessage = result['message'];
    }
    notifyListeners();
    return result;
  }

  // Reload user data dari local storage
  Future<void> loadUserData() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }

  // Refresh user data dari server
  Future<void> refreshUser() async {
    try {
      final response = await _apiService.get('/me');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final userData = data['user'] ?? data;
        _user = UserModel.fromJson(userData);
        await _apiService.saveUserData(userData);
        notifyListeners();
      }
    } catch (_) {
      // Biarkan data lokal jika gagal refresh
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
