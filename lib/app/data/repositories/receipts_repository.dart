import 'dart:typed_data';

import '../../../apis/services/receipt_service.dart';
import '../models/receipt.dart';

/// All data comes directly from the backend API.
/// No mock fallbacks — errors are propagated to the UI layer.
class ReceiptsRepository {
  ReceiptsRepository({required this.service});

  final ReceiptService service;

  Future<List<Receipt>> getReceipts({int page = 1, int pageSize = 12}) {
    return service.getReceipts(page: page, pageSize: pageSize);
  }

  Future<List<Receipt>> getReceiptsByOrder(String orderId) {
    return service.getReceiptsByOrder(orderId);
  }

  Future<Receipt> getReceipt(String id) {
    return service.getReceipt(id);
  }

  Future<Uint8List> getReceiptPdf(String id) {
    return service.getReceiptPdf(id);
  }

  Future<String> getReceiptPrintHtml(String id) {
    return service.getReceiptPrintHtml(id);
  }

  Future<Uint8List> getOrderPdf(String orderId) {
    return service.getOrderPdf(orderId);
  }
}
