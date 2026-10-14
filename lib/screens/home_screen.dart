import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/product_card.dart';

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
  final ProductService _productService = ProductService();

  // Kategori dari API GET /categories
  List<CategoryModel> _categories = [];
  bool _isLoadingCategories = true;

  // Produk dari API GET /products
  List<ProductModel> _products = [];
  bool _isLoadingProducts = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadProducts();
  }

  Future<void> _loadCategories() async {
    try {
      setState(() => _isLoadingCategories = true);
      final categories = await _productService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingCategories = false);
      }
    }
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoadingProducts = true;
        _errorMessage = null;
      });

      final response = await _productService.getProducts(
        page: 1,
        perPage: 10,
        sort: 'newest',
      );

      if (mounted) {
        setState(() {
          _products = response.products;
          _isLoadingProducts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoadingProducts = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(int productId, int index) async {
    try {
      final isFavorited = await _productService.toggleFavorite(productId);
      if (mounted) {
        setState(() {
          _products[index] =
              _products[index].copyWith(isFavorited: isFavorited);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal toggle favorite: $e')),
        );
      }
    }
  }

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
        const SnackBar(
          content: Text('Fitur Transaksi belum tersedia (job Denny)'),
        ),
      );
    } else if (index == 4) {
      // Profil - Navigate ke Settings
      Navigator.pushNamed(context, '/settings');
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
            SizedBox(
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
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppTheme.textPrimary,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur Notifikasi belum tersedia'),
                ),
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
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: AppTheme.textPrimary,
                ),
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
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppTheme.textMuted,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                          color: Colors.white.withValues(alpha: 0.5),
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
              child: _isLoadingCategories
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    )
                  : _categories.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Text(
                              'Kategori tidak tersedia',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                Navigator.pushNamed(
                                  context,
                                  '/search',
                                  arguments: category,
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
                                      categoryIcon(category.icon),
                                      color: AppTheme.primaryGreenDark,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // Label kategori
                                  Text(
                                    category.name,
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
                    onPressed: () {},
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
              child: _isLoadingProducts
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: AppTheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Gagal memuat produk',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadProducts,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryGreen,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : _products.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Text(
                                  'Belum ada produk',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: _products.length,
                              itemBuilder: (context, index) {
                                final product = _products[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/product-detail',
                                      arguments: product.id,
                                    );
                                  },
                                  onToggleFavorite: () =>
                                      _toggleFavorite(product.id, index),
                                );
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

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              color: AppTheme.primaryGreen.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
