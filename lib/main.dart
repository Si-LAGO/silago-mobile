import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';
import 'models/product_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env tidak ditemukan, pakai default
  }
  runApp(const SilagoApp());
}

class SilagoApp extends StatelessWidget {
  const SilagoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'SILAGO',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/product-detail': (context) => const ProductDetailScreen(),
          '/search': (context) => const SearchScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/search') {
            final category = settings.arguments as CategoryModel?;
            return MaterialPageRoute(
              builder: (context) =>
                  SearchScreen(initialCategory: category),
            );
          }
          if (settings.name == '/reset-password') {
            final email = settings.arguments as String? ?? '';
            return MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(email: email),
            );
          }
          return null;
        },
      ),
    );
  }
}

