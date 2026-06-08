import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apis/services/cart_service.dart';
import '../../../apis/services/cart_sync_service.dart';
import '../../core/services/cache_service.dart';
import '../models/cart.dart';

const guestCartKey = 'zoovana_guest_cart';
const cartCacheKey = 'zoovana_cached_cart';

class CartRepositorySnapshot {
  const CartRepositorySnapshot({
    this.cart,
    this.isLoading = false,
    this.error,
    this.guestItems = const [],
  });

  final Cart? cart;
  final bool isLoading;
  final Object? error;
  final List<GuestCartItem> guestItems;

  int get itemCount {
    final remoteCount =
        cart?.items.fold<int>(0, (sum, item) => sum + item.quantity) ?? 0;
    if (remoteCount > 0) {
      return remoteCount;
    }
    return guestItems.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  CartRepositorySnapshot copyWith({
    Cart? cart,
    bool? isLoading,
    Object? error,
    List<GuestCartItem>? guestItems,
    bool clearError = false,
  }) {
    return CartRepositorySnapshot(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      guestItems: guestItems ?? this.guestItems,
    );
  }
}

class CartRepository extends ChangeNotifier {
  CartRepository({
    required this.service,
    required this.prefs,
    this.cacheService,
  }) {
    _restoreGuestCart();
  }

  final CartService service;
  final SharedPreferences prefs;
  final CacheService? cacheService;

  CartRepositorySnapshot _snapshot = const CartRepositorySnapshot();

  CartRepositorySnapshot get snapshot => _snapshot;

  Future<void> loadCart() async {
    _snapshot = _snapshot.copyWith(isLoading: true, clearError: true);
    notifyListeners();
    try {
      final cart = await service.getCart();
      await cacheService?.writeJson(cartCacheKey, cart.toJson());
      _snapshot = _snapshot.copyWith(
        cart: cart,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      final cached = cacheService?.readJsonMap(cartCacheKey);
      _snapshot = _snapshot.copyWith(
        isLoading: false,
        cart: cached != null ? Cart.fromJson(cached) : _snapshot.cart,
        error: error,
      );
    }
    notifyListeners();
  }

  Future<Cart?> getCart() async {
    await loadCart();
    return _snapshot.cart;
  }

  Future<void> addToCart(
    String productId,
    int quantity, {
    required String catalogId,
    String? variantId,
  }) async {
    await service.addToCart(
      productId,
      quantity,
      catalogId: catalogId,
      variantId: variantId,
    );
    await loadCart();
  }

  Future<Map<String, dynamic>> validateCart() {
    return service.validateCart();
  }

  /// Immediately reflect an added item in the repository snapshot so UI
  /// components (badges, cart screen) feel responsive. The real server
  /// state will be reconciled after `addToCart` completes and `loadCart` runs.
  void optimisticAddToCart(String productId, int quantity) {
    // If server cart exists, append a temporary cart item to it.
    if (_snapshot.cart != null) {
      final existing = _snapshot.cart!;
      final tempId = 'temp-$productId-${DateTime.now().millisecondsSinceEpoch}';
      final tempItem = CartItem(
        id: tempId,
        productId: productId,
        productName: '',
        productNameAr: '',
        price: 0.0,
        quantity: quantity,
        imageUrl: '',
        stock: 99,
      );
      final items = [...existing.items, tempItem];
      final newItemCount = existing.itemCount + quantity;
      final newCart = Cart(
        id: existing.id,
        status: existing.status,
        items: items,
        itemCount: newItemCount,
        subtotal: existing.subtotal,
        discountAmount: existing.discountAmount,
        taxAmount: existing.taxAmount,
        total: existing.total,
        currency: existing.currency,
        promoCode: existing.promoCode,
      );
      _snapshot = _snapshot.copyWith(cart: newCart);
      notifyListeners();
      return;
    }

    // No server cart — add to guest cart (this persists and notifies).
    // We don't await here to keep UI snappy; callers can still await addToGuestCart
    // when needed.
    addToGuestCart(productId, quantity, catalogId: productId);
  }

  Future<void> bulkAddToCart(List<Map<String, dynamic>> items) async {
    await service.bulkAddItems(items);
    await loadCart();
  }

  Future<void> updateCartItem(String itemId, int quantity) async {
    await service.updateCartItem(itemId, quantity);
    await loadCart();
  }

  Future<void> removeFromCart(String itemId) async {
    await service.removeFromCart(itemId);
    await loadCart();
  }

  Future<void> clearCart() async {
    await service.clearCart();
    await loadCart();
  }

  Future<Map<String, dynamic>> applyPromoCode(String code) async {
    final result = await service.applyPromoCode(code);
    await loadCart();
    return result;
  }

  Future<void> removePromoCode() async {
    await service.removePromoCode();
    await loadCart();
  }

  Future<Map<String, dynamic>> getCartTotals() async {
    return service.getCartTotals();
  }

  Future<List<Map<String, dynamic>>> getShippingOptions() async {
    return service.getShippingOptions();
  }

  Future<void> addToGuestCart(
    String productId,
    int quantity, {
    required String catalogId,
    String? variantId,
  }) async {
    final items = [..._snapshot.guestItems];
    final index = items.indexWhere((item) => item.productId == productId);
    final clampedQty = quantity.clamp(1, 100);

    if (index >= 0) {
      final current = items[index];
      items[index] = GuestCartItem(
        productId: current.productId,
        catalogId: current.catalogId,
        variantId: current.variantId ?? variantId,
        quantity: (current.quantity + clampedQty).clamp(1, 100),
        addedAt: current.addedAt,
      );
    } else {
      items.add(
        GuestCartItem(
          productId: productId,
          catalogId: catalogId,
          variantId: variantId,
          quantity: clampedQty,
          addedAt: DateTime.now(),
        ),
      );
    }

    await _persistGuestCart(items);
  }

  Future<void> updateGuestCartItem(String productId, int quantity) async {
    final items = [..._snapshot.guestItems];
    final index = items.indexWhere((item) => item.productId == productId);
    if (index < 0) return;
    items[index] = GuestCartItem(
      productId: items[index].productId,
      catalogId: items[index].catalogId,
      variantId: items[index].variantId,
      quantity: quantity.clamp(0, 100),
      addedAt: items[index].addedAt,
    );
    await _persistGuestCart(items);
  }

  Future<void> removeFromGuestCart(String productId) async {
    final items = _snapshot.guestItems
        .where((item) => item.productId != productId)
        .toList();
    await _persistGuestCart(items);
  }

  Future<List<GuestCartItem>> getGuestCart() async {
    await _restoreGuestCart();
    return _snapshot.guestItems;
  }

  Future<void> clearGuestCart() async {
    await prefs.remove(guestCartKey);
    _snapshot = _snapshot.copyWith(guestItems: const []);
    notifyListeners();
  }

  Future<void> syncGuestCart() async {
    final guestItems = await getGuestCart();
    if (guestItems.isEmpty) return;

    try {
      final currentCart = await service.getCart();
      final merged = CartSyncService.merge(guestItems, currentCart.items);
      final guestByProduct = {
        for (final g in guestItems) g.productId: g,
      };
      await service.syncCart(
        merged.map((item) {
          final guest = guestByProduct[item.productId];
          return {
            'catalog_id': guest?.catalogId ?? item.productId,
            'product_id': item.productId,
            'quantity': item.quantity,
            if (guest?.variantId != null && guest!.variantId!.isNotEmpty)
              'variant_id': guest.variantId,
          };
        }).toList(),
      );
      await clearGuestCart();
      await loadCart();
    } catch (_) {
      // Keep guest cart on sync failure so items are not lost.
    }
  }

  Future<void> _restoreGuestCart() async {
    final raw = prefs.getString(guestCartKey);
    if (raw == null || raw.isEmpty) {
      _snapshot = _snapshot.copyWith(guestItems: const []);
      notifyListeners();
      return;
    }

    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;

    final items = decoded
        .map(
          (entry) => GuestCartItem.fromJson(Map<String, dynamic>.from(entry)),
        )
        .toList();
    _snapshot = _snapshot.copyWith(guestItems: items);
    notifyListeners();
  }

  Future<void> _persistGuestCart(List<GuestCartItem> items) async {
    final encoded = jsonEncode(items.map((item) => item.toJson()).toList());
    await prefs.setString(guestCartKey, encoded);
    _snapshot = _snapshot.copyWith(guestItems: items);
    notifyListeners();
  }

}
