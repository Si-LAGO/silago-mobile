import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Card
          if (user != null) ...[
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Account Info
          const Text(
            'Informasi Akun',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.verified_user),
                  title: const Text('Verifikasi Email'),
                  trailing: Chip(
                    label: Text(
                      user?.emailVerifiedAt != null ? 'Terverifikasi' : 'Belum',
                    ),
                    backgroundColor: user?.emailVerifiedAt != null
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Email Polines'),
                  subtitle: Text('Hanya @mhs.polines.ac.id yang diterima'),
                  trailing: Chip(
                    label: Text(
                      user?.emailDomainVerified == null
                          ? '-'
                          : (user!.emailDomainVerified ? 'Valid' : 'Tidak'),
                    ),
                    backgroundColor: user?.emailDomainVerified == true
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Logout Button
          ElevatedButton.icon(
            onPressed: () async {
              await authProvider.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
