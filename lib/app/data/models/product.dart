/// Product model matching the real API response shape:
/// GET /catalog/products → data: [ { id, name_en, name_ar, description_en,
///   description_ar, price, compare_at_price, primary_image_url, image_urls,
///   catalog_id, category.slug, is_in_stock, stock_quantity, is_active,
///   is_featured, created_at, ... } ]
class Product {
  final String id;
  /// The catalog entry ID — used as the `catalog_id` field when adding to cart.
  final String catalogId;
  /// Marketplace variant ID — required by POST /cart/items as `variant_id`.
  final String? variantId;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final double? compareAtPrice;
  final String imageUrl;
  final List<String> imageUrls;
  final String categoryId;
  final String categorySlug;
  final int stock;
  final bool isInStock;
  final bool isActive;
  final bool isFeatured;
  final String? sku;
  final String? currency;
  final String? businessName;
  final String? branchNameEn;
  final DateTime createdAt;

  Product({
    required this.id,
    String? catalogId,
    this.variantId,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    this.compareAtPrice,
    required this.imageUrl,
    required this.imageUrls,
    required this.categoryId,
    required this.categorySlug,
    required this.stock,
    required this.isInStock,
    required this.isActive,
    required this.isFeatured,
    this.sku,
    this.currency,
    this.businessName,
    this.branchNameEn,
    required this.createdAt,
  }) : catalogId = catalogId ?? id;

  /// True when the product cannot be purchased (inactive or no stock).
  bool get isOutOfStock => !isActive || !isInStock || stock <= 0;

  bool get canAddToCart => !isOutOfStock;

  factory Product.fromJson(Map<String, dynamic> json) {
    // Category can be an embedded object or flat fields
    final category = json['category'] as Map<String, dynamic>?;
    final categoryId =
        (category?['id'] ?? json['catalog_id'] ?? json['category_id'] ?? '')
            as String;
    final categorySlug =
        (category?['slug'] ?? json['category_slug'] ?? '') as String;

    // catalog_id is the catalog entry identifier used for add-to-cart
    final catalogId = (json['catalog_id'] ?? json['id'] ?? '') as String;

    // Image: prefer primary_image_url, fall back to image_url
    final primaryImage =
        (json['primary_image_url'] ?? json['image_url'] ?? '') as String;

    final imageUrls = (json['image_urls'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        (primaryImage.isNotEmpty ? [primaryImage] : <String>[]);

    // Price: API returns a string like "80.00"
    final rawPrice = json['price'];
    final price = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;

    final rawCompare = json['compare_at_price'];
    final compareAtPrice = rawCompare == null
        ? null
        : rawCompare is num
            ? rawCompare.toDouble()
            : double.tryParse(rawCompare.toString());

    return Product(
      id: json['id'] as String,
      catalogId: catalogId,
      variantId: (json['shops_variant_id'] ?? json['variant_id']) as String?,
      name: (json['name_en'] ?? json['name'] ?? '') as String,
      nameAr: (json['name_ar'] ?? '') as String,
      description: (json['description_en'] ?? json['description'] ?? '') as String,
      descriptionAr: (json['description_ar'] ?? '') as String,
      price: price,
      compareAtPrice: compareAtPrice,
      imageUrl: primaryImage,
      imageUrls: imageUrls,
      categoryId: categoryId,
      categorySlug: categorySlug,
      stock: (json['stock_quantity'] ?? json['stock'] ?? 0) as int,
      isInStock: (json['is_in_stock'] ?? true) as bool,
      isActive: (json['is_active'] ?? true) as bool,
      isFeatured: (json['is_featured'] ?? false) as bool,
      sku: json['sku'] as String?,
      currency: (json['currency'] ?? 'SAR') as String,
      businessName: json['business_name'] as String?,
      branchNameEn: json['branch_name_en'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'catalog_id': catalogId,
      if (variantId != null) 'shops_variant_id': variantId,
      'name_en': name,
      'name_ar': nameAr,
      'description_en': description,
      'description_ar': descriptionAr,
      'price': price.toString(),
      'compare_at_price': compareAtPrice?.toString(),
      'primary_image_url': imageUrl,
      'image_urls': imageUrls,
      'category_id': categoryId,
      'category_slug': categorySlug,
      'stock_quantity': stock,
      'is_in_stock': isInStock,
      'is_active': isActive,
      'is_featured': isFeatured,
      'sku': sku,
      'currency': currency,
      'business_name': businessName,
      'branch_name_en': branchNameEn,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
