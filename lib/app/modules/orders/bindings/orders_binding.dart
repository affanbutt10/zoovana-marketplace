import 'package:get/get.dart';

import '../../../data/repositories/orders_repository.dart';
import '../../../data/repositories/receipts_repository.dart';
import '../controllers/order_detail_controller.dart';
import '../controllers/orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<OrdersController>()) {
      Get.put<OrdersController>(
        OrdersController(repository: Get.find<OrdersRepository>()),
      );
    }
  }

  static void ensureInitialized() {
    OrdersBinding().dependencies();
  }
}

class OrderDetailBinding extends Bindings {
  OrderDetailBinding(this.orderId);

  final String orderId;

  @override
  void dependencies() {
    if (!Get.isRegistered<OrderDetailController>(tag: orderId)) {
      Get.put<OrderDetailController>(
        OrderDetailController(
          orderId: orderId,
          repository: Get.find<OrdersRepository>(),
          receiptsRepository: Get.find<ReceiptsRepository>(),
        ),
        tag: orderId,
      );
    }
  }

  static void ensureInitialized(String orderId) {
    OrderDetailBinding(orderId).dependencies();
  }
}
