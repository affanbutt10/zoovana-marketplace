/// Cart models matching the real API response shape:
/// GET /cart → data: { id, status, businesses, business_count, item_count,
///   subtotal, discount_amount, tax_amount, total, currency,
///   applied_coupons, expires_at, created_at, updated_at }
class CartBusinessGroup {
  final String businessId;
  final String businessName;
  final List<CartItem> items;
  final double subtotal;

  const CartBusinessGroup({
    required this.businessId,
    required this.businessName,
    required this.items,
    required this.subtotal,
  });

  factory CartBusinessGroup.fromJson(Map<String, dynamic> json) {
    final items = (json['items'] as List? ?? [])
        .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return CartBusinessGroup(
      businessId: (json['business_id'] ?? '') as String,
      businessName: (json['business_name'] ?? '') as String,
      items: items,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CartItem {
  final String id;
  final String productId;
  final String? catalogId;
  final String productName;
  final String productNameAr;
  final double price;
  final int quantity;
  final String imageUrl;
  final int stock;
  final bool isAvailable;

  CartItem({
    required this.id,
    required this.productId,
    this.catalogId,
    required this.productName,
    required this.productNameAr,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.stock,
    this.isAvailable = true,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    // Product name: real API returns product_name_en / product_name_ar
    final productName = (json['product_name_en'] ??
            json['product_name'] ??
            json['name_en'] ??
            json['catalog_product_name'] ??
            json['name'] ??
            json['title'] ??
            '') as String;
    final productNameAr = (json['product_name_ar'] ??
            json['name_ar'] ??
            json['catalog_product_name_ar'] ??
            '') as String;

    // Image: try every known field variant
    final imageUrl = (json['image_url'] ??
            json['primary_image_url'] ??
            json['thumbnail_url'] ??
            json['thumbnail'] ??
            json['image'] ??
            '') as String;

    // Price: real API returns unit_price; fall back to price for compat
    final rawPrice = json['unit_price'] ?? json['price'];
    final price = rawPrice is num
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;

    return CartItem(
      id: json['id'] as String,
      productId: (json['product_id'] ?? json['catalog_product_id'] ?? '') as String,
      catalogId: json['catalog_id'] as String?,
      productName: productName,
      productNameAr: productNameAr,
      price: price,
      quantity: (json['quantity'] ?? 0) as int,
      imageUrl: imageUrl,
      stock: (json['stock'] ?? json['stock_quantity'] ?? 99) as int,
      isAvailable: (json['is_available'] ?? true) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'catalog_id': catalogId,
      'is_available': isAvailable,
      'product_name': productName,
      'product_name_ar': productNameAr,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
      'stock': stock,
    };
  }
}

class Cart {
  final String id;
  final String status;
  final List<CartItem> items;
  final List<CartBusinessGroup> businesses;
  final int itemCount;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double total;
  final String currency;
  final String? promoCode;

  Cart({
    required this.id,
    required this.status,
    required this.items,
    this.businesses = const [],
    required this.itemCount,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.total,
    required this.currency,
    this.promoCode,
  });

  bool get hasUnavailableItems =>
      items.any((item) => !item.isAvailable);

  factory Cart.fromJson(Map<String, dynamic> json) {
    // Items may be nested inside businesses[].items or at top-level items
    final businesses = _extractBusinesses(json);
    final List<CartItem> items = businesses.isNotEmpty
        ? businesses.expand((b) => b.items).toList()
        : _extractItems(json);

    return Cart(
      id: (json['id'] ?? '') as String,
      status: (json['status'] ?? 'active') as String,
      items: items,
      businesses: businesses,
      itemCount: (json['item_count'] ?? items.length) as int,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      currency: (json['currency'] ?? 'SAR') as String,
      promoCode: json['promo_code'] as String?,
    );
  }

  static List<CartBusinessGroup> _extractBusinesses(Map<String, dynamic> json) {
    if (json['businesses'] is! List) return const [];
    return (json['businesses'] as List)
        .map((e) => CartBusinessGroup.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<CartItem> _extractItems(Map<String, dynamic> json) {
    // Flat items list
    if (json['items'] is List) {
      return (json['items'] as List)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    // Items nested inside businesses array
    if (json['businesses'] is List) {
      final result = <CartItem>[];
      for (final biz in json['businesses'] as List) {
        final bizMap = biz as Map<String, dynamic>;
        if (bizMap['items'] is List) {
          result.addAll(
            (bizMap['items'] as List)
                .map((e) => CartItem.fromJson(e as Map<String, dynamic>)),
          );
        }
      }
      return result;
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'items': items.map((item) => item.toJson()).toList(),
      'item_count': itemCount,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'total': total,
      'currency': currency,
      'promo_code': promoCode,
    };
  }
}

class GuestCartItem {
  final String productId;
  final String catalogId;
  final String? variantId;
  final int quantity;
  final DateTime addedAt;

  GuestCartItem({
    required this.productId,
    required this.catalogId,
    this.variantId,
    required this.quantity,
    required this.addedAt,
  });

  factory GuestCartItem.fromJson(Map<String, dynamic> json) {
    final productId = json['product_id'] as String;
    return GuestCartItem(
      productId: productId,
      catalogId: (json['catalog_id'] ?? productId) as String,
      variantId: json['variant_id'] as String?,
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'catalog_id': catalogId,
        if (variantId != null) 'variant_id': variantId,
        'quantity': quantity,
        'added_at': addedAt.toIso8601String(),
      };
}
