import 'package:get/get.dart';

import '../../../data/repositories/receipts_repository.dart';
import '../controllers/receipt_detail_controller.dart';
import '../controllers/receipt_print_controller.dart';
import '../controllers/receipts_controller.dart';

class ReceiptsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ReceiptsController>()) {
      Get.put<ReceiptsController>(
        ReceiptsController(repository: Get.find<ReceiptsRepository>()),
      );
    }
  }

  static void ensureInitialized() {
    ReceiptsBinding().dependencies();
  }
}

class ReceiptDetailBinding extends Bindings {
  ReceiptDetailBinding(this.receiptId);

  final String receiptId;

  @override
  void dependencies() {
    if (!Get.isRegistered<ReceiptDetailController>(tag: receiptId)) {
      Get.put<ReceiptDetailController>(
        ReceiptDetailController(
          receiptId: receiptId,
          repository: Get.find<ReceiptsRepository>(),
        ),
        tag: receiptId,
      );
    }
  }

  static void ensureInitialized(String receiptId) {
    ReceiptDetailBinding(receiptId).dependencies();
  }
}

class ReceiptPrintBinding extends Bindings {
  ReceiptPrintBinding({required this.receiptId, required this.fileName});

  final String receiptId;
  final String fileName;

  @override
  void dependencies() {
    if (!Get.isRegistered<ReceiptPrintController>(tag: receiptId)) {
      Get.put<ReceiptPrintController>(
        ReceiptPrintController(
          receiptId: receiptId,
          fileName: fileName,
          repository: Get.find<ReceiptsRepository>(),
        ),
        tag: receiptId,
      );
    }
  }

  static void ensureInitialized({
    required String receiptId,
    required String fileName,
  }) {
    ReceiptPrintBinding(
      receiptId: receiptId,
      fileName: fileName,
    ).dependencies();
  }
}
