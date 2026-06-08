import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/services/cache_service.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/search_repository.dart';
import '../controllers/search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SearchController>()) {
      Get.put<SearchController>(
        SearchController(
          repository: Get.find<SearchRepository>(),
          categoryRepository: Get.find<CategoryRepository>(),
          cacheService: Get.find<CacheService>(),
          authController: Get.find<AuthController>(),
          cartRepository: Get.find<CartRepository>(),
        ),
      );
    }
  }

  static void ensureInitialized() {
    SearchBinding().dependencies();
  }
}
