import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../shared/widgets/app_top_bar.dart';
import 'bindings/receipts_binding.dart';
import 'controllers/receipt_print_controller.dart';
import '../../../l10n/app_localizations.dart';

class ReceiptPrintScreen extends StatefulWidget {
  const ReceiptPrintScreen({
    super.key,
    required this.receiptId,
    required this.fileName,
  });

  final String receiptId;
  final String fileName;

  @override
  State<ReceiptPrintScreen> createState() => _ReceiptPrintScreenState();
}

class _ReceiptPrintScreenState extends State<ReceiptPrintScreen> {
  @override
  void initState() {
    super.initState();
    ReceiptPrintBinding.ensureInitialized(
      receiptId: widget.receiptId,
      fileName: widget.fileName,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<ReceiptPrintController>(tag: widget.receiptId)) {
      Get.delete<ReceiptPrintController>(tag: widget.receiptId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceiptPrintController>(
      tag: widget.receiptId,
      builder: (controller) {
        return Scaffold(
          appBar: AppTopBar(
            leading: IconButton(
              tooltip: AppLocalizations.of(context)?.back ?? 'Back',
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: const Text('Receipt'),
          ),
          body: controller.isLoading
              ? const AppStateView.loading(message: 'Loading receipt...')
              : controller.error != null || controller.webViewController == null
              ? AppStateView.error(
                  message: controller.error ?? 'Could not load receipt.',
                  actionLabel: AppLocalizations.of(context)?.retry ?? 'Retry',
                  onAction: controller.load,
                )
              : WebViewWidget(controller: controller.webViewController!),
          bottomNavigationBar:
              controller.html == null || controller.html!.isEmpty
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: AppButton(
                      label: 'Download Receipt',
                      icon: const Icon(Icons.download_outlined),
                      isLoading: controller.isDownloading,
                      onPressed: controller.downloadHtml,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
