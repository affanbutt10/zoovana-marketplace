import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../profile/bindings/profile_binding.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  ProductBinding(this.productId);

  final String productId;

  @override
  void dependencies() {
    ProfileBinding.ensureInitialized();
    if (!Get.isRegistered<ProductController>(tag: productId)) {
      Get.put<ProductController>(
        ProductController(
          productId: productId,
          productRepository: Get.find<ProductRepository>(),
          authRepository: Get.find<AuthRepository>(),
          cartRepository: Get.find<CartRepository>(),
        ),
        tag: productId,
      );
    }
  }

  static void ensureInitialized(String productId) {
    ProductBinding(productId).dependencies();
  }
}
