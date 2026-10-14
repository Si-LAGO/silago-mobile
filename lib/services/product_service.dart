import 'dart:convert';

import '../models/product_model.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  /// Get products list with optional filters
  /// 
  /// Parameters:
  /// - [page]: Page number (default 1)
  /// - [perPage]: Items per page (default 15)
  /// - [categoryId]: Filter by category ID
  /// - [search]: Search in name and description
  /// - [sort]: Sort order (newest, price_asc, price_desc)
  Future<ProductListResponse> getProducts({
    int page = 1,
    int perPage = 15,
    int? categoryId,
    String? search,
    String? sort,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (sort != null && sort.isNotEmpty) {
        queryParams['sort'] = sort;
      }

      final response = await _apiService.get(
        '/products',
        queryParams: queryParams,
        needsAuth: true, // Endpoint ada di grup auth:sanctum
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProductListResponse.fromJson(data);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Get product detail by ID
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _apiService.get(
        '/products/$id',
        needsAuth: true, // Endpoint ada di grup auth:sanctum
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProductModel.fromJson(data['data']);
      } else if (response.statusCode == 404) {
        throw Exception('Product not found');
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }

  /// Get user's own products (requires auth)
  Future<ProductListResponse> getMyProducts({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      final response = await _apiService.get(
        '/me/products',
        queryParams: queryParams,
        needsAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProductListResponse.fromJson(data);
      } else {
        throw Exception('Failed to load my products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching my products: $e');
    }
  }

  /// Toggle favorite status (requires auth)
  Future<bool> toggleFavorite(int productId) async {
    try {
      final response = await _apiService.post(
        '/products/$productId/favorite',
        needsAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['is_favorited'] ?? false;
      } else {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling favorite: $e');
    }
  }

  /// Get all categories (public endpoint)
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiService.get('/categories');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        return data
            .map((item) => CategoryModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Report a product (requires auth)
  Future<void> reportProduct(
    int productId, {
    required String reason,
    String? description,
  }) async {
    try {
      final body = <String, dynamic>{'reason': reason};
      if (description != null && description.isNotEmpty) {
        body['description'] = description;
      }
      final response = await _apiService.post(
        '/products/$productId/report',
        body: body,
        needsAuth: true,
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to report: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error reporting product: $e');
    }
  }
}

/// Response wrapper for paginated product list
class ProductListResponse {
  final List<ProductModel> products;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  ProductListResponse({
    required this.products,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List;
    final meta = json['meta'];

    return ProductListResponse(
      products: data.map((item) => ProductModel.fromJson(item)).toList(),
      currentPage: meta['current_page'],
      lastPage: meta['last_page'],
      total: meta['total'],
      perPage: meta['per_page'],
    );
  }

  bool get hasMorePages => currentPage < lastPage;
}
