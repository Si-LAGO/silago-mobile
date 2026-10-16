import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  /// Optional category passed from Home (category tap).
  final CategoryModel? initialCategory;

  const SearchScreen({super.key, this.initialCategory});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ProductService _productService = ProductService();

  // Categories from API (used as quick chips)
  List<CategoryModel> _categories = [];

  // Search results from API
  List<ProductModel> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Selected filters
  CategoryModel? _selectedCategory;
  String _sort = 'newest';

  // Recent searches (real, in-memory history of performed searches)
  final List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _loadCategories();
    if (widget.initialCategory != null) {
      _performSearch('');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _productService.getCategories();
      if (mounted) setState(() => _categories = categories);
    } catch (_) {
      // Diamkan; kategori hanya pelengkap
    }
  }

  Future<void> _performSearch(String query) async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isSearching = true;
      _isLoading = true;
      _errorMessage = null;
    });

    if (query.trim().isNotEmpty) {
      final q = query.trim();
      _recentSearches.remove(q);
      _recentSearches.insert(0, q);
      if (_recentSearches.length > 8) _recentSearches.removeLast();
    }

    try {
      final response = await _productService.getProducts(
        page: 1,
        perPage: 30,
        search: query.trim().isEmpty ? null : query.trim(),
        categoryId: _selectedCategory?.id,
        sort: _sort,
      );

      if (mounted) {
        setState(() {
          _searchResults = response.products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _isSearching = false;
      _searchResults = [];
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.creamBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildSearchBar(),
        titleSpacing: 0,
      ),
      body: _isSearching ? _buildSearchResults() : _buildSearchHome(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: AppTheme.creamBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: widget.initialCategory == null,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.textSecondary,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) => setState(() {}),
        onSubmitted: _performSearch,
      ),
    );
  }

  Widget _buildSearchHome() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Recent Searches (real history)
          if (_recentSearches.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pencarian Terakhir',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _recentSearches.clear());
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Hapus semua',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentSearches.length,
              itemBuilder: (context, index) {
                final search = _recentSearches[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.history,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                  title: Text(
                    search,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppTheme.textSecondary,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() => _recentSearches.removeAt(index));
                    },
                  ),
                  onTap: () {
                    _searchController.text = search;
                    _performSearch(search);
                  },
                );
              },
            ),
            const SizedBox(height: 24),
          ],

          // Categories from API
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Jelajahi Kategori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_categories.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Kategori tidak tersedia',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                        _searchController.clear();
                      });
                      _performSearch('');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            categoryIcon(category.icon),
                            size: 16,
                            color: AppTheme.primaryGreenDark,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        // Filter & Sort Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: _buildFilterButton(
                  icon: Icons.tune,
                  label: _selectedCategory?.name ?? 'Filter',
                  onTap: () => _showFilterSheet(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterButton(
                  icon: Icons.sort,
                  label: _sortLabel(_sort),
                  onTap: () => _showSortSheet(context),
                ),
              ),
            ],
          ),
        ),

        // Result Count
        Container(
          padding: const EdgeInsets.all(16),
          color: AppTheme.creamBackground,
          alignment: Alignment.centerLeft,
          child: Text(
            _isLoading
                ? 'Mencari produk...'
                : '${_searchResults.length} produk ditemukan',
            style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
          ),
        ),

        // Results
        Expanded(child: _buildResultsBody()),
      ],
    );
  }

  Widget _buildResultsBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryGreen),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
              const SizedBox(height: 16),
              const Text(
                'Gagal memuat produk',
                style: TextStyle(
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
                onPressed: () => _performSearch(_searchController.text),
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

    if (_searchResults.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Produk tidak ditemukan',
            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final product = _searchResults[index];
        return ProductCard(
          product: product,
          onTap: () {
            Navigator.pushNamed(
              context,
              '/product-detail',
              arguments: product.id,
            );
          },
        );
      },
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.creamBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppTheme.textPrimary),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _sortLabel(String sort) {
    switch (sort) {
      case 'price_asc':
        return 'Harga Terendah';
      case 'price_desc':
        return 'Harga Tertinggi';
      default:
        return 'Terbaru';
    }
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                if (_categories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Kategori tidak tersedia',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChip(
                        label: 'Semua',
                        selected: _selectedCategory == null,
                        onTap: () {
                          setState(() => _selectedCategory = null);
                          Navigator.pop(context);
                          _performSearch(_searchController.text);
                        },
                      ),
                      ..._categories.map(
                        (category) => _buildFilterChip(
                          label: category.name,
                          selected: _selectedCategory?.id == category.id,
                          onTap: () {
                            setState(() => _selectedCategory = category);
                            Navigator.pop(context);
                            _performSearch(_searchController.text);
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryGreen : AppTheme.creamBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppTheme.primaryGreen : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Urutkan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSortOption('Terbaru', 'newest'),
                _buildSortOption('Harga Terendah', 'price_asc'),
                _buildSortOption('Harga Tertinggi', 'price_desc'),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
      ),
      trailing: _sort == value
          ? const Icon(Icons.check, color: AppTheme.primaryGreen)
          : null,
      onTap: () {
        setState(() => _sort = value);
        Navigator.pop(context);
        _performSearch(_searchController.text);
      },
    );
  }
}
