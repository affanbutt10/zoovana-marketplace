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
import '../../data/models/order.dart';
import '../../routes/app_routes.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../shared/widgets/app_top_bar.dart';
import 'bindings/orders_binding.dart';
import 'controllers/orders_controller.dart';
import '../../../l10n/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrdersBinding.ensureInitialized();

    return Scaffold(
      appBar: AppTopBar(
        leading: IconButton(
          tooltip: AppLocalizations.of(context)?.back ?? 'Back',
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Builder(
          builder: (ctx) =>
              Text(AppLocalizations.of(ctx)?.ordersAppBarTitle ?? 'Orders'),
        ),
      ),
      body: GetBuilder<OrdersController>(
        builder: (controller) {
          if (controller.isLoading) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                children: [
                  AppShimmer.heroBanner(),
                  const SizedBox(height: AppSpacing.sectionGap),
                  AppShimmer.list(count: 3),
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
                        AppLocalizations.of(context)?.tryAgain ?? 'Try again',
                    onAction: controller.loadOrders,
                  )
                : AppStateView.error(
                    message: controller.error!,
                    actionLabel: AppLocalizations.of(context)?.retry ?? 'Retry',
                    onAction: controller.loadOrders,
                  );
          }
          if (controller.filteredOrders.isEmpty) {
            return AppStateView.empty(
              message:
                  AppLocalizations.of(context)?.ordersNoMatchingFilter ??
                  'No orders found matching this filter.',
            );
          }

          const statuses = [
            'all',
            'pending',
            'processing',
            'shipped',
            'delivered',
            'cancelled',
          ];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.base,
                  AppSpacing.screenPadding,
                  0,
                ),
                child:
                    _OrdersSummary(
                          totalCount: controller.orders.length,
                          activeCount: controller.orders
                              .where((order) => !_isClosedStatus(order.status))
                              .length,
                          deliveredCount: controller.orders
                              .where(
                                (order) =>
                                    order.status.toLowerCase() == 'delivered',
                              )
                              .length,
                        )
                        .animate()
                        .fadeIn(duration: AppMotion.medium)
                        .slideY(
                          begin: 0.1,
                          end: 0,
                          duration: AppMotion.medium,
                          curve: AppMotion.emphasis,
                        ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 52,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.sm,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: statuses.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final status = statuses[index];
                    final isActive = controller.filter == status;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          controller.setFilter(status);
                        },
                        child: AnimatedContainer(
                          duration: AppMotion.fast,
                          curve: AppMotion.emphasis,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.base,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.brand
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.brand
                                  : AppColors.borderSubtle,
                              width: isActive ? 2 : 1,
                            ),
                            boxShadow: isActive ? AppShadows.brandGlow : null,
                          ),
                          child: AnimatedDefaultTextStyle(
                            duration: AppMotion.fast,
                            curve: AppMotion.emphasis,
                            style: Theme.of(context).textTheme.labelMedium!
                                .copyWith(
                                  color: isActive
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: isActive
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                            child: Text(_localizedStatus(context, status)),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (50 * index).ms);
                  },
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppMotion.medium,
                  child: ListView.builder(
                    key: ValueKey(controller.filter),
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    itemCount: controller.filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = controller.filteredOrders[index];
                      return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.base,
                            ),
                            child: _OrderCard(order: order),
                          )
                          .animate()
                          .fadeIn(
                            duration: AppMotion.medium,
                            delay: (50 * index).ms,
                          )
                          .slideY(
                            begin: 0.1,
                            end: 0,
                            duration: AppMotion.medium,
                            delay: (50 * index).ms,
                            curve: AppMotion.emphasis,
                          );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _localizedStatus(BuildContext context, String status) {
  final l10n = AppLocalizations.of(context);
  switch (status.toLowerCase()) {
    case 'all':
      return l10n?.orderStatusAll ?? 'ALL';
    case 'pending':
      return l10n?.orderStatusPending ?? 'PENDING';
    case 'processing':
      return l10n?.orderStatusProcessing ?? 'PROCESSING';
    case 'shipped':
      return l10n?.orderStatusShipped ?? 'SHIPPED';
    case 'delivered':
      return l10n?.orderStatusDelivered ?? 'DELIVERED';
    case 'cancelled':
      return l10n?.orderStatusCancelled ?? 'CANCELLED';
    default:
      return status.toUpperCase();
  }
}

class _OrdersSummary extends StatelessWidget {
  const _OrdersSummary({
    required this.totalCount,
    required this.activeCount,
    required this.deliveredCount,
  });

  final int totalCount;
  final int activeCount;
  final int deliveredCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        border: Border.all(color: AppColors.brandSoft.withValues(alpha: 0.3)),
        boxShadow: AppShadows.elevation2,
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryValue(
              label:
                  AppLocalizations.of(context)?.ordersAllOrders ?? 'All Orders',
              value: '$totalCount',
            ),
          ),
          Expanded(
            child: _SummaryValue(
              label: AppLocalizations.of(context)?.ordersActive ?? 'Active',
              value: '$activeCount',
              highlight: activeCount > 0,
            ),
          ),
          Expanded(
            child: _SummaryValue(
              label:
                  AppLocalizations.of(context)?.ordersDelivered ?? 'Delivered',
              value: '$deliveredCount',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: highlight ? AppColors.brandDeep : AppColors.navy,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final itemCount = order.subOrders.fold<int>(
      0,
      (sum, subOrder) => sum + subOrder.items.length,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          Get.toNamed(AppRoutes.orderById(order.id));
        },
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(AppRadius.xxLarge),
            border: Border.all(
              color: AppColors.borderSubtle.withValues(alpha: 0.5),
            ),
            boxShadow: AppShadows.elevation1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order #${order.id}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _StatusPill(status: order.status),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: AppSpacing.xl,
                runSpacing: AppSpacing.sm,
                children: [
                  _InfoPair(
                    icon: Icons.calendar_today_rounded,
                    label:
                        AppLocalizations.of(context)?.orderPlaced ?? 'Placed',
                    value: DateFormat('dd MMM yyyy').format(order.placedAt),
                  ),
                  _InfoPair(
                    icon: Icons.store_mall_directory_rounded,
                    label:
                        AppLocalizations.of(context)?.orderStores ?? 'Stores',
                    value: '${order.subOrders.length}',
                  ),
                  _InfoPair(
                    icon: Icons.inventory_2_rounded,
                    label: AppLocalizations.of(context)?.orderItems ?? 'Items',
                    value: '$itemCount',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SAR ${order.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
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

class _InfoPair extends StatelessWidget {
  const _InfoPair({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        _localizedStatus(context, status),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return AppColors.warning;
    case 'processing':
    case 'shipped':
      return AppColors.info;
    case 'delivered':
      return AppColors.success;
    case 'cancelled':
      return AppColors.danger;
    default:
      return AppColors.textSecondary;
  }
}

bool _isClosedStatus(String status) {
  final normalized = status.toLowerCase();
  return normalized == 'delivered' || normalized == 'cancelled';
}
