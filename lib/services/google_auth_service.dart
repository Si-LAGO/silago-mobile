import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert';
import 'api_service.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    hostedDomain: 'mhs.polines.ac.id',
  );

  final ApiService _apiService = ApiService();

  // Validasi email @mhs.polines.ac.id
  bool _isValidPolinesEmail(String email) {
    return email.toLowerCase().endsWith('@mhs.polines.ac.id');
  }

  // Sign in dengan Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Clear session sebelumnya agar selalu memunculkan pilihan akun
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {
          'success': false,
          'error': 'Login dibatalkan oleh pengguna',
        };
      }

      // Validasi domain email Polines
      if (!_isValidPolinesEmail(googleUser.email)) {
        return {
          'success': false,
          'error': 'Email harus menggunakan email mahasiswa (@mhs.polines.ac.id)',
        };
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        throw Exception('Gagal mendapatkan access token dari Google');
      }

      // Send ke backend
      final response = await _apiService.post(
        '/auth/login-google',
        body: {
          'access_token': accessToken,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
        };
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'error': error['message'] ?? 'Google Sign-In gagal di server backend.',
        };
      }
    } catch (e) {
      String msg = e.toString();
      if (msg.contains('ApiException: 10') || msg.contains(': 10:')) {
        msg = 'Google Sign-In Error (ApiException 10: DEVELOPER_ERROR):\nSHA-1 debug PC belum terdaftar di Google Cloud Console untuk package com.example.silago.';
      }
      return {
        'success': false,
        'error': msg,
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  // Check if already signed in
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
}
