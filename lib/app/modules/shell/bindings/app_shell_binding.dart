import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../cart/bindings/cart_binding.dart';
import '../controllers/app_shell_controller.dart';

class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<AppShellController>()) {
      Get.put<AppShellController>(AppShellController(), permanent: true);
    }
    CartBinding().dependencies();
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
}
