/// Checkout totals from GET /checkout/summary (backend source of truth).
class CheckoutSummary {
  const CheckoutSummary({
    required this.cartId,
    required this.currency,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.total,
    required this.itemCount,
    required this.businessCount,
    this.availablePaymentMethods = const [],
  });

  final String cartId;
  final String currency;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double total;
  final int itemCount;
  final int businessCount;
  final List<String> availablePaymentMethods;

  factory CheckoutSummary.fromJson(Map<String, dynamic> json) {
    final methods = json['available_payment_methods'];
    return CheckoutSummary(
      cartId: (json['cart_id'] ?? '') as String,
      currency: (json['currency'] ?? 'SAR') as String,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      itemCount: (json['item_count'] ?? 0) as int,
      businessCount: (json['business_count'] ?? 0) as int,
      availablePaymentMethods: methods is List
          ? methods.map((e) => e.toString()).toList()
          : const [],
    );
  }
}
