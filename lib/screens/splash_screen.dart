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
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Off-white background seperti PDF
      body: Stack(
        children: [
          // Konten utama - Logo dan text di tengah
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo SILAGO - Sesuai bentuk di PDF (tanpa container kotak)
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CustomPaint(
                    painter: SilagoLogoPainter(),
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
                    letterSpacing: 4,
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
          
          // Wave hijau di bawah (decorative) - Sesuai PDF
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 280),
              painter: WavePainter(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter untuk logo SILAGO sesuai desain PDF
class SilagoLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryGreen
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Gambar bentuk price tag / label organik sesuai PDF
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    path.moveTo(centerX - 30, centerY - 40);
    path.quadraticBezierTo(
      centerX + 20, centerY - 50,
      centerX + 40, centerY - 20,
    );
    path.quadraticBezierTo(
      centerX + 50, centerY + 10,
      centerX + 30, centerY + 35,
    );
    path.quadraticBezierTo(
      centerX, centerY + 50,
      centerX - 30, centerY + 40,
    );
    path.quadraticBezierTo(
      centerX - 50, centerY + 10,
      centerX - 40, centerY - 20,
    );
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Tambahkan detail di dalam logo
    // Circle kecil (lubang tag)
    final circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(centerX + 15, centerY - 15),
      8,
      circlePaint,
    );
    
    // Oval shape (icon simplified)
    final ovalPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX - 5, centerY + 5),
        width: 35,
        height: 18,
      ),
      ovalPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter untuk membuat wave effect di bagian bawah sesuai PDF
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1 - Wave depan (mint green terang)
    final paint1 = Paint()
      ..color = const Color(0xFFD1F4E0) // Mint/hijau muda
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.35);
    path1.quadraticBezierTo(
      size.width * 0.25, size.height * 0.25,
      size.width * 0.5, size.height * 0.3,
    );
    path1.quadraticBezierTo(
      size.width * 0.75, size.height * 0.35,
      size.width, size.height * 0.25,
    );
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint1);

    // Layer 2 - Wave tengah
    final paint2 = Paint()
      ..color = const Color(0xFFE0F8E9)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    path2.quadraticBezierTo(
      size.width * 0.3, size.height * 0.4,
      size.width * 0.6, size.height * 0.45,
    );
    path2.quadraticBezierTo(
      size.width * 0.85, size.height * 0.48,
      size.width, size.height * 0.4,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);

    // Layer 3 - Wave belakang (paling terang)
    final paint3 = Paint()
      ..color = const Color(0xFFEFFBF3)
      ..style = PaintingStyle.fill;

    final path3 = Path();
    path3.moveTo(0, size.height * 0.65);
    path3.quadraticBezierTo(
      size.width * 0.4, size.height * 0.55,
      size.width * 0.7, size.height * 0.6,
    );
    path3.quadraticBezierTo(
      size.width * 0.9, size.height * 0.63,
      size.width, size.height * 0.55,
    );
    path3.lineTo(size.width, size.height);
    path3.lineTo(0, size.height);
    path3.close();
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
