import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/cart_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AuthController>()) {
      Get.put<AuthController>(
        AuthController(
          authRepository: Get.find<AuthRepository>(),
          cartRepository: Get.find<CartRepository>(),
        ),
        permanent: true,
      );
    }
  }

  static void ensureInitialized() {
    AuthBinding().dependencies();
  }
}
