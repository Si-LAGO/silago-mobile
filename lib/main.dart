import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(const SilagoApp());
}

class SilagoApp extends StatelessWidget {
  const SilagoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SILAGO',
      debugShowCheckedModeBanner: false,
      
      // Pakai theme yang sudah dibuat
      theme: AppTheme.lightTheme,
      
      // Routing
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/product-detail': (context) => const ProductDetailScreen(),
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}
