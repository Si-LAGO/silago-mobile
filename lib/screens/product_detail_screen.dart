import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();

  ProductModel? _product;
  bool _isLoading = true;
  String? _errorMessage;

  int? _currentImageIndex;

  @override
  void initState() {
    super.initState();
    // productId passed via Navigator arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        _loadProduct(args);
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'ID produk tidak ditemukan.';
        });
      }
    });
  }

  Future<void> _loadProduct(int productId) async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final product = await _productService.getProductById(productId);

      if (mounted) {
        setState(() {
          _product = product;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _toggleFavorite() async {
    if (_product == null) return;
    try {
      final isFavorited =
          await _productService.toggleFavorite(_product!.id);
      if (mounted) {
        setState(() {
          _product = _product!.copyWith(isFavorited: isFavorited);
        });
      }
    } catch (_) {}
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays} hari lalu';
    if (diff.inHours > 0) return '${diff.inHours} jam lalu';
    if (diff.inMinutes > 0) return '${diff.inMinutes} menit lalu';
    return 'Baru saja';
  }

  List<String?> get _imageUrls {
    if (_product?.images != null && _product!.images!.isNotEmpty) {
      return _product!.images!.map((img) => img.url).toList();
    }
    if (_product?.coverImage != null) {
      return [_product!.coverImage];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      body: Stack(
        children: [
          // Scrollable content
          _isLoading || _errorMessage != null
              ? _buildLoadingOrError()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductImage(),
                      _buildProductInfo(),
                      const SizedBox(height: 16),
                      _buildDescription(),
                      const SizedBox(height: 16),
                      _buildSellerInfo(),
                      // Padding bawah dinamis agar tidak mepet tombol CTA
                      SizedBox(
                        height: 110 + MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                ),

          // Bottom Action Buttons
          if (!_isLoading && _errorMessage == null)
            _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildLoadingOrError() {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator(color: AppTheme.primaryGreen)
          : Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppTheme.error),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage ?? 'Gagal memuat produk',
                    style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final args =
                          ModalRoute.of(context)?.settings.arguments;
                      if (args is int) _loadProduct(args);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProductImage() {
    final urls = _imageUrls;
    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          color: AppTheme.greyVeryLight,
          child: urls.isEmpty
              ? const Center(
                  child: Icon(Icons.image_outlined,
                      size: 64, color: AppTheme.textMuted))
              : PageView.builder(
                  itemCount: urls.length,
                  onPageChanged: (index) =>
                      setState(() => _currentImageIndex = index),
                  itemBuilder: (context, index) {
                    return Image.network(
                      urls[index]!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.greyVeryLight,
                        child: const Center(
                          child: Icon(Icons.image_outlined,
                              size: 64, color: AppTheme.textMuted),
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Status Bar Space
        Container(
          height: MediaQuery.of(context).padding.top,
          color: Colors.black.withValues(alpha: 0.3),
        ),

        // Back Button & More Options
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 24),
                ),
              ),
              GestureDetector(
                onTap: () => _showMoreOptions(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.more_vert,
                      color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        ),

        // Image indicator dots
        if (urls.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(urls.length, (i) {
                return Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i == _currentImageIndex
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildProductInfo() {
    final p = _product!;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Title
          Text(
            p.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Price
          Text(
            formatRupiah(p.price),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),

          // Meta Info: category • condition • time ago
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (p.category != null)
                _metaChip(p.category!.name),
              _metaChip(p.condition),
              _metaChip(_timeAgo(p.createdAt)),
              if (p.isNegotiable == true)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Bisa Nego',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metaChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.greyVeryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    final p = _product!;

    // Collect all non-empty description fields
    final sections = <Map<String, String>>[];

    if (p.description != null && p.description!.trim().isNotEmpty) {
      sections.add({'title': 'Deskripsi', 'body': p.description!.trim()});
    }
    if (p.specification != null && p.specification!.trim().isNotEmpty) {
      sections.add({'title': 'Spesifikasi', 'body': p.specification!.trim()});
    }
    if (p.completeness != null && p.completeness!.trim().isNotEmpty) {
      sections.add({
        'title': 'Kelengkapan',
        'body': p.completeness!.trim()
      });
    }
    if (p.sellReason != null && p.sellReason!.trim().isNotEmpty) {
      sections.add({
        'title': 'Alasan Jual',
        'body': p.sellReason!.trim()
      });
    }

    if (sections.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...sections.expand((section) => [
            Text(
              section['title']!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              section['body']!,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ],
      ),
    );
  }

  Widget _buildSellerInfo() {
    final p = _product!;
    final seller = p.seller;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          // Seller Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.greyVeryLight,
            backgroundImage: seller?.profilePhotoUrl != null
                ? NetworkImage(seller!.profilePhotoUrl!)
                : null,
            child: seller?.profilePhotoUrl == null
                ? const Icon(Icons.person, size: 30, color: AppTheme.textMuted)
                : null,
          ),
          const SizedBox(width: 12),

          // Seller Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seller?.name ?? '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  seller?.isVerified == true ? 'Terverifikasi' : 'Penjual SILAGO',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Lihat Profil Button
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Lihat profil',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            // Favorite Button
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: _toggleFavorite,
                icon: Icon(
                  _product?.isFavorited == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: _product?.isFavorited == true
                      ? Colors.red
                      : AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Buttons Column
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fitur chat belum tersedia (job Rosa)',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Chat Penjual',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Fitur tawar belum tersedia (job Denny)',
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryGreen),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Ajukan Penawaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.share, color: AppTheme.textPrimary),
                title: const Text('Bagikan'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur bagikan')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag, color: AppTheme.error),
                title: const Text('Laporkan', style: TextStyle(color: AppTheme.error)),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showReportDialog() {
    final reasonController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Laporkan Produk'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Alasan',
                  hintText: 'Contoh: Produk palsu',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Keterangan',
                  hintText: 'Jelaskan detail laporan...',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_product == null) return;
                final reason = reasonController.text.trim();
                final desc = descController.text.trim();
                if (reason.isEmpty) return;
                Navigator.pop(context);
                try {
                  await _productService.reportProduct(
                    _product!.id,
                    reason: reason,
                    description: desc,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Laporan berhasil dibuat')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );
  }
}
