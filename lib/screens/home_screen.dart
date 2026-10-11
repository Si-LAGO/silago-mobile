import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Home Screen / Beranda - Halaman utama marketplace
/// Design sesuai PDF: 04 - Beranda Home SILAGO
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Dummy data kategori (nanti ganti dengan API GET /categories)
  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Elektronik', 'icon': Icons.laptop},
    {'id': 2, 'name': 'Fashion', 'icon': Icons.checkroom},
    {'id': 3, 'name': 'Kendaraan', 'icon': Icons.directions_bike},
    {'id': 4, 'name': 'Buku & Alat Tulis', 'icon': Icons.menu_book},
    {'id': 5, 'name': 'Rumah Tangga', 'icon': Icons.home},
    {'id': 6, 'name': 'Lainnya', 'icon': Icons.more_horiz},
  ];

  // Dummy data produk (nanti ganti dengan API GET /products)
  final List<Map<String, dynamic>> _products = [
    {
      'id': 1,
      'name': 'Laptop Asus ROG',
      'price': 8500000,
      'condition': 'Bekas',
      'location': 'Semarang',
      'isNegotiable': true,
      'isFavorite': false,
      'image': null,
    },
    {
      'id': 2,
      'name': 'Mouse Logitech G502',
      'price': 450000,
      'condition': 'Baru (BNIB)',
      'location': 'Semarang',
      'isNegotiable': true,
      'isFavorite': false,
      'image': null,
    },
    {
      'id': 3,
      'name': 'Keyboard Mechanical',
      'price': 750000,
      'condition': 'Bekas',
      'location': 'Semarang',
      'isNegotiable': true,
      'isFavorite': true,
      'image': null,
    },
    {
      'id': 4,
      'name': 'Sepeda MTB Polygon',
      'price': 2500000,
      'condition': 'Bekas',
      'location': 'Semarang',
      'isNegotiable': false,
      'isFavorite': false,
      'image': null,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    if (index == 2) {
      // Tombol Jual (tengah) - Navigate to Post Product (belum dibuat)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur Jual belum tersedia')),
      );
      return;
    }

    setState(() {
      // Adjust index karena ada tombol jual di tengah
      if (index > 2) {
        _selectedIndex = index - 1;
      } else {
        _selectedIndex = index;
      }
    });

    // Navigation
    if (index == 1) {
      // Chat (job Rosa)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur Chat belum tersedia (job Rosa)')),
      );
    } else if (index == 3) {
      // Transaksi (job Denny)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur Transaksi belum tersedia (job Denny)')),
      );
    } else if (index == 4) {
      // Profil (job Aidan - belum dibuat)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fitur Profil belum tersedia')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            // Logo SILAGO (ikon tag hijau)
            Container(
              width: 32,
              height: 32,
              child: Image.asset(
                'assets/images/logo_silago.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            // Text SILAGO dengan warna hijau tua
            const Text(
              'SILAGO',
              style: TextStyle(
                color: AppTheme.primaryGreenDark,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          // Icon notifikasi
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur Notifikasi belum tersedia')),
              );
            },
          ),
          // Icon profil berbentuk lingkaran
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur Profil belum tersedia')),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.greyVeryLight,
                child: const Icon(Icons.person, size: 20, color: AppTheme.textPrimary),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to search screen
                  Navigator.pushNamed(context, '/search');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.greyVeryLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border, width: 1),
                  ),
                  child: TextField(
                    controller: _searchController,
                    enabled: false, // Disable typing, hanya untuk navigate
                    decoration: const InputDecoration(
                      hintText: 'Cari barang, kategori, atau pengguna...',
                      hintStyle: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: AppTheme.textMuted, size: 20),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Banner Promosi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.greenPastelLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Text area (kiri)
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Suka barangnya?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tawar aja dulu!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryGreen,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Temukan barang, ajukan penawaran, dan nego langsung dengan mahasiswa Polines.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              fontFamily: 'Inter',
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Ilustrasi area (kanan) - placeholder
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.people_outline,
                            size: 48,
                            color: AppTheme.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section Kategori
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Kategori',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Kategori Grid 3x2
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kategori: ${category['name']}')),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Kotak kategori dengan background abu-abu sangat muda
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppTheme.greyVeryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            category['icon'],
                            color: AppTheme.primaryGreenDark,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Label kategori
                        Text(
                          category['name'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textPrimary,
                            fontFamily: 'Inter',
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Section Rekomendasi Produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rekomendasi untuk kamu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Lihat semua
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Lihat semua',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGreenDark,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Grid Produk (2 kolom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return _buildProductCard(product);
                },
              ),
            ),

            const SizedBox(height: 100), // Space untuk bottom nav
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        // Navigate ke product detail screen
        Navigator.pushNamed(context, '/product-detail');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image dengan icon hati dan label nego
            Stack(
              children: [
                // Image Placeholder
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppTheme.greyVeryLight,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ),
                // Icon hati pojok kanan atas
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      product['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                      color: product['isFavorite'] ? Colors.red : AppTheme.textMuted,
                      size: 18,
                    ),
                  ),
                ),
                // Label "Bisa nego"
                if (product['isNegotiable'])
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Bisa nego',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      fontFamily: 'Inter',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Harga
                  Text(
                    'Rp${product['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryGreenDark,
                      fontFamily: 'Inter',
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Lokasi
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: AppTheme.textMuted,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          product['location'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            fontFamily: 'Inter',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Beranda', 0),
              _buildNavItem(Icons.chat_bubble_outline, 'Chat', 1),
              _buildJualButton(),
              _buildNavItem(Icons.receipt_long_outlined, 'Transaksi', 3),
              _buildNavItem(Icons.person_outline, 'Profil', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = (_selectedIndex == index && index != 2);
    return GestureDetector(
      onTap: () => _onBottomNavTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppTheme.primaryGreen : AppTheme.textMuted,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppTheme.primaryGreen : AppTheme.textMuted,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJualButton() {
    return GestureDetector(
      onTap: () => _onBottomNavTapped(2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
