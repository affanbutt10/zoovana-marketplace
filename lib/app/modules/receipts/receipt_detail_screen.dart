import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../shared/widgets/app_top_bar.dart';
import 'bindings/receipts_binding.dart';
import 'controllers/receipt_detail_controller.dart';
import '../../../l10n/app_localizations.dart';

class ReceiptDetailScreen extends StatefulWidget {
  const ReceiptDetailScreen({
    super.key,
    required this.orderId,
    required this.receiptId,
  });

  final String orderId;
  final String receiptId;

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> {
  @override
  void initState() {
    super.initState();
    ReceiptDetailBinding.ensureInitialized(widget.receiptId);
  }

  @override
  void dispose() {
    if (Get.isRegistered<ReceiptDetailController>(tag: widget.receiptId)) {
      Get.delete<ReceiptDetailController>(tag: widget.receiptId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceiptDetailController>(
      tag: widget.receiptId,
      builder: (controller) {
        final receipt = controller.receipt;

        return Scaffold(
          appBar: AppTopBar(
            leading: IconButton(
              tooltip: AppLocalizations.of(context)?.back ?? 'Back',
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: Text(
              AppLocalizations.of(context)?.receiptNumber(widget.receiptId) ??
                  'Receipt #${widget.receiptId}',
            ),
          ),
          bottomNavigationBar: receipt == null
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: AppButton(
                      label: 'View Receipt',
                      icon: const Icon(Icons.receipt_long_outlined),
                      isLoading: controller.isDownloading,
                      onPressed: controller.downloadPdf,
                    ),
                  ),
                ),
          body: AnimatedSwitcher(
            duration: AppMotion.medium,
            child: controller.isLoading
                ? SingleChildScrollView(
                    key: const ValueKey('loading'),
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Column(
                      children: [
                        AppShimmer.heroBanner(),
                        const SizedBox(height: AppSpacing.sectionGap),
                        AppShimmer.list(count: 3),
                      ],
                    ),
                  )
                : controller.error != null || receipt == null
                ? ((controller.error ?? '').toLowerCase().contains('offline')
                      ? AppStateView.offline(
                          key: const ValueKey('offline'),
                          message:
                              controller.error ??
                              (AppLocalizations.of(
                                    context,
                                  )?.couldNotLoadReceipt ??
                                  'Could not load receipt.'),
                          actionLabel:
                              AppLocalizations.of(context)?.retry ?? 'Retry',
                          onAction: controller.load,
                        )
                      : AppStateView.error(
                          key: const ValueKey('error'),
                          message:
                              controller.error ??
                              (AppLocalizations.of(
                                    context,
                                  )?.couldNotLoadReceipt ??
                                  'Could not load receipt.'),
                          actionLabel:
                              AppLocalizations.of(context)?.retry ?? 'Retry',
                          onAction: controller.load,
                        ))
                : ListView(
                    key: const ValueKey('content'),
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    children: [
                      Container(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceRaised,
                              borderRadius: BorderRadius.circular(
                                AppRadius.xxLarge,
                              ),
                              border: Border.all(
                                color: AppColors.borderSubtle.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                              boxShadow: AppShadows.elevation1,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md,
                                        vertical: AppSpacing.xs,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.brandSoft,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.pill,
                                        ),
                                      ),
                                      child: Builder(
                                        builder: (ctx) => Text(
                                          AppLocalizations.of(
                                                ctx,
                                              )?.receiptProofOfPurchase ??
                                              'Proof of Purchase',
                                          style: const TextStyle(
                                            color: AppColors.brandDeep,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(duration: AppMotion.medium)
                                    .slideX(),
                                const SizedBox(height: AppSpacing.lg),
                                Text(
                                  'Receipt #${receipt.number}',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textSecondary,
                                      ),
                                ).animate().fadeIn(
                                  duration: AppMotion.medium,
                                  delay: 50.ms,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(receipt.date),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppColors.textTertiary),
                                ).animate().fadeIn(
                                  duration: AppMotion.medium,
                                  delay: 100.ms,
                                ),
                                const SizedBox(height: AppSpacing.sectionGap),
                                Text(
                                      'SAR ${receipt.total.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.navy,
                                          ),
                                    )
                                    .animate()
                                    .fadeIn(
                                      duration: AppMotion.medium,
                                      delay: 150.ms,
                                    )
                                    .slideX(),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: AppMotion.medium)
                          .slideY(
                            begin: 0.05,
                            end: 0,
                            duration: AppMotion.medium,
                            curve: AppMotion.emphasis,
                          ),
                      const SizedBox(height: AppSpacing.sectionGap),
                      Container(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceRaised,
                              borderRadius: BorderRadius.circular(
                                AppRadius.xxLarge,
                              ),
                              border: Border.all(
                                color: AppColors.borderSubtle.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                        context,
                                      )?.receiptLineItems ??
                                      'Line Items',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ).animate().fadeIn(delay: 200.ms),
                                const SizedBox(height: AppSpacing.lg),
                                ...receipt.items.asMap().entries.map((entry) {
                                  final itemIndex = entry.key;
                                  final item = entry.value;
                                  return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: AppSpacing.sm,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    Localizations.localeOf(
                                                                  context,
                                                                ).languageCode ==
                                                                'ar' &&
                                                            item
                                                                .productNameAr
                                                                .isNotEmpty
                                                        ? item.productNameAr
                                                        : item.productName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                  const SizedBox(
                                                    height: AppSpacing.xs,
                                                  ),
                                                  Text(
                                                    '${item.quantity} × SAR ${item.unitPrice.toStringAsFixed(2)}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              width: AppSpacing.sm,
                                            ),
                                            Text(
                                              'SAR ${item.totalPrice.toStringAsFixed(2)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(
                                        duration: AppMotion.medium,
                                        delay: (250 + (itemIndex * 50)).ms,
                                      )
                                      .slideX(begin: 0.05, end: 0);
                                }),
                                const SizedBox(height: AppSpacing.xl),
                                const Divider(),
                                const SizedBox(height: AppSpacing.lg),
                                _TotalRow(
                                  label:
                                      AppLocalizations.of(
                                        context,
                                      )?.receiptTotalPaid ??
                                      'Total Paid',
                                  amount: receipt.total,
                                  bold: true,
                                  color: AppColors.brandDeep,
                                ).animate().fadeIn(delay: 400.ms),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: AppMotion.medium, delay: 100.ms)
                          .slideY(
                            begin: 0.05,
                            end: 0,
                            duration: AppMotion.medium,
                            curve: AppMotion.emphasis,
                          ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.amount,
    this.bold = false,
    this.color,
  });

  final String label;
  final double amount;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
      color: color,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          '${AppLocalizations.of(context)!.currencySar} ${amount.toStringAsFixed(2)}',
          style: style,
        ),
      ],
    );
  }
}
