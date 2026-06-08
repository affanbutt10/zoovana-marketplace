import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../core/utils/receipt_html_builder.dart';
import '../../../core/utils/receipt_pdf_helper.dart';
import '../../../data/repositories/receipts_repository.dart';

class ReceiptPrintController extends GetxController {
  ReceiptPrintController({
    required this.receiptId,
    required this.fileName,
    required this.repository,
  });

  final String receiptId;
  final String fileName;
  final ReceiptsRepository repository;

  bool isLoading = true;
  bool isDownloading = false;
  String? error;
  String? html;
  WebViewController? webViewController;

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
      html = await repository.getReceiptPrintHtml(receiptId);
      debugPrint(
        '[ReceiptPrintController] load — html length: ${html?.length ?? 0}',
      );
      _loadWebView(html!);
    } catch (err) {
      debugPrint('[ReceiptPrintController] load — ERROR: $err');
      if (err is DioException && err.response?.statusCode == 401) {
        try {
          final receipt = await repository.getReceipt(receiptId);
          html = ReceiptHtmlBuilder.build(receipt);
          debugPrint(
            '[ReceiptPrintController] load — using local live-data HTML fallback',
          );
          _loadWebView(html!);
        } catch (fallbackErr) {
          debugPrint('[ReceiptPrintController] fallback — ERROR: $fallbackErr');
          error = 'Could not open this receipt. Please try again in a moment.';
        }
      } else {
        error = AppErrorMapper.map(err).message;
      }
    }
    isLoading = false;
    update();
  }

  void _loadWebView(String receiptHtml) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..loadHtmlString(receiptHtml);
    webViewController = controller;
    error = null;
  }

  Future<void> downloadHtml() async {
    if (isDownloading || html == null || html!.isEmpty) return;
    isDownloading = true;
    update();
    try {
      await ReceiptPdfHelper.shareHtml(html: html!, fileName: fileName);
    } catch (err) {
      error = AppErrorMapper.map(err).message;
    }
    isDownloading = false;
    update();
  }
}
