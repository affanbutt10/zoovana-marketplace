import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../core/api/response_parser.dart';
import '../../app/data/models/cart.dart';

class CartService {
  // Cart lives on marketDio (zoovana-marketplace.vercel.app/api/market)
  final Dio _dio = ApiClient().marketDio;

  /// GET /cart
  /// Response: { success, data: { id, status, businesses, item_count,
  ///   subtotal, discount_amount, tax_amount, total, currency, ... } }
  Future<Cart> getCart() async {
    final response = await _dio.get(ApiEndpoints.cartPath);
    return Cart.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['data', 'cart'],
      ),
    );
  }

  /// Adds an item to the cart.
  ///
  /// [catalogId] — the catalog entry ID (catalog_id in the API).
  /// [productId] — the product ID (product_id in the API).
  /// [variantId] — optional variant ID.
  Future<void> addToCart(
    String productId,
    int quantity, {
    required String catalogId,
    String? variantId,
  }) async {
    final payload = <String, dynamic>{
      'catalog_id': catalogId,
      'product_id': productId,
      'quantity': quantity.clamp(1, 100),
    };
    if (variantId != null && variantId.isNotEmpty) {
      payload['variant_id'] = variantId;
    }
    await _dio.post(ApiEndpoints.cartItemsPath, data: payload);
  }

  Future<void> bulkAddItems(List<Map<String, dynamic>> items) async {
    await _dio.post(ApiEndpoints.cartItemsBulkPath, data: {'items': items});
  }

  Future<void> updateCartItem(String itemId, int quantity) async {
    await _dio.patch(
      ApiEndpoints.cartItemById(itemId),
      data: {'quantity': quantity},
    );
  }

  Future<void> removeFromCart(String itemId) async {
    await _dio.delete(ApiEndpoints.cartItemById(itemId));
  }

  Future<void> clearCart() async {
    await _dio.delete(ApiEndpoints.cartPath);
  }

  /// GET /cart/validate — checks items before checkout.
  Future<Map<String, dynamic>> validateCart() async {
    final response = await _dio.get(ApiEndpoints.cartValidatePath);
    return ResponseParser.extractMap(response.data);
  }

  /// GET /cart/summary — lightweight totals for badges.
  Future<Map<String, dynamic>> getCartSummary() async {
    final response = await _dio.get(ApiEndpoints.cartSummaryPath);
    return ResponseParser.extractMap(response.data);
  }

  /// Applies a coupon to the cart. Returns discount info from the server.
  Future<Map<String, dynamic>> applyPromoCode(String code) async {
    final response = await _dio.post(
      ApiEndpoints.cartPromoPath,
      data: {'coupon_code': code},
    );
    return ResponseParser.extractMap(response.data);
  }

  Future<void> removePromoCode() async {
    await _dio.delete(ApiEndpoints.cartPromoPath);
  }

  Future<Map<String, dynamic>> getCartTotals() async {
    final response = await _dio.get(ApiEndpoints.cartTotalsPath);
    return ResponseParser.extractMap(response.data);
  }

  Future<List<Map<String, dynamic>>> getShippingOptions() async {
    final response = await _dio.get(ApiEndpoints.cartShippingOptionsPath);
    return ResponseParser.extractList(response.data);
  }

  /// Syncs guest cart items to the server cart after login.
  Future<void> syncCart(List<Map<String, dynamic>> guestItems) async {
    await _dio.post(ApiEndpoints.cartSyncPath, data: {'items': guestItems});
  }
}
