import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/receipt.dart';
import '../../../data/repositories/receipts_repository.dart';
import '../receipt_print_screen.dart';

class ReceiptDetailController extends GetxController {
  ReceiptDetailController({required this.receiptId, required this.repository});

  final String receiptId;
  final ReceiptsRepository repository;

  bool isLoading = true;
  bool isDownloading = false;
  String? error;
  Receipt? receipt;

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
      receipt = await repository.getReceipt(receiptId);
      debugPrint(
        '[ReceiptDetailController] load — receipt loaded: ${receipt?.id} | '
        'items: ${receipt?.items.length ?? 0}',
      );
    } catch (err) {
      debugPrint('[ReceiptDetailController] load — ERROR: $err');
      error = AppErrorMapper.map(err).message;
    }
    isLoading = false;
    update();
  }

  Future<void> downloadPdf() async {
    if (isDownloading || receipt == null) return;
    isDownloading = true;
    update();
    try {
      debugPrint(
        '[ReceiptDetailController] downloadPdf — opening print view for: '
        '${receipt!.id}',
      );
      final name = receipt!.number.isNotEmpty
          ? receipt!.number
          : 'receipt-$receiptId';
      await Get.to(
        () => ReceiptPrintScreen(receiptId: receipt!.id, fileName: name),
      );
    } catch (err) {
      error = AppErrorMapper.map(err).message;
    }
    isDownloading = false;
    update();
  }
}
