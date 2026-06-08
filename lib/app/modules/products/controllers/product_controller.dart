import 'package:get/get.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../core/mixins/network_aware_mixin.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../models/product_state.dart';

class ProductController extends GetxController with NetworkAwareMixin {
  ProductController({
    required this.productId,
    required this.productRepository,
    required this.authRepository,
    required this.cartRepository,
  });

  final String productId;
  final ProductRepository productRepository;
  final AuthRepository authRepository;
  final CartRepository cartRepository;

  ProductState state = const ProductState();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (isOffline) {
      state = state.copyWith(isLoading: true, clearError: true);
      update();
    }
    state = state.copyWith(isLoading: true, clearError: true);
    update();
    try {
      final product = await productRepository.getProduct(productId);
      var related = <Product>[];
      try {
        related = await productRepository.getRelatedProducts(productId);
      } catch (_) {
        // Related products are optional; 404 is common for some catalog items.
      }
      state = state.copyWith(
        isLoading: false,
        product: product,
        relatedProducts: related.where((item) => item.id != product.id).toList(),
        quantity: 1,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: AppErrorMapper.map(error).message,
      );
    }
    update();
  }

  void setQuantity(int quantity) {
    state = state.copyWith(quantity: quantity);
    update();
  }

  /// Returns true when the item was added successfully.
  Future<bool> addToCart() async {
    final product = state.product;
    if (product == null) return false;

    if (!product.canAddToCart) {
      state = state.copyWith(error: AppErrorMapper.outOfStockMessage());
      update();
      return false;
    }

    state = state.copyWith(isAddingToCart: true, clearError: true);
    update();
    try {
      final isAuthenticated = await authRepository.isAuthenticated();
      if (isAuthenticated) {
        try {
          await cartRepository.addToCart(
            product.id,
            state.quantity,
            catalogId: product.catalogId,
            variantId: product.variantId,
          );
          return true;
        } catch (error) {
          state = state.copyWith(
            error: AppErrorMapper.isOutOfStockError(error)
                ? AppErrorMapper.outOfStockMessage()
                : AppErrorMapper.map(error).message,
          );
          update();
          return false;
        }
      } else {
        await cartRepository.addToGuestCart(
          product.id,
          state.quantity,
          catalogId: product.catalogId,
          variantId: product.variantId,
        );
        return true;
      }
    } catch (_) {
      return false;
    } finally {
      state = state.copyWith(isAddingToCart: false);
      update();
    }
  }
}
