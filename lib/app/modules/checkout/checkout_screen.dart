import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_input.dart';
import '../../../widgets/shared/premium_page_header.dart';
import '../../../widgets/shared/premium_surface_card.dart';
import '../../../widgets/shared/sticky_action_bar.dart';
import '../cart/cart_screen.dart';
import 'bindings/checkout_binding.dart';
import 'controllers/checkout_controller.dart';
import 'models/checkout_summary.dart';
import '../../../l10n/app_localizations.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    CheckoutBinding.ensureInitialized();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (controller) {
        final state = controller.state;

        if (state.isOrderPlaced) {
          return Scaffold(
            backgroundColor: AppColors.surfaceBase,
            body: _buildSuccess(context, controller),
          );
        }

        if (state.isLoading && state.summary == null && state.step == 0) {
          return const Scaffold(
            backgroundColor: AppColors.surfaceBase,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.surfaceBase,
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Premium Header with Stepper
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PremiumPageHeader(
                          title:
                              AppLocalizations.of(context)?.checkoutTitle ??
                              'Checkout',
                          subtitle:
                              AppLocalizations.of(context)?.checkoutSubtitle ??
                              'Complete your order in just a few steps',
                          leading: IconButton(
                            tooltip:
                                AppLocalizations.of(context)?.back ?? 'Back',
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.screenPadding,
                            0,
                            AppSpacing.screenPadding,
                            AppSpacing.xl,
                          ),
                          child: _PremiumStepper(currentStep: state.step),
                        ),
                      ],
                    ),
                  ),

                  // Main Content
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      AppSpacing.heroGap,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (state.error != null)
                            _buildErrorBanner(context, state.error!),

                          if (state.step == 0)
                            _buildAddressForm(context, controller)
                          else if (state.step == 1)
                            _buildPaymentMethods(context, controller)
                          else
                            _buildReview(context, controller),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Fixed Bottom Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomBar(context, controller),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorBanner(BuildContext context, String error) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.danger,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildAddressForm(
    BuildContext context,
    CheckoutController controller,
  ) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)?.checkoutShippingAddress ??
                'Shipping Address',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context)?.checkoutShippingSubtitle ??
                'Enter your delivery information',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Premium Form Container
          PremiumSurfaceCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppInput(
                      controller: controller.nameController,
                      focusNode: controller.nameFocusNode,
                      label:
                          AppLocalizations.of(context)?.checkoutFullName ??
                          'Full Name',
                      hintText: AppLocalizations.of(
                        context,
                      )!.checkoutFullNameHint,
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          controller.phoneFocusNode.requestFocus(),
                      validator: (v) => v == null || v.isEmpty
                          ? (AppLocalizations.of(context)?.checkoutRequired ??
                                'Required')
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppInput(
                      controller: controller.phoneController,
                      focusNode: controller.phoneFocusNode,
                      label:
                          AppLocalizations.of(context)?.checkoutPhone ??
                          'Phone Number',
                      hintText: AppLocalizations.of(context)!.checkoutPhoneHint,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          controller.streetFocusNode.requestFocus(),
                      validator: (v) {
                        final value = v?.trim() ?? '';
                        if (value.isEmpty) {
                          return AppLocalizations.of(
                                context,
                              )?.checkoutRequired ??
                              'Required';
                        }
                        final normalized = value.replaceAll(' ', '');
                        final isSaudiMobile = RegExp(
                          r'^(05\d{8}|\+9665\d{8}|9665\d{8})$',
                        ).hasMatch(normalized);
                        return isSaudiMobile
                            ? null
                            : AppLocalizations.of(context)?.phoneInvalid ??
                                  'Please enter a valid Saudi phone number (05XXXXXXXX)';
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppInput(
                      controller: controller.emailController,
                      label: 'Email (optional)',
                      hintText: 'customer@example.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          controller.streetFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppInput(
                      controller: controller.streetController,
                      focusNode: controller.streetFocusNode,
                      label:
                          AppLocalizations.of(context)?.checkoutStreet ??
                          'Street Address',
                      hintText: AppLocalizations.of(
                        context,
                      )!.checkoutStreetHint,
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          controller.districtFocusNode.requestFocus(),
                      validator: (v) => v == null || v.isEmpty
                          ? (AppLocalizations.of(context)?.checkoutRequired ??
                                'Required')
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppInput(
                      controller: controller.districtController,
                      focusNode: controller.districtFocusNode,
                      label:
                          AppLocalizations.of(context)?.checkoutDistrict ??
                          'District',
                      hintText:
                          AppLocalizations.of(context)?.checkoutDistrictHint ??
                          'District',
                      prefixIcon: const Icon(Icons.map_outlined),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          controller.cityFocusNode.requestFocus(),
                      validator: (v) => v == null || v.isEmpty
                          ? (AppLocalizations.of(context)?.checkoutRequired ??
                                'Required')
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppInput(
                            controller: controller.cityController,
                            focusNode: controller.cityFocusNode,
                            label:
                                AppLocalizations.of(context)?.checkoutCity ??
                                'City',
                            hintText: AppLocalizations.of(
                              context,
                            )!.checkoutCityHint,
                            prefixIcon: const Icon(
                              Icons.location_city_outlined,
                            ),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                controller.postalFocusNode.requestFocus(),
                            validator: (v) => v == null || v.isEmpty
                                ? (AppLocalizations.of(
                                        context,
                                      )?.checkoutRequired ??
                                      'Required')
                                : null,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: AppInput(
                            controller: controller.postalController,
                            focusNode: controller.postalFocusNode,
                            label:
                                AppLocalizations.of(
                                  context,
                                )?.checkoutPostalCode ??
                                'Postal Code',
                            hintText:
                                AppLocalizations.of(
                                  context,
                                )?.checkoutPostalCodeHint ??
                                'Postal code',
                            prefixIcon: const Icon(
                              Icons.markunread_mailbox_outlined,
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validator: (v) => v == null || v.isEmpty
                                ? (AppLocalizations.of(
                                        context,
                                      )?.checkoutRequired ??
                                      'Required')
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppInput(
                      controller: controller.notesController,
                      label: 'Delivery notes (optional)',
                      hintText: 'Call before delivery',
                      prefixIcon: const Icon(Icons.notes_outlined),
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping_outlined,
                          color: AppColors.brand,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(
                                  context,
                                )?.checkoutDeliveryEstimate ??
                                'Estimated delivery: 2-4 business days',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
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
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(
    BuildContext context,
    CheckoutController controller,
  ) {
    final state = controller.state;

    if (state.isLoading && state.paymentMethods.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.checkoutPaymentMethod ??
              'Payment Method',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppLocalizations.of(context)?.checkoutPaymentSubtitle ??
              'Select your preferred payment option',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        if (state.paymentMethods.isEmpty)
          Text(
            AppLocalizations.of(context)?.checkoutNoPaymentMethods ??
                'No payment methods available.',
          )
        else
          ...state.paymentMethods.asMap().entries.map((entry) {
            final index = entry.key;
            final method = entry.value;
            final isSelected = state.paymentMethod == method['id'];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child:
                  Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppRadius.xLarge),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            controller.selectPaymentMethod(method['id']);
                          },
                          child: AnimatedContainer(
                            duration: AppMotion.fast,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColors.brand.withValues(alpha: 0.1),
                                        Colors.white,
                                      ],
                                    )
                                  : null,
                              color: isSelected ? null : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.brand
                                    : AppColors.borderSubtle.withValues(
                                        alpha: 0.3,
                                      ),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.brand.withValues(
                                          alpha: 0.15,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.03,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.brand.withValues(alpha: 0.1)
                                        : AppColors.surfaceRaised,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    _paymentMethodIcon(method['id']?.toString()),
                                    color: isSelected
                                        ? AppColors.brand
                                        : AppColors.textMain,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _paymentMethodTitle(context, method),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                              fontWeight: isSelected
                                                  ? FontWeight.w800
                                                  : FontWeight.w600,
                                              color: isSelected
                                                  ? AppColors.brand
                                                  : AppColors.textMain,
                                              fontSize: 16,
                                            ),
                                      ),
                                      if (method['description'] != null)
                                        Text(
                                          _paymentMethodDescription(
                                            context,
                                            method,
                                          ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.brand.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.brand,
                                      size: 24,
                                    ),
                                  ).animate().fadeIn().scale(),
                              ],
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(
                        duration: AppMotion.medium,
                        delay: (60 * index).ms,
                      )
                      .slideY(
                        begin: 0.1,
                        end: 0,
                        duration: AppMotion.medium,
                        delay: (60 * index).ms,
                      ),
            );
          }),

        const SizedBox(height: AppSpacing.xl),

        // Order Summary
        Text(
          AppLocalizations.of(context)?.checkoutOrderSummary ?? 'Order Summary',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: AppSpacing.base),

        PremiumSurfaceCard(
          padding: const EdgeInsets.all(24),
          child: controller.summary != null
              ? CheckoutOrderTotals(summary: controller.summary!)
              : controller.cart != null
                  ? CartTotals(cart: controller.cart!)
                  : const SizedBox(),
        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildReview(BuildContext context, CheckoutController controller) {
    final state = controller.state;
    final address = state.address ?? const <String, dynamic>{};
    final paymentMethod = state.paymentMethods.firstWhereOrNull(
      (method) => method['id'] == state.paymentMethod,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)?.checkoutReview ?? 'Review',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        PremiumSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewLine(
                label:
                    AppLocalizations.of(context)?.checkoutFullName ??
                    'Full Name',
                value: address['name']?.toString() ?? '',
              ),
              _ReviewLine(
                label:
                    AppLocalizations.of(context)?.checkoutPhone ??
                    'Phone Number',
                value: address['phone']?.toString() ?? '',
              ),
              _ReviewLine(
                label:
                    AppLocalizations.of(context)?.checkoutStreet ??
                    'Street Address',
                value: address['street']?.toString() ?? '',
              ),
              _ReviewLine(
                label:
                    AppLocalizations.of(context)?.checkoutDistrict ??
                    'District',
                value: address['district']?.toString() ?? '',
              ),
              _ReviewLine(
                label: AppLocalizations.of(context)?.checkoutCity ?? 'City',
                value: address['city']?.toString() ?? '',
              ),
              _ReviewLine(
                label:
                    AppLocalizations.of(context)?.checkoutPostalCode ??
                    'Postal Code',
                value: address['postal_code']?.toString() ?? '',
              ),
              _ReviewLine(
                label:
                    AppLocalizations.of(context)?.checkoutPaymentMethod ??
                    'Payment Method',
                value: paymentMethod == null
                    ? ''
                    : _paymentMethodTitle(context, paymentMethod),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppLocalizations.of(context)?.checkoutOrderSummary ?? 'Order Summary',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        PremiumSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: controller.summary != null
              ? CheckoutOrderTotals(summary: controller.summary!)
              : controller.cart != null
                  ? CartTotals(cart: controller.cart!)
                  : const SizedBox.shrink(),
        ),
        const SizedBox(height: AppSpacing.base),
        Row(
          children: [
            const Icon(Icons.lock_outline_rounded, color: AppColors.success),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                AppLocalizations.of(context)?.checkoutSecurePayment ??
                    'Your payment is secure',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _paymentMethodTitle(
    BuildContext context,
    Map<String, dynamic> method,
  ) {
    return switch (method['id']) {
      'credit_card' =>
        AppLocalizations.of(context)?.checkoutCreditCard ?? 'Credit card',
      'debit_card' => 'Debit card',
      'apple_pay' => 'Apple Pay',
      'cash_on_delivery' =>
        AppLocalizations.of(context)?.checkoutCashOnDelivery ??
            'Cash on delivery',
      _ => (method['title'] ?? method['name'] ?? 'Unknown').toString(),
    };
  }

  String _paymentMethodDescription(
    BuildContext context,
    Map<String, dynamic> method,
  ) {
    return switch (method['id']) {
      'credit_card' =>
        AppLocalizations.of(context)?.checkoutCreditCardDescription ??
            'Pay securely by card',
      'debit_card' => 'Pay with your debit card',
      'apple_pay' => 'Pay with Apple Pay',
      'cash_on_delivery' =>
        AppLocalizations.of(context)?.checkoutCashOnDeliveryDescription ??
            'Pay when your order arrives',
      _ => (method['description'] ?? '').toString(),
    };
  }

  IconData _paymentMethodIcon(String? id) {
    return switch (id) {
      'cash_on_delivery' => Icons.payments_outlined,
      'apple_pay' => Icons.phone_iphone_outlined,
      'debit_card' => Icons.account_balance_outlined,
      _ => Icons.credit_card_outlined,
    };
  }

  Widget _buildSuccess(BuildContext context, CheckoutController controller) {
    final order = controller.state.placedOrder;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.success.withValues(alpha: 0.15),
                        AppColors.success.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                )
                .animate()
                .scale(duration: 500.ms, curve: AppMotion.emphasis)
                .fadeIn(),

            const SizedBox(height: 28),

            Text(
              AppLocalizations.of(context)?.checkoutOrderPlacedTitle ??
                  'Order Placed Successfully!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 28,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 12),

            if (order != null && order.orderNumber.isNotEmpty) ...[
              Text(
                order.orderNumber,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.brand,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${order.currency} ${order.total.toStringAsFixed(2)} · ${order.paymentStatus}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],

            Text(
              AppLocalizations.of(context)?.checkoutOrderPlacedSubtitle ??
                  'Thank you for your purchase. We have received your order and will process it shortly.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 32),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brand.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: AppButton(
                label:
                    AppLocalizations.of(context)?.checkoutBackToShop ??
                    'Back to Shop',
                onPressed: () => Get.offAllNamed('/home'),
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 12),

            AppButton(
              label:
                  AppLocalizations.of(context)?.checkoutViewOrders ??
                  'View Orders',
              variant: AppButtonVariant.secondary,
              onPressed: () {
                if (order != null && order.id.isNotEmpty) {
                  Get.offNamed('/orders/${order.id}');
                } else {
                  Get.offNamed('/orders');
                }
              },
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CheckoutController controller) {
    final state = controller.state;

    return StickyActionBar(
      child: Row(
        children: [
          if (state.step > 0) ...[
            Expanded(
              flex: 1,
              child: AppButton(
                label: AppLocalizations.of(context)?.checkoutBack ?? 'Back',
                variant: AppButtonVariant.secondary,
                onPressed: controller.backStep,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: state.step > 0 ? 2 : 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brand.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: AppButton(
                label: state.step == 0
                    ? (AppLocalizations.of(
                            context,
                          )?.checkoutContinueToPayment ??
                          'Continue to Payment')
                    : state.step == 1
                    ? (AppLocalizations.of(context)?.checkoutContinueToReview ??
                          'Continue to Review')
                    : (AppLocalizations.of(context)?.checkoutPlaceOrder ??
                          'Place Order'),
                isLoading: state.isLoading,
                icon: const Icon(Icons.arrow_forward_rounded),
                onPressed: () {
                  if (state.step == 0) {
                    controller.continueToPayment();
                  } else if (state.step == 1) {
                    controller.continueToReview(
                      AppLocalizations.of(context)?.checkoutSelectPayment ??
                          'Please select a payment method.',
                    );
                  } else {
                    controller.placeOrder(
                      AppLocalizations.of(context)?.checkoutCompleteDetails ??
                          'Please complete all checkout details.',
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    ).animate().slideY(
      begin: 1.0,
      end: 0,
      duration: AppMotion.heroTransition,
      curve: AppMotion.emphasis,
    );
  }
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMain,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Premium Stepper ───
class _PremiumStepper extends StatelessWidget {
  const _PremiumStepper({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final steps = [
      l10n?.checkoutAddress ?? 'Address',
      l10n?.checkoutPayment ?? 'Payment',
      l10n?.checkoutReview ?? 'Review',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final isHighlighted = index ~/ 2 < currentStep;
            return Expanded(
              child: AnimatedContainer(
                duration: AppMotion.medium,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 2,
                decoration: BoxDecoration(
                  gradient: isHighlighted
                      ? LinearGradient(
                          colors: [
                            AppColors.brand,
                            AppColors.brand.withValues(alpha: 0.7),
                          ],
                        )
                      : null,
                  color: isHighlighted
                      ? null
                      : AppColors.borderSubtle.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final isActive = stepIndex == currentStep;
          final isDone = stepIndex < currentStep;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: AppMotion.medium,
                curve: AppMotion.emphasis,
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: isDone || isActive
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.brand,
                            AppColors.brand.withValues(alpha: 0.8),
                          ],
                        )
                      : null,
                  color: isDone || isActive ? null : AppColors.surfaceRaised,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone || isActive
                        ? AppColors.brand
                        : AppColors.borderSubtle,
                    width: isActive ? 2 : 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.brand.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        )
                      : Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: AppMotion.medium,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: isActive
                      ? AppColors.brand
                      : (isDone
                            ? AppColors.textPrimary
                            : AppColors.textSecondary),
                  fontWeight: isActive || isDone
                      ? FontWeight.w700
                      : FontWeight.w500,
                  fontSize: 11,
                ),
                child: Text(steps[stepIndex]),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Order totals from GET /checkout/summary (backend source of truth).
class CheckoutOrderTotals extends StatelessWidget {
  const CheckoutOrderTotals({super.key, required this.summary});

  final CheckoutSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        _CheckoutTotalRow(
          label: l10n?.cartSubtotal ?? 'Subtotal',
          value: '${summary.currency} ${summary.subtotal.toStringAsFixed(2)}',
        ),
        if (summary.discountAmount > 0)
          _CheckoutTotalRow(
            label: l10n?.cartDiscount ?? 'Discount',
            value:
                '- ${summary.currency} ${summary.discountAmount.toStringAsFixed(2)}',
            valueColor: AppColors.error,
          ),
        if (summary.taxAmount > 0)
          _CheckoutTotalRow(
            label: 'Tax',
            value: '${summary.currency} ${summary.taxAmount.toStringAsFixed(2)}',
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Divider(color: AppColors.borderSubtle.withValues(alpha: 0.5)),
        ),
        _CheckoutTotalRow(
          label: l10n?.cartTotal ?? 'Total',
          value: '${summary.currency} ${summary.total.toStringAsFixed(2)}',
          valueColor: AppColors.textMain,
          isBold: true,
        ),
      ],
    );
  }
}

class _CheckoutTotalRow extends StatelessWidget {
  const _CheckoutTotalRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isBold ? AppColors.textMain : AppColors.textSecondary,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
