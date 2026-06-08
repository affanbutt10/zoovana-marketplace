import '../../../data/models/product.dart';

class ProductState {
  const ProductState({
    this.isLoading = true,
    this.error,
    this.product,
    this.relatedProducts = const [],
    this.quantity = 1,
    this.isAddingToCart = false,
  });

  final bool isLoading;
  final String? error;
  final Product? product;
  final List<Product> relatedProducts;
  final int quantity;
  final bool isAddingToCart;

  ProductState copyWith({
    bool? isLoading,
    String? error,
    Product? product,
    List<Product>? relatedProducts,
    int? quantity,
    bool? isAddingToCart,
    bool clearError = false,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      quantity: quantity ?? this.quantity,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
    );
  }
}
