import 'package:get/get.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/order.dart';
import '../../../data/models/receipt.dart';
import '../../../data/repositories/orders_repository.dart';
import '../../../data/repositories/receipts_repository.dart';
import '../../receipts/receipt_print_screen.dart';

class OrderDetailController extends GetxController {
  OrderDetailController({
    required this.orderId,
    required this.repository,
    required this.receiptsRepository,
  });

  final String orderId;
  final OrdersRepository repository;
  final ReceiptsRepository receiptsRepository;

  bool isLoading = true;
  bool isDownloadingReceipt = false;
  String? error;
  Order? order;
  Receipt? receipt;
  List<TrackingEvent> tracking = const [];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading = true;
    error = null;
    update();
    try {
      order = await repository.getOrder(orderId);
      try {
        tracking = await repository.getTracking(orderId);
      } catch (_) {
        tracking = const [];
      }
      await _loadReceipt();
    } catch (err) {
      error = AppErrorMapper.map(err).message;
    }
    isLoading = false;
    update();
  }

  Future<void> _loadReceipt() async {
    receipt = null;
    if (order?.receiptId != null && order!.receiptId!.isNotEmpty) {
      try {
        receipt = await receiptsRepository.getReceipt(order!.receiptId!);
        return;
      } catch (_) {}
    }
    try {
      final receipts = await receiptsRepository.getReceiptsByOrder(orderId);
      if (receipts.isNotEmpty) {
        receipt = receipts.first;
      }
    } catch (_) {}
  }

  bool get canViewReceipt => receipt != null;

  Future<void> downloadReceipt() async {
    if (isDownloadingReceipt) return;
    isDownloadingReceipt = true;
    update();
    try {
      if (receipt != null) {
        final fileName = receipt!.number.isNotEmpty
            ? receipt!.number
            : 'receipt-${receipt!.id}';
        await Get.to(
          () => ReceiptPrintScreen(receiptId: receipt!.id, fileName: fileName),
        );
      } else {
        error = 'Receipt is not available for this order yet.';
      }
    } catch (err) {
      error = AppErrorMapper.map(err).message;
    }
    isDownloadingReceipt = false;
    update();
  }
}
