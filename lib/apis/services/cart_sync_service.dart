import '../../app/data/models/cart.dart';

/// Merges guest cart items with authenticated cart items.
///
/// For products present in both carts, keeps the higher quantity.
/// Products only in one cart are included as-is.
class CartSyncService {
  /// Merges [guestCart] and [authCart] into a single list of [GuestCartItem].
  ///
  /// Deduplicates by `product_id`, keeping `max(guestQty, authQty)` for
  /// shared products. Returns the merged list ready for `POST /cart/sync`.
  static List<GuestCartItem> merge(
    List<GuestCartItem> guestCart,
    List<CartItem> authCart,
  ) {
    // Build a map from product_id → quantity for the guest cart
    final Map<String, GuestCartItem> merged = {
      for (final item in guestCart) item.productId: item,
    };

    for (final authItem in authCart) {
      final existing = merged[authItem.productId];
      if (existing != null) {
        // Shared product — keep the higher quantity
        if (authItem.quantity > existing.quantity) {
          merged[authItem.productId] = GuestCartItem(
            productId: authItem.productId,
            catalogId: authItem.catalogId ?? existing.catalogId,
            variantId: existing.variantId,
            quantity: authItem.quantity,
            addedAt: existing.addedAt,
          );
        }
      } else {
        // Auth-only product — add it to the merged list
        merged[authItem.productId] = GuestCartItem(
          productId: authItem.productId,
          catalogId: authItem.catalogId ?? authItem.productId,
          variantId: null,
          quantity: authItem.quantity,
          addedAt: DateTime.now(),
        );
      }
    }

    return merged.values.toList();
  }
}
