import '../../../data/models/cart.dart';

class CartViewState {
  const CartViewState({
    this.isLoading = true,
    this.error,
    this.cart,
    this.isApplyingPromo = false,
    this.isProceedingToCheckout = false,
  });

  final bool isLoading;
  final String? error;
  final Cart? cart;
  final bool isApplyingPromo;
  final bool isProceedingToCheckout;

  CartViewState copyWith({
    bool? isLoading,
    String? error,
    Cart? cart,
    bool? isApplyingPromo,
    bool? isProceedingToCheckout,
    bool clearError = false,
  }) {
    return CartViewState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      cart: cart ?? this.cart,
      isApplyingPromo: isApplyingPromo ?? this.isApplyingPromo,
      isProceedingToCheckout:
          isProceedingToCheckout ?? this.isProceedingToCheckout,
    );
  }
}
