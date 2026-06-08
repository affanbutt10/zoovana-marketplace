/// Receipt models matching the real API response shape:
/// GET /my/receipts/order/{orderId} → data: { id, receipt_number, order_id,
///   order_number, client_name, status, subtotal, discount_amount, tax_amount,
///   shipping_total, total_amount, currency, payment_method, paid_at,
///   total_item_count, receipt_date, all_items: [{ items: [...], ... }], ... }
class ReceiptItem {
  final String productId;
  final String productName;
  final String productNameAr;
  final String? variantNameEn;
  final String? sku;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String imageUrl;
  final String currency;

  ReceiptItem({
    required this.productId,
    required this.productName,
    this.productNameAr = '',
    this.variantNameEn,
    this.sku,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.imageUrl = '',
    this.currency = 'SAR',
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    // Real API returns product_name_en and line_total
    final rawUnit = json['unit_price'];
    final unitPrice = rawUnit is num
        ? rawUnit.toDouble()
        : double.tryParse(rawUnit?.toString() ?? '0') ?? 0.0;

    final rawTotal = json['line_total'] ?? json['total_price'];
    final totalPrice = rawTotal is num
        ? rawTotal.toDouble()
        : double.tryParse(rawTotal?.toString() ?? '0') ?? 0.0;

    return ReceiptItem(
      productId: _string(json['product_id']),
      productName: _string(
        json['product_name_en'] ?? json['product_name'] ?? json['name_en'],
      ),
      productNameAr: _string(json['product_name_ar']),
      variantNameEn: _nullableString(json['variant_name_en']),
      sku: _nullableString(json['sku']),
      quantity: _int(json['quantity']),
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      imageUrl: _string(json['image_url']),
      currency: _string(json['currency'], fallback: 'SAR'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name_en': productName,
      'product_name_ar': productNameAr,
      'variant_name_en': variantNameEn,
      'sku': sku,
      'quantity': quantity,
      'unit_price': unitPrice,
      'line_total': totalPrice,
      'image_url': imageUrl,
      'currency': currency,
    };
  }
}

String _string(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  final text = value.toString();
  return text.isEmpty ? fallback : text;
}

String? _nullableString(dynamic value) {
  if (value == null) return null;
  final text = value.toString();
  return text.isEmpty ? null : text;
}

int _int(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _double(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}

class ReceiptBusinessGroup {
  final String businessId;
  final String businessName;
  final String? businessLogoUrl;
  final String branchName;
  final String? branchPhone;
  final double subtotal;
  final int itemCount;
  final List<ReceiptItem> items;

  ReceiptBusinessGroup({
    required this.businessId,
    required this.businessName,
    this.businessLogoUrl,
    required this.branchName,
    this.branchPhone,
    required this.subtotal,
    required this.itemCount,
    required this.items,
  });

  factory ReceiptBusinessGroup.fromJson(Map<String, dynamic> json) {
    return ReceiptBusinessGroup(
      businessId: _string(json['business_id']),
      businessName: _string(json['business_name'], fallback: 'Seller'),
      businessLogoUrl: _nullableString(json['business_logo_url']),
      branchName: _string(json['branch_name']),
      branchPhone: _nullableString(json['branch_phone']),
      subtotal: _double(json['subtotal']),
      itemCount: _int(json['item_count']),
      items: (json['items'] as List? ?? [])
          .whereType<Map>()
          .map((e) => ReceiptItem.fromJson(e.map((k, v) => MapEntry('$k', v))))
          .toList(),
    );
  }
}

class Receipt {
  final String id;

  /// receipt_number from the API (e.g. "RCP-260520-00003")
  final String number;
  final String orderId;
  final String orderNumber;
  final DateTime date;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double shippingTotal;
  final double total;
  final String currency;
  final String paymentMethod;
  final String? paymentReference;
  final String status;
  final String? clientName;
  final String? clientEmail;
  final String? clientPhone;
  final String? platformName;
  final String? pdfUrl;

  /// Flat list of all items across all businesses (convenience accessor)
  final List<ReceiptItem> items;

  /// Items grouped by business/branch
  final List<ReceiptBusinessGroup> businessGroups;

  Receipt({
    required this.id,
    required this.number,
    this.orderId = '',
    this.orderNumber = '',
    required this.date,
    this.subtotal = 0.0,
    this.discountAmount = 0.0,
    this.taxAmount = 0.0,
    this.shippingTotal = 0.0,
    required this.total,
    this.currency = 'SAR',
    this.paymentMethod = '',
    this.paymentReference,
    this.status = 'issued',
    this.clientName,
    this.clientEmail,
    this.clientPhone,
    this.platformName,
    this.pdfUrl,
    required this.items,
    this.businessGroups = const [],
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    // Real API: receipt_number, receipt_date, total_amount
    final number = _string(
      json['receipt_number'] ?? json['number'] ?? json['id'],
    );

    DateTime date;
    if (json['receipt_date'] != null) {
      // receipt_date is "2026-05-20" (date only)
      date =
          DateTime.tryParse(json['receipt_date'].toString()) ??
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now();
    } else if (json['date'] != null) {
      date = DateTime.tryParse(json['date'].toString()) ?? DateTime.now();
    } else if (json['created_at'] != null) {
      date = DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }

    final total = _double(json['total_amount'] ?? json['total']);

    // Items are nested under all_items[].items in the real API
    final allItemsRaw = json['all_items'] as List?;
    final List<ReceiptItem> items;
    final List<ReceiptBusinessGroup> businessGroups;

    if (allItemsRaw != null && allItemsRaw.isNotEmpty) {
      businessGroups = allItemsRaw
          .whereType<Map>()
          .map(
            (e) => ReceiptBusinessGroup.fromJson(
              e.map((k, v) => MapEntry('$k', v)),
            ),
          )
          .toList();
      items = businessGroups.expand((g) => g.items).toList();
    } else if (json['items'] is List) {
      // Fallback: flat items list (mock data / older shape)
      items = (json['items'] as List)
          .whereType<Map>()
          .map((e) => ReceiptItem.fromJson(e.map((k, v) => MapEntry('$k', v))))
          .toList();
      businessGroups = const [];
    } else {
      items = const [];
      businessGroups = const [];
    }

    return Receipt(
      id: _string(json['id']),
      number: number,
      orderId: _string(json['order_id']),
      orderNumber: _string(json['order_number']),
      date: date,
      subtotal: _double(json['subtotal']),
      discountAmount: _double(json['discount_amount']),
      taxAmount: _double(json['tax_amount']),
      shippingTotal: _double(json['shipping_total']),
      total: total,
      currency: _string(json['currency'], fallback: 'SAR'),
      paymentMethod: _string(json['payment_method']),
      paymentReference: _nullableString(json['payment_reference']),
      status: _string(json['status'], fallback: 'issued'),
      clientName: _nullableString(json['client_name']),
      clientEmail: _nullableString(json['client_email']),
      clientPhone: _nullableString(json['client_phone']),
      platformName: _nullableString(json['platform_name']),
      pdfUrl: _nullableString(json['pdf_url']),
      items: items,
      businessGroups: businessGroups,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receipt_number': number,
      'order_id': orderId,
      'order_number': orderNumber,
      'receipt_date': date.toIso8601String().split('T').first,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'shipping_total': shippingTotal,
      'total_amount': total,
      'currency': currency,
      'payment_method': paymentMethod,
      'payment_reference': paymentReference,
      'status': status,
      'client_name': clientName,
      'client_email': clientEmail,
      'client_phone': clientPhone,
      'platform_name': platformName,
      'pdf_url': pdfUrl,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
