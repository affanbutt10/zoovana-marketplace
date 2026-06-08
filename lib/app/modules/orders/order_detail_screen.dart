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
import '../../data/models/order.dart';
import 'bindings/orders_binding.dart';
import 'controllers/order_detail_controller.dart';
import '../../../l10n/app_localizations.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    OrderDetailBinding.ensureInitialized(widget.id);
  }

  @override
  void dispose() {
    if (Get.isRegistered<OrderDetailController>(tag: widget.id)) {
      Get.delete<OrderDetailController>(tag: widget.id);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailController>(
      tag: widget.id,
      builder: (controller) {
        final order = controller.order;
        return Scaffold(
          appBar: AppTopBar(
            leading: IconButton(
              tooltip: AppLocalizations.of(context)?.back ?? 'Back',
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: Text(
              order != null
                  ? (AppLocalizations.of(context)?.orderNumber(order.id) ??
                        'Order #${order.id}')
                  : (AppLocalizations.of(context)?.orderDetails ??
                        'Order Details'),
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
                        AppShimmer.list(count: 2),
                      ],
                    ),
                  )
                : controller.error != null || order == null
                ? ((controller.error ?? '').toLowerCase().contains('offline')
                      ? AppStateView.offline(
                          key: const ValueKey('offline'),
                          message:
                              controller.error ??
                              (AppLocalizations.of(
                                    context,
                                  )?.couldNotLoadOrder ??
                                  'Could not load order.'),
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
                                  )?.couldNotLoadOrder ??
                                  'Could not load order.'),
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
                          gradient: const LinearGradient(
                            colors: [AppColors.navy, Color(0xFF1E3958)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppRadius.xxLarge,
                          ),
                          boxShadow: AppShadows.elevation2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _OrderStatePill(status: order.status)
                                .animate()
                                .fadeIn(duration: AppMotion.medium)
                                .slideX(),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              order.orderNumber.isNotEmpty
                                  ? 'Order #${order.orderNumber}'
                                  : 'Order #${order.id}',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ).animate().fadeIn(delay: 50.ms),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              DateFormat('dd MMM yyyy').format(order.placedAt),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.72),
                                  ),
                            ).animate().fadeIn(delay: 100.ms),
                            const SizedBox(height: AppSpacing.sectionGap),
                            Text(
                              'SAR ${order.total.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ).animate().fadeIn(delay: 150.ms).slideX(),
                          ],
                        ),
                      ).animate().fadeIn().slideY(
                        begin: 0.05,
                        end: 0,
                        curve: AppMotion.emphasis,
                      ),
                      const SizedBox(height: AppSpacing.sectionGap),
                      if (controller.tracking.isNotEmpty) ...[
                        Container(
                              padding: const EdgeInsets.all(AppSpacing.xl),
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
                                        )?.orderTracking ??
                                        'Tracking',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: AppSpacing.lg),
                                  ...controller.tracking.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key;
                                    final event = entry.value;
                                    return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: AppSpacing.lg,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: AppColors.brandSoft,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check_rounded,
                                                  size: 20,
                                                  color: AppColors.brandDeep,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: AppSpacing.md,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      event.status,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      event.description,
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
                                              Text(
                                                DateFormat(
                                                  'dd MMM',
                                                ).format(event.timestamp),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall
                                                    ?.copyWith(
                                                      color: AppColors
                                                          .textTertiary,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .animate()
                                        .fadeIn(delay: (200 + (index * 50)).ms)
                                        .slideX(begin: 0.05, end: 0);
                                  }),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 150.ms)
                            .slideY(
                              begin: 0.05,
                              end: 0,
                              curve: AppMotion.emphasis,
                            ),
                        const SizedBox(height: AppSpacing.sectionGap),
                      ],
                      Text(
                        AppLocalizations.of(context)?.orderSummary ??
                            'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: AppSpacing.md),
                      ...order.subOrders.asMap().entries.map((entry) {
                        final subOrderIndex = entry.key;
                        final subOrder = entry.value;
                        return Container(
                              margin: const EdgeInsets.only(
                                bottom: AppSpacing.base,
                              ),
                              padding: const EdgeInsets.all(AppSpacing.xl),
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
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.storefront_rounded,
                                        color: AppColors.brand,
                                        size: 20,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          subOrder.sellerName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                  ...subOrder.items.map(
                                    (item) => Padding(
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
                                                  'Qty: ${item.quantity}',
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
                                          const SizedBox(width: AppSpacing.sm),
                                          Text(
                                            '${order.currency} ${item.displayLineTotal.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSpacing.md,
                                    ),
                                    child: Divider(),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocalizations.of(
                                                context,
                                              )?.orderSellerSubtotal ??
                                              'Seller Subtotal',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'SAR ${subOrder.subtotal.toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.navy,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: (250 + (subOrderIndex * 50)).ms)
                            .slideX(begin: 0.05, end: 0);
                      }),
                      const SizedBox(height: AppSpacing.sectionGap),
                      _OrderTotalsCard(order: order),
                      if (order.shippingAddress != null) ...[
                        const SizedBox(height: AppSpacing.base),
                        _InfoCard(
                          title: 'Shipping Address',
                          icon: Icons.location_on_outlined,
                          lines: [
                            order.shippingAddress!.fullName,
                            order.shippingAddress!.addressLine1,
                            '${order.shippingAddress!.city}, ${order.shippingAddress!.country}',
                            order.shippingAddress!.phoneNumber,
                          ],
                        ),
                      ],
                      if (order.paymentMethod.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.base),
                        _InfoCard(
                          title: 'Payment Method',
                          icon: Icons.credit_card_outlined,
                          lines: [order.paymentMethod],
                        ),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'View Receipt',
                        icon: const Icon(Icons.receipt_long_outlined),
                        isLoading: controller.isDownloadingReceipt,
                        onPressed: controller.downloadReceipt,
                      ),
                      const SizedBox(height: AppSpacing.heroGap),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _OrderTotalsCard extends StatelessWidget {
  const _OrderTotalsCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _totalRow(context, 'Subtotal', order.subtotal, order.currency),
          _totalRow(context, 'VAT', order.taxAmount, order.currency),
          _totalRow(context, 'Shipping', order.shippingCost, order.currency),
          const Divider(),
          _totalRow(
            context,
            'Total',
            order.total,
            order.currency,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _totalRow(
    BuildContext context,
    String label,
    double amount,
    String currency, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            '$currency ${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold ? AppColors.brand : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.icon,
    required this.lines,
  });

  final String title;
  final IconData icon;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.brand, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...lines.where((l) => l.isNotEmpty).map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                line,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderStatePill extends StatelessWidget {
  const _OrderStatePill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusAccent(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        _localizedStatusDetail(context, status),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color.withAlpha(240),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

Color _statusAccent(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return AppColors.warning;
    case 'processing':
    case 'shipped':
      return AppColors.info;
    case 'delivered':
    case 'confirmed':
      return AppColors.success;
    case 'cancelled':
      return AppColors.danger;
    default:
      return AppColors.brandSoft;
  }
}

String _localizedStatusDetail(BuildContext context, String status) {
  final l10n = AppLocalizations.of(context);
  switch (status.toLowerCase()) {
    case 'pending':
      return l10n?.orderStatusPending ?? 'PENDING';
    case 'processing':
      return l10n?.orderStatusProcessing ?? 'PROCESSING';
    case 'shipped':
      return l10n?.orderStatusShipped ?? 'SHIPPED';
    case 'delivered':
      return l10n?.orderStatusDelivered ?? 'DELIVERED';
    case 'confirmed':
      return 'CONFIRMED';
    case 'cancelled':
      return l10n?.orderStatusCancelled ?? 'CANCELLED';
    default:
      return status.toUpperCase();
  }
}
