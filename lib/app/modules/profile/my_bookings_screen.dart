import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/booking.dart';
import '../../shared/widgets/app_shimmer.dart';
import '../../shared/widgets/app_state_view.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../../l10n/app_localizations.dart';
import 'bindings/bookings_binding.dart';
import 'controllers/bookings_controller.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  @override
  void initState() {
    super.initState();
    BookingsBinding.ensureInitialized();
  }

  IconData _getServiceIcon(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('groom') ||
        name.contains('spa') ||
        name.contains('bath')) {
      return Icons.spa_rounded;
    }
    if (name.contains('vet') ||
        name.contains('doctor') ||
        name.contains('consult')) {
      return Icons.local_hospital_rounded;
    }
    if (name.contains('train')) {
      return Icons.sports_rounded;
    }
    return Icons.calendar_month_rounded;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'upcoming':
      case 'confirmed':
      case 'scheduled':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
      case 'canceled':
        return AppColors.danger;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return GetBuilder<BookingsController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.surfaceBase,
          appBar: AppTopBar(
            leading: IconButton(
              tooltip: l10n?.back ?? 'Back',
              onPressed: Get.back,
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
            title: Text(
              l10n?.myBookingsTitle ?? 'My Bookings',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          body: _buildBody(context, controller, l10n),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    BookingsController controller,
    AppLocalizations? l10n,
  ) {
    if (controller.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: AppShimmer.list(count: 4),
      );
    }

    if (controller.error != null && controller.bookings.isEmpty) {
      return AppStateView.error(
        message: controller.error!,
        actionLabel: l10n?.retry ?? 'Retry',
        onAction: controller.loadBookings,
      );
    }

    if (controller.bookings.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.loadBookings,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.18),
            AppStateView.empty(
              title: l10n?.myBookingsTitle ?? 'My Bookings',
              message:
                  l10n?.noBookingsFound ??
                  'No bookings found. Book a service to get started!',
              icon: Icons.calendar_month_rounded,
            ),
          ],
        ),
      );
    }

    final sortedBookings = List<Booking>.from(controller.bookings)
      ..sort((a, b) {
        if (a.isUpcoming && !b.isUpcoming) return -1;
        if (!a.isUpcoming && b.isUpcoming) return 1;
        return b.dateTime.compareTo(a.dateTime);
      });

    return RefreshIndicator(
      onRefresh: controller.loadBookings,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: sortedBookings.length + (controller.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= sortedBookings.length) {
            if (controller.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.loadMore();
            });
            return const SizedBox.shrink();
          }

          final booking = sortedBookings[index];
          return _BookingCard(
                booking: booking,
                serviceIcon: _getServiceIcon(booking.serviceName),
                statusColor: _getStatusColor(booking.status),
              )
              .animate()
              .fadeIn(delay: (index * 80).ms)
              .slideY(
                begin: 0.1,
                end: 0,
                duration: AppMotion.medium,
                curve: AppMotion.emphasis,
              );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.serviceIcon,
    required this.statusColor,
  });

  final Booking booking;
  final IconData serviceIcon;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat(
      'dd MMMM yyyy, hh:mm a',
    ).format(booking.dateTime);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadius.xxLarge),
        border: Border.all(
          color: AppColors.brand.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: AppShadows.elevation1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: Icon(serviceIcon, color: statusColor, size: 20),
                ),
                const SizedBox(width: AppSpacing.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.serviceName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        booking.providerName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Text(
                    booking.displayStatus,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: AppSpacing.xl),
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
