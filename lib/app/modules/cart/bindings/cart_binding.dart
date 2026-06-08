import 'package:get/get.dart';

import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartController>()) {
      Get.put<CartController>(
        CartController(
          cartRepository: Get.find<CartRepository>(),
          productRepository: Get.find<ProductRepository>(),
        ),
      );
    }
  }

  static void ensureInitialized() {
    CartBinding().dependencies();
  }
}
