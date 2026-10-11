import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Register Screen - Form pendaftaran akun baru
/// User daftar dengan Nama, NIM, Email Polines, dan Password
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validasi email Polines (dummy, nanti sesuaikan domain)
  bool _isValidPolinesMail(String email) {
    // TODO: Ganti dengan domain email Polines yang bener
    // Sementara pakai @polines.ac.id atau @students.polines.ac.id
    return email.endsWith('@polines.ac.id') || 
           email.endsWith('@students.polines.ac.id');
  }

  // Handle register dengan validasi lengkap
  void _handleRegister() {
    final name = _nameController.text.trim();
    final nim = _nimController.text.trim().replaceAll(' ', ''); // Hapus spasi
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validasi: Nama lengkap
    if (name.isEmpty) {
      _showError('Nama lengkap harus diisi');
      return;
    }

    if (name.length < 3) {
      _showError('Nama minimal 3 karakter');
      return;
    }

    // Validasi: NIM (hanya angka dan titik, tanpa spasi)
    if (nim.isEmpty) {
      _showError('NIM harus diisi');
      return;
    }

    if (!RegExp(r'^[\d.]+$').hasMatch(nim)) {
      _showError('NIM hanya boleh berisi angka dan titik (tanpa spasi)');
      return;
    }

    // Validasi: Email Polines
    if (email.isEmpty) {
      _showError('Email harus diisi');
      return;
    }

    if (!_isValidPolinesMail(email)) {
      _showError('Email harus menggunakan email Polines (@polines.ac.id)');
      return;
    }

    // Validasi: Password minimal 8 karakter
    if (password.isEmpty) {
      _showError('Password harus diisi');
      return;
    }

    if (password.length < 8) {
      _showError('Password minimal 8 karakter');
      return;
    }

    // Validasi: Password harus kombinasi huruf, angka, dan simbol
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecialChar) {
      _showError('Password harus mengandung huruf besar, huruf kecil, angka, dan simbol');
      return;
    }

    // Validasi: Confirm password
    if (password != confirmPassword) {
      _showError('Password dan konfirmasi password tidak sama');
      return;
    }

    // TODO: Nanti sambung ke API POST /auth/register
    // Untuk sekarang langsung ke Login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registrasi berhasil! Silakan login.'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );

    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        title: const Text('Daftar Akun'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // Header
              const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Daftar menggunakan email Polines',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),

              const SizedBox(height: 32),

              // Input Nama Lengkap
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Nama Lengkap',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Input NIM
              TextField(
                controller: _nimController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'NIM (contoh: 3.34.25.1.14)',
                  prefixIcon: Icon(
                    Icons.badge_outlined,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Input Email Polines
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email Polines',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Input Password
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Password (minimal 8 karakter)',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppTheme.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Input Confirm Password
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Konfirmasi Password',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppTheme.textSecondary,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  child: const Text('Daftar'),
                ),
              ),

              const SizedBox(height: 24),

              // Link ke Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Sudah punya akun? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryGreen,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
