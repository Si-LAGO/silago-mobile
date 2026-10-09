import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

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
      
      // Home sementara kosong, nanti diisi routing
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
