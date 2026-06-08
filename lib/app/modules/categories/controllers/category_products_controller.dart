import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/category_repository.dart';

class CategoryProductsController extends GetxController {
  CategoryProductsController({
    required this.slug,
    required this.repository,
    required this.authController,
    required this.cartRepository,
  });

  final String slug;
  final CategoryRepository repository;
  final AuthController authController;
  final CartRepository cartRepository;

  List<Product> products = const [];
  bool isLoading = true;
  bool hasMore = true;
  int page = 1;
  String sort = 'newest';
  String? error;

  @override
  void onInit() {
    super.onInit();
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    page = 1;
    hasMore = true;
    products = const [];
    await _loadPage(reset: true);
  }

  Future<void> loadNextPage() async {
    if (isLoading || !hasMore) {
      return;
    }
    page += 1;
    await _loadPage();
  }

  Future<void> changeSort(String value) async {
    sort = value;
    await loadFirstPage();
  }

  Future<void> addToCart(Product product) async {
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

    if (authController.isAuthenticated) {
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
  }

  Future<void> _loadPage({bool reset = false}) async {
    isLoading = true;
    error = null;
    update();
    try {
      final response = await repository.getCategoryProducts(
        slug: slug,
        page: page,
        sort: sort,
      );
      products = reset ? response.items : [...products, ...response.items];
      hasMore = response.hasMore;
    } catch (err) {
      error = AppErrorMapper.map(err).message;
    }
    isLoading = false;
    update();
  }
}
