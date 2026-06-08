import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/receipt.dart';
import '../../routes/app_routes.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../shared/widgets/app_top_bar.dart';
import 'bindings/receipts_binding.dart';
import 'controllers/receipts_controller.dart';
import '../../../l10n/app_localizations.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ReceiptsBinding.ensureInitialized();

    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          tooltip: AppLocalizations.of(context)?.back ?? 'Back',
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Builder(
          builder: (ctx) =>
              Text(AppLocalizations.of(ctx)?.receiptsAppBarTitle ?? 'Receipts'),
        ),
      ),
      body: GetBuilder<ReceiptsController>(
        builder: (controller) {
          if (controller.isLoading) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  AppShimmer.heroBanner(),
                  const SizedBox(height: AppSpacing.sectionGap),
                  AppShimmer.list(count: 4),
                ],
              ),
            );
          }
          if (controller.error != null) {
            final isOffline = controller.error!.toLowerCase().contains(
              'offline',
            );
            return isOffline
                ? AppStateView.offline(
                    message: controller.error!,
                    actionLabel:
                        AppLocalizations.of(context)?.tryAgain ?? 'Retry',
                    onAction: controller.loadReceipts,
                  )
                : AppStateView.error(
                    message: controller.error!,
                    actionLabel: AppLocalizations.of(context)?.retry ?? 'Retry',
                    onAction: controller.loadReceipts,
                  );
          }
          if (controller.receipts.isEmpty) {
            return AppStateView.empty(
              message:
                  AppLocalizations.of(context)?.receiptsNoPurchaseHistory ??
                  'No purchase history found.',
            );
          }

          final totalAmount = controller.receipts.fold<double>(
            0,
            (sum, receipt) => sum + receipt.total,
          );

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              _ReceiptsSummary(
                    count: controller.receipts.length,
                    totalAmount: totalAmount,
                  )
                  .animate()
                  .fadeIn(duration: AppMotion.medium)
                  .slideY(
                    begin: 0.1,
                    end: 0,
                    duration: AppMotion.medium,
                    curve: AppMotion.emphasis,
                  ),
              const SizedBox(height: AppSpacing.sectionGap),
              ...controller.receipts.asMap().entries.map((entry) {
                final index = entry.key;
                final receipt = entry.value;
                return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.base),
                      child: _ReceiptCard(receipt: receipt),
                    )
                    .animate()
                    .fadeIn(duration: AppMotion.medium, delay: (50 * index).ms)
                    .slideY(
                      begin: 0.05,
                      end: 0,
                      duration: AppMotion.medium,
                      delay: (50 * index).ms,
                      curve: AppMotion.emphasis,
                    );
              }),
            ],
          );
        },
      ),
    );
  }
}

class _ReceiptsSummary extends StatelessWidget {
  const _ReceiptsSummary({required this.count, required this.totalAmount});

  final int count;
  final double totalAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        boxShadow: AppShadows.elevation2,
        border: Border.all(color: AppColors.brandSoft.withValues(alpha: 0.3)),
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
              color: AppColors.surfaceRaised.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              count == 1
                  ? (AppLocalizations.of(context)?.receiptsCount(count) ??
                        '$count receipt')
                  : (AppLocalizations.of(context)?.receiptsCountPlural(count) ??
                        '$count receipts'),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.brandDeep,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'SAR ${totalAmount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppLocalizations.of(context)?.receiptsTotalSpending ??
                'Total spending history.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Get.toNamed(AppRoutes.receiptById(receipt.id));
        },
        borderRadius: BorderRadius.circular(AppRadius.xLarge),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.xxLarge),
            border: Border.all(
              color: AppColors.borderSubtle.withValues(alpha: 0.5),
            ),
            boxShadow: AppShadows.elevation1,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(
                            context,
                          )?.receiptNumber(receipt.number) ??
                          'Receipt #${receipt.number}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      DateFormat('dd MMM yyyy').format(receipt.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppLocalizations.of(
                            context,
                          )?.receiptLineItemsCount(receipt.items.length) ??
                          '${receipt.items.length} line items',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'SAR ${receipt.total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
