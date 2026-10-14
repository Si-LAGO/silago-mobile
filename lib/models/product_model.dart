class ProductModel {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String status;
  final String verificationStatus;
  final String condition;
  final String? coverImage;
  final DateTime createdAt;
  final SellerModel? seller;
  final CategoryModel? category;
  final bool isFavorited;

  // Optional detail fields
  final String? description;
  final String? specification;
  final String? completeness;
  final String? sellReason;
  final bool? isNegotiable;
  final List<ProductImageModel>? images;
  final DateTime? expiresAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.status,
    required this.verificationStatus,
    required this.condition,
    this.coverImage,
    required this.createdAt,
    this.seller,
    this.category,
    this.isFavorited = false,
    this.description,
    this.specification,
    this.completeness,
    this.sellReason,
    this.isNegotiable,
    this.images,
    this.expiresAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      stock: json['stock'],
      status: json['status'],
      verificationStatus: json['verification_status'],
      condition: json['condition'],
      coverImage: json['cover_image'],
      createdAt: DateTime.parse(json['created_at']),
      seller: json['seller'] != null
          ? SellerModel.fromJson(json['seller'])
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      isFavorited: json['is_favorited'] ?? false,
      description: json['description'],
      specification: json['specification'],
      completeness: json['completeness'],
      sellReason: json['sell_reason'],
      isNegotiable: json['is_negotiable'],
      images: json['images'] != null
          ? (json['images'] as List)
              .map((img) => ProductImageModel.fromJson(img))
              .toList()
          : null,
      expiresAt:
          json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      updatedAt:
          json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'status': status,
      'verification_status': verificationStatus,
      'condition': condition,
      'cover_image': coverImage,
      'created_at': createdAt.toIso8601String(),
      'seller': seller?.toJson(),
      'category': category?.toJson(),
      'is_favorited': isFavorited,
      'description': description,
      'specification': specification,
      'completeness': completeness,
      'sell_reason': sellReason,
      'is_negotiable': isNegotiable,
      'images': images?.map((img) => img.toJson()).toList(),
      'expires_at': expiresAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    double? price,
    int? stock,
    String? status,
    String? verificationStatus,
    String? condition,
    String? coverImage,
    DateTime? createdAt,
    SellerModel? seller,
    CategoryModel? category,
    bool? isFavorited,
    String? description,
    String? specification,
    String? completeness,
    String? sellReason,
    bool? isNegotiable,
    List<ProductImageModel>? images,
    DateTime? expiresAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      status: status ?? this.status,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      condition: condition ?? this.condition,
      coverImage: coverImage ?? this.coverImage,
      createdAt: createdAt ?? this.createdAt,
      seller: seller ?? this.seller,
      category: category ?? this.category,
      isFavorited: isFavorited ?? this.isFavorited,
      description: description ?? this.description,
      specification: specification ?? this.specification,
      completeness: completeness ?? this.completeness,
      sellReason: sellReason ?? this.sellReason,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      images: images ?? this.images,
      expiresAt: expiresAt ?? this.expiresAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class SellerModel {
  final int id;
  final String name;
  final String? profilePhotoUrl;
  final bool? isVerified;

  SellerModel({
    required this.id,
    required this.name,
    this.profilePhotoUrl,
    this.isVerified,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['id'],
      name: json['name'],
      profilePhotoUrl: json['profile_photo_url'],
      isVerified: json['is_verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_photo_url': profilePhotoUrl,
      'is_verified': isVerified,
    };
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final String? icon;
  final int productsCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.productsCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      icon: json['icon'],
      productsCount: json['products_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon': icon,
      'products_count': productsCount,
    };
  }
}

class ProductImageModel {
  final int id;
  final String url;
  final int sortOrder;

  ProductImageModel({
    required this.id,
    required this.url,
    required this.sortOrder,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'],
      url: json['url'],
      sortOrder: json['sort_order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'sort_order': sortOrder,
    };
  }
}
