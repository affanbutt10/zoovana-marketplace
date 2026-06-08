import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../controllers/categories_controller.dart';
import '../controllers/category_products_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CategoriesController>()) {
      Get.put<CategoriesController>(
        CategoriesController(repository: Get.find<CategoryRepository>()),
      );
    }
  }

  static void ensureInitialized() {
    CategoriesBinding().dependencies();
  }
}

class CategoryProductsBinding extends Bindings {
  CategoryProductsBinding(this.slug);

  final String slug;

  @override
  void dependencies() {
    if (!Get.isRegistered<CategoryProductsController>(tag: slug)) {
      Get.put<CategoryProductsController>(
        CategoryProductsController(
          slug: slug,
          repository: Get.find<CategoryRepository>(),
          authController: Get.find<AuthController>(),
          cartRepository: Get.find<CartRepository>(),
        ),
        tag: slug,
      );
    }
  }

  static void ensureInitialized(String slug) {
    CategoryProductsBinding(slug).dependencies();
  }
}
