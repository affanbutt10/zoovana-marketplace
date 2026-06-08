/// Order models matching the real API response shape:
/// GET /orders → data: { items: [], pagination: { page, page_size,
///   total_items, total_pages } }
class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String productNameAr;
  final int quantity;
  final double price;
  final double lineTotal;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productNameAr,
    required this.quantity,
    required this.price,
    required this.lineTotal,
    required this.imageUrl,
  });

  double get displayLineTotal =>
      lineTotal > 0 ? lineTotal : price * quantity;

  static double _parseAmount(dynamic raw) {
    if (raw == null) return 0.0;
    if (raw is num) {
      final v = raw.toDouble();
      return v.isNaN || v.isInfinite ? 0.0 : v;
    }
    final parsed = double.tryParse(raw.toString());
    if (parsed == null || parsed.isNaN || parsed.isInfinite) return 0.0;
    return parsed;
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final quantity = (json['quantity'] as num?)?.toInt() ?? 0;
    var price = _parseAmount(json['unit_price'] ?? json['price']);
    final lineTotal = _parseAmount(json['line_total']);
    if (price <= 0 && lineTotal > 0 && quantity > 0) {
      price = lineTotal / quantity;
    }

    return OrderItem(
      id: (json['id'] ?? '') as String,
      productId: (json['product_id'] ?? json['catalog_product_id'] ?? '') as String,
      productName: (json['product_name_en'] ??
              json['product_name'] ??
              json['name_en'] ??
              json['name'] ??
              '') as String,
      productNameAr: (json['product_name_ar'] ?? json['name_ar'] ?? '') as String,
      quantity: quantity,
      price: price,
      lineTotal: lineTotal,
      imageUrl: (json['image_url'] ?? json['primary_image_url'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name_en': productName,
      'product_name_ar': productNameAr,
      'quantity': quantity,
      'unit_price': price,
      'line_total': lineTotal,
      'image_url': imageUrl,
    };
  }
}

class SubOrder {
  final String id;
  final String subOrderNumber;
  final String sellerName;
  final String branchName;
  final List<OrderItem> items;
  final double subtotal;
  final String status;
  final String fulfillmentStatus;

  SubOrder({
    required this.id,
    this.subOrderNumber = '',
    required this.sellerName,
    this.branchName = '',
    required this.items,
    required this.subtotal,
    this.status = '',
    this.fulfillmentStatus = '',
  });

  factory SubOrder.fromJson(Map<String, dynamic> json) {
    // Real API returns branch_name (not seller_name)
    final sellerName = (json['business_name'] ??
            json['branch_name'] ??
            json['seller_name'] ??
            '') as String;

    return SubOrder(
      id: (json['id'] ?? '') as String,
      subOrderNumber: (json['sub_order_number'] ?? '') as String,
      sellerName: sellerName,
      branchName: (json['branch_name'] ?? '') as String,
      items: (json['items'] as List? ?? [])
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      status: (json['status'] ?? '') as String,
      fulfillmentStatus: (json['fulfillment_status'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sub_order_number': subOrderNumber,
      'business_name': sellerName,
      'branch_name': branchName,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'status': status,
      'fulfillment_status': fulfillmentStatus,
    };
  }
}

class TrackingEvent {
  final String status;
  final String description;
  final DateTime timestamp;

  TrackingEvent({
    required this.status,
    required this.description,
    required this.timestamp,
  });

  factory TrackingEvent.fromJson(Map<String, dynamic> json) {
    return TrackingEvent(
      status: (json['status'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class OrderShippingAddress {
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String city;
  final String country;

  const OrderShippingAddress({
    this.fullName = '',
    this.phoneNumber = '',
    this.addressLine1 = '',
    this.city = '',
    this.country = 'SA',
  });

  factory OrderShippingAddress.fromJson(Map<String, dynamic> json) {
    return OrderShippingAddress(
      fullName: (json['full_name'] ?? '') as String,
      phoneNumber: (json['phone_number'] ?? '') as String,
      addressLine1: (json['address_line_1'] ?? '') as String,
      city: (json['city'] ?? '') as String,
      country: (json['country'] ?? 'SA') as String,
    );
  }
}

class Order {
  final String id;
  final String orderNumber;
  final DateTime placedAt;
  final String status;
  final String paymentStatus;
  final String paymentMethod;
  final double subtotal;
  final double taxAmount;
  final double shippingCost;
  final double total;
  final String currency;
  final int itemCount;
  final List<SubOrder> subOrders;
  final OrderShippingAddress? shippingAddress;
  final String? receiptId;

  Order({
    required this.id,
    this.orderNumber = '',
    required this.placedAt,
    required this.status,
    this.paymentStatus = '',
    this.paymentMethod = '',
    this.subtotal = 0,
    this.taxAmount = 0,
    this.shippingCost = 0,
    required this.total,
    required this.currency,
    this.itemCount = 0,
    required this.subOrders,
    this.shippingAddress,
    this.receiptId,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    double parseAmount(dynamic raw) {
      if (raw == null) return 0.0;
      if (raw is num) {
        final v = raw.toDouble();
        return v.isNaN || v.isInfinite ? 0.0 : v;
      }
      final parsed = double.tryParse(raw.toString());
      if (parsed == null || parsed.isNaN || parsed.isInfinite) return 0.0;
      return parsed;
    }

    final rawTotal = json['total_amount'] ?? json['total'];
    final total = parseAmount(rawTotal);

    // Real API returns created_at (not placed_at)
    DateTime placedAt;
    if (json['created_at'] != null) {
      placedAt = DateTime.parse(json['created_at'] as String);
    } else if (json['placed_at'] != null) {
      placedAt = DateTime.parse(json['placed_at'] as String);
    } else {
      placedAt = DateTime.now();
    }

    final receipt = json['receipt'] as Map<String, dynamic>?;

    return Order(
      id: (json['id'] ?? '') as String,
      orderNumber: (json['order_number'] ?? '') as String,
      placedAt: placedAt,
      status: (json['status'] ?? 'pending') as String,
      paymentStatus: (json['payment_status'] ?? '') as String,
      paymentMethod: (json['payment_method'] ?? '') as String,
      subtotal: parseAmount(json['subtotal']),
      taxAmount: parseAmount(json['tax_amount']),
      shippingCost: parseAmount(json['shipping_cost']),
      total: total,
      currency: (json['currency'] ?? 'SAR') as String,
      itemCount: (json['item_count'] ?? 0) as int,
      subOrders: (json['sub_orders'] as List? ?? [])
          .map((e) => SubOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: json['shipping_address'] is Map<String, dynamic>
          ? OrderShippingAddress.fromJson(
              json['shipping_address'] as Map<String, dynamic>,
            )
          : null,
      receiptId: receipt?['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'created_at': placedAt.toIso8601String(),
      'status': status,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'shipping_cost': shippingCost,
      'total_amount': total,
      'currency': currency,
      'item_count': itemCount,
      'sub_orders': subOrders.map((e) => e.toJson()).toList(),
    };
  }
}

/// Pagination metadata returned by list endpoints.
class PaginationMeta {
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationMeta({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: (json['page'] ?? 1) as int,
      pageSize: (json['page_size'] ?? 12) as int,
      totalItems: (json['total_items'] ?? json['total'] ?? 0) as int,
      totalPages: (json['total_pages'] ?? 0) as int,
      hasNext: (json['has_next'] ?? false) as bool,
      hasPrev: (json['has_prev'] ?? false) as bool,
    );
  }
}
