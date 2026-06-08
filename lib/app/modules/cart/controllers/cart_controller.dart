import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/cart.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/checkout_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../models/cart_view_state.dart';

class CartController extends GetxController {
  CartController({
    required this.cartRepository,
    required this.productRepository,
  });

  final CartRepository cartRepository;
  final ProductRepository productRepository;
  final TextEditingController promoController = TextEditingController();

  // Cache of enriched product details keyed by productId
  final Map<String, Product> _productCache = {};

  CartViewState state = const CartViewState();

  @override
  void onInit() {
    super.onInit();
    cartRepository.addListener(_syncFromRepository);
    _syncFromRepository();
    cartRepository.loadCart();
  }

  Cart? get cart => state.cart;

  Future<void> refreshCart() => cartRepository.loadCart();

  Future<void> updateQuantity(String itemId, int quantity) async {
    // Guest cart items use productId as their id
    final isGuestItem = cartRepository.snapshot.guestItems
        .any((g) => g.productId == itemId);
    if (isGuestItem) {
      if (quantity <= 0) {
        await cartRepository.removeFromGuestCart(itemId);
      } else {
        await cartRepository.updateGuestCartItem(itemId, quantity);
      }
      return;
    }
    try {
      await cartRepository.updateCartItem(itemId, quantity);
    } catch (error) {
      state = state.copyWith(error: AppErrorMapper.map(error).message);
      update();
    }
  }

  Future<void> removeItem(String itemId) async {
    // Guest cart items use productId as their id
    final isGuestItem = cartRepository.snapshot.guestItems
        .any((g) => g.productId == itemId);
    if (isGuestItem) {
      await cartRepository.removeFromGuestCart(itemId);
      return;
    }
    try {
      await cartRepository.removeFromCart(itemId);
    } catch (error) {
      state = state.copyWith(error: AppErrorMapper.map(error).message);
      update();
    }
  }

  /// Validates cart + checkout per API guide, then navigates to checkout.
  Future<bool> proceedToCheckout() async {
    final cart = state.cart;
    if (cart == null || cart.items.isEmpty) {
      return false;
    }

    if (cart.hasUnavailableItems) {
      state = state.copyWith(
        error:
            'Some items in your cart are unavailable. Remove them before checkout.',
      );
      update();
      return false;
    }

    final auth = Get.find<AuthController>();
    if (!auth.isAuthenticated) {
      await Get.toNamed('/login');
      return false;
    }

    state = state.copyWith(isProceedingToCheckout: true, clearError: true);
    update();

    try {
      final cartValidation = await cartRepository.validateCart();
      final isCartValid = cartValidation['is_valid'] == true;
      if (!isCartValid) {
        final issues = cartValidation['issues'];
        state = state.copyWith(
          isProceedingToCheckout: false,
          error: _formatCartIssues(issues),
        );
        update();
        await cartRepository.loadCart();
        return false;
      }

      final checkoutRepo = Get.find<CheckoutRepository>();
      final checkoutValidation = await checkoutRepo.validateCheckout();
      if (checkoutValidation['valid'] != true) {
        final issues = checkoutValidation['issues'];
        state = state.copyWith(
          isProceedingToCheckout: false,
          error: _formatCartIssues(issues),
        );
        update();
        await cartRepository.loadCart();
        return false;
      }

      state = state.copyWith(isProceedingToCheckout: false, clearError: true);
      update();
      await Get.toNamed('/checkout');
      return true;
    } catch (error) {
      state = state.copyWith(
        isProceedingToCheckout: false,
        error: AppErrorMapper.map(error).message,
      );
      update();
      return false;
    }
  }

  String _formatCartIssues(dynamic issues) {
    if (issues is! List || issues.isEmpty) {
      return 'Your cart needs attention before checkout. Please review your items.';
    }
    return issues.map((e) => e.toString()).join('\n');
  }

  Future<void> applyPromo() async {
    final code = promoController.text.trim();
    if (code.isEmpty) {
      return;
    }

    state = state.copyWith(isApplyingPromo: true, clearError: true);
    update();
    try {
      await cartRepository.applyPromoCode(code);
    } catch (error) {
      state = state.copyWith(
        isApplyingPromo: false,
        error: AppErrorMapper.map(error).message,
      );
      update();
      return;
    }

    state = state.copyWith(isApplyingPromo: false, clearError: true);
    update();
  }

  void _syncFromRepository() {
    final snapshot = cartRepository.snapshot;

    // If the server cart has items, use it directly.
    // If the server cart is empty/null but there are guest items,
    // synthesize a Cart from guest items so the cart screen can display them.
    Cart? displayCart = snapshot.cart;
    if ((displayCart == null || displayCart.items.isEmpty) &&
        snapshot.guestItems.isNotEmpty) {
      displayCart = _buildGuestCart(snapshot.guestItems);
      // Enrich guest items with real product data in the background
      _enrichGuestCart(snapshot.guestItems);
    }

    state = state.copyWith(
      isLoading: snapshot.isLoading,
      cart: displayCart,
      error: snapshot.error == null
          ? null
          : AppErrorMapper.map(snapshot.error!).message,
      clearError: snapshot.error == null,
    );
    update();
  }

  /// Fetches real product details for guest cart items and rebuilds the cart.
  Future<void> _enrichGuestCart(List<GuestCartItem> guestItems) async {
    bool updated = false;
    for (final g in guestItems) {
      if (_productCache.containsKey(g.productId)) continue;
      try {
        final product = await productRepository.getProduct(g.productId);
        _productCache[g.productId] = product;
        updated = true;
      } catch (_) {
        // Keep placeholder if fetch fails
      }
    }
    if (updated) {
      // Rebuild the guest cart with enriched data and notify UI
      final enriched = _buildGuestCart(guestItems);
      state = state.copyWith(cart: enriched);
      update();
    }
  }

  /// Builds a displayable [Cart] from local guest items.
  /// Uses cached product details when available, otherwise shows a placeholder.
  Cart _buildGuestCart(List<GuestCartItem> guestItems) {
    final cartItems = guestItems.map((g) {
      final product = _productCache[g.productId];
      return CartItem(
        id: g.productId,
        productId: g.productId,
        catalogId: g.catalogId,
        productName: product?.name ?? '',
        productNameAr: product?.nameAr ?? '',
        price: product?.price ?? 0.0,
        quantity: g.quantity,
        imageUrl: product?.imageUrl ?? '',
        stock: product?.stock ?? 99,
        isAvailable: product?.isInStock ?? true,
      );
    }).toList();

    final total = cartItems.fold<double>(
      0,
      (sum, item) => sum + item.price * item.quantity,
    );

    return Cart(
      id: 'guest',
      status: 'active',
      items: cartItems,
      itemCount: cartItems.fold(0, (sum, i) => sum + i.quantity),
      subtotal: total,
      discountAmount: 0,
      taxAmount: 0,
      total: total,
      currency: 'SAR',
    );
  }

  @override
  void onClose() {
    promoController.dispose();
    cartRepository.removeListener(_syncFromRepository);
    super.onClose();
  }
}
