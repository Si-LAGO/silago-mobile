import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';

/// Splash Screen - halaman pertama yang muncul saat buka aplikasi
/// Tampil selama 2-3 detik, lalu otomatis pindah ke Login
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer untuk pindah ke Login setelah 3 detik
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      body: Stack(
        children: [
          // Konten utama - Logo dan text di tengah
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo SILAGO
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Image.asset(
                    'assets/images/logo_silago.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.store,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Text "SILAGO"
                const Text(
                  'SILAGO',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGreen,
                    letterSpacing: 2,
                    fontFamily: 'Inter',
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Tagline "Lapak Nego"
                const Text(
                  'Lapak Nego',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          
          // Wave hijau di bawah (3 layer dengan 3 warna berbeda)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                // Wave 3 (paling belakang - warna paling gelap)
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 200),
                  painter: WavePainter(
                    color: AppTheme.primaryGreenDark.withOpacity(0.3),
                    offset: 60,
                  ),
                ),
                // Wave 2 (tengah - warna sedang)
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 200),
                  painter: WavePainter(
                    color: AppTheme.primaryGreen.withOpacity(0.4),
                    offset: 30,
                  ),
                ),
                // Wave 1 (paling depan - warna paling terang)
                CustomPaint(
                  size: Size(MediaQuery.of(context).size.width, 200),
                  painter: WavePainter(
                    color: AppTheme.greenTint.withOpacity(0.5),
                    offset: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter untuk membuat wave effect di bagian bawah
/// Sekarang dengan support multiple layer (3 warna berbeda)
class WavePainter extends CustomPainter {
  final Color color;
  final double offset;

  WavePainter({
    required this.color,
    this.offset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Mulai dari kiri bawah
    path.moveTo(0, size.height * 0.3 + offset);
    
    // Buat kurva wave pertama
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.2 + offset,  // control point 1
      size.width * 0.5, size.height * 0.25 + offset,  // end point 1
    );
    
    // Buat kurva wave kedua
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.3 + offset,  // control point 2
      size.width, size.height * 0.2 + offset,          // end point 2
    );
    
    // Tutup path ke kanan bawah dan kiri bawah
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
