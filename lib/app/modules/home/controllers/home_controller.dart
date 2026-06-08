import 'package:get/get.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../core/mixins/network_aware_mixin.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/home_repository.dart';
import '../models/home_state.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';

class HomeController extends GetxController with NetworkAwareMixin {
  HomeController({
    required this.homeRepository,
    required this.authRepository,
    required this.cartRepository,
  });

  final HomeRepository homeRepository;
  final AuthRepository authRepository;
  final CartRepository cartRepository;

  HomeState state = const HomeState();
  bool _isRefreshing = false;
  DateTime? _lastRefreshAt;

  @override
  void onInit() {
    super.onInit();
    loadHome(force: true);
  }

  Future<void> loadHome({
    bool showLoading = true,
    bool force = false,
  }) async {
    if (_isRefreshing) return;
    final now = DateTime.now();
    if (!force &&
        _lastRefreshAt != null &&
        now.difference(_lastRefreshAt!) < const Duration(seconds: 8)) {
      return;
    }

    _isRefreshing = true;
    final hasContent =
        state.categories.isNotEmpty ||
        state.featuredProducts.isNotEmpty ||
        state.freshArrivals.isNotEmpty;
    final shouldShowLoading = showLoading && !hasContent;

    state = state.copyWith(isLoading: shouldShowLoading, clearError: true);
    update();
    try {
      final content = await homeRepository.loadHomeContent();

      String? userName;
      try {
        final session = await authRepository.getSession();
        // Real API returns full_name; fall back to name for compatibility
        userName = (session['full_name'] ?? session['name']) as String?;
      } catch (_) {
        userName = null;
      }

      state = state.copyWith(
        isLoading: false,
        categories: content.categories,
        featuredProducts: content.featuredProducts,
        freshArrivals: content.freshArrivals,
        userName: userName,
        clearError: true,
      );
      _lastRefreshAt = DateTime.now();
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: hasContent ? null : AppErrorMapper.map(error).message,
      );
    } finally {
      _isRefreshing = false;
    }
    update();
  }

  Future<void> refreshDashboard() {
    return loadHome(showLoading: false, force: true);
  }

  Future<void> addProductToCart(Product product) async {
    final loadingIds = {...state.addingProductIds, product.id};
    state = state.copyWith(addingProductIds: loadingIds);
    update();

    try {
      if (product.isOutOfStock) {
        if (Get.context != null) {
          AppSnackbar.show(
            Get.context!,
            message: AppLocalizations.of(Get.context!)?.outOfStock ??
                'Out of Stock',
            type: SnackbarType.error,
          );
        }
        return;
      }

      final isAuthenticated = await authRepository.isAuthenticated();
      if (isAuthenticated) {
        try {
          await cartRepository.addToCart(
            product.id,
            1,
            catalogId: product.catalogId,
            variantId: product.variantId,
          );
          if (Get.context != null) {
            AppSnackbar.show(
              Get.context!,
              message: AppLocalizations.of(Get.context!)?.productAddedToCart ??
                  'Added to cart',
            );
          }
        } catch (error) {
          if (Get.context != null) {
            AppSnackbar.show(
              Get.context!,
              message: AppErrorMapper.isOutOfStockError(error)
                  ? (AppLocalizations.of(Get.context!)?.outOfStock ??
                      'Out of Stock')
                  : AppErrorMapper.map(error).message,
              type: SnackbarType.error,
            );
          }
        }
      } else {
        await cartRepository.addToGuestCart(
          product.id,
          1,
          catalogId: product.catalogId,
          variantId: product.variantId,
        );
        if (Get.context != null) {
          AppSnackbar.show(
            Get.context!,
            message: AppLocalizations.of(Get.context!)?.productAddedToCart ??
                'Added to cart',
          );
        }
      }
    } catch (err) {
      state = state.copyWith(error: AppErrorMapper.map(err).message);
    } finally {
      final nextIds = {...state.addingProductIds}..remove(product.id);
      state = state.copyWith(addingProductIds: nextIds);
      update();
    }
  }
}
