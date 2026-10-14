import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../services/google_auth_service.dart';

/// Login Screen - halaman untuk masuk ke aplikasi
/// User bisa login pakai Email/NIM dan Password, atau Google Sign-In
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk input form
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // State untuk show/hide password
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk handle login dengan validasi proper
  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validasi: field tidak boleh kosong
    if (email.isEmpty || password.isEmpty) {
      _showError('Email/NIM dan Password harus diisi');
      return;
    }

    // Validasi: Email format atau NIM (hanya angka, tanpa spasi)
    final isEmail = email.contains('@');
    final isNIM = RegExp(r'^[\d.]+$').hasMatch(email);

    if (!isEmail && !isNIM) {
      _showError('Email tidak valid atau NIM harus berupa angka saja');
      return;
    }

    // Validasi: Password minimal 8 karakter
    if (password.length < 8) {
      _showError('Password minimal 8 karakter');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final result = await authProvider.login(
        login: email,
        password: password,
      );

      if (!mounted) return;

      if (result['success'] == true) {
        // Login langsung berhasil (tanpa OTP)
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showError(result['message'] ?? 'Login gagal');
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Fungsi untuk handle Google Sign-In
  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final googleAuthService = GoogleAuthService();
      final result = await googleAuthService.signInWithGoogle();

      if (!mounted) return;

      if (result['success'] == true) {
        // Login langsung berhasil (tanpa OTP)
        final authProvider = context.read<AuthProvider>();
        await authProvider.setToken(result['token']);
        await authProvider.saveUserData(result['user']);
        await authProvider.loadUserData();

        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _showError(result['error'] ?? 'Google Sign-In gagal');
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // Header - Welcome text
              const Text(
                'Selamat datang di',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Title - SILAGO
              const Text(
                'SILAGO',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Subtitle
              const Text(
                'Lapak Nego, Sesama Maba',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                  fontFamily: 'Inter',
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Input Email atau NIM
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
                decoration: const InputDecoration(
                  hintText: 'Email atau NIM',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Input Password dengan toggle visibility
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Password',
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
              
              const SizedBox(height: 12),
              
              // Link Lupa Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryGreen,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Tombol Masuk (primary button)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Masuk'),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Divider dengan text "atau masuk dengan"
              Row(
                children: [
                  const Expanded(child: Divider(color: AppTheme.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'atau masuk dengan',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppTheme.border)),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Tombol Google Sign-In
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.border, width: 1.5),
                    foregroundColor: AppTheme.textPrimary,
                  ),
                  icon: Image.network(
                    'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                    width: 20,
                    height: 20,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.g_mobiledata, size: 20);
                    },
                  ),
                  label: Text(
                    _isLoading ? 'Memproses...' : 'Lanjutkan dengan Google',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Link ke halaman Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  GestureDetector(
                    onTap: _isLoading ? null : () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      'Daftar',
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
