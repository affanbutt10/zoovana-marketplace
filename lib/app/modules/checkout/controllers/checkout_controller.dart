import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/errors/app_error_mapper.dart';
import '../../../data/models/cart.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/checkout_repository.dart';
import '../models/checkout_summary.dart';
import '../models/checkout_view_state.dart';

class CheckoutController extends GetxController {
  CheckoutController({
    required this.checkoutRepository,
    required this.cartRepository,
  });

  final CheckoutRepository checkoutRepository;
  final CartRepository cartRepository;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final streetController = TextEditingController();
  final districtController = TextEditingController();
  final cityController = TextEditingController();
  final postalController = TextEditingController();
  final notesController = TextEditingController();
  final nameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final streetFocusNode = FocusNode();
  final districtFocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final postalFocusNode = FocusNode();

  CheckoutViewState state = const CheckoutViewState();
  bool _isPlacingOrder = false;

  Cart? get cart => cartRepository.snapshot.cart;

  CheckoutSummary? get summary => state.summary;

  @override
  void onInit() {
    super.onInit();
    cartRepository.addListener(_onCartChanged);
    _initializeCheckout();
  }

  Future<void> _initializeCheckout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    update();
    try {
      await cartRepository.loadCart();
      final validation = await checkoutRepository.validateCheckout();
      if (validation['valid'] == false) {
        final issues = validation['issues'];
        state = state.copyWith(
          isLoading: false,
          error: _formatIssues(issues),
        );
        update();
        return;
      }

      final summaryData = await checkoutRepository.getSummary();
      final summary = CheckoutSummary.fromJson(summaryData);
      final methods = await checkoutRepository.getPaymentMethods();
      final availableIds = summary.availablePaymentMethods.toSet();

      state = state.copyWith(
        isLoading: false,
        summary: summary,
        paymentMethods: _normalizePaymentMethods(methods, availableIds),
        paymentMethod: _defaultPaymentMethod(
          _normalizePaymentMethods(methods, availableIds),
        ),
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: AppErrorMapper.map(error).message,
      );
    }
    update();
  }

  Future<void> loadPaymentMethods() => _initializeCheckout();

  void selectPaymentMethod(String id) {
    state = state.copyWith(paymentMethod: id);
    update();
  }

  void backStep() {
    if (state.step == 0) {
      return;
    }
    state = state.copyWith(step: state.step - 1);
    update();
  }

  void continueToPayment() {
    final formState = formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    state = state.copyWith(
      step: 1,
      address: {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'street': streetController.text.trim(),
        'district': districtController.text.trim(),
        'city': cityController.text.trim(),
        'postal_code': postalController.text.trim(),
        'notes': notesController.text.trim(),
      },
      clearError: true,
    );
    update();
  }

  void continueToReview(String missingPaymentMessage) {
    if (state.paymentMethod == null) {
      state = state.copyWith(error: missingPaymentMessage);
      update();
      return;
    }
    state = state.copyWith(step: 2, clearError: true);
    update();
  }

  Future<void> placeOrder(String incompleteMessage) async {
    if (_isPlacingOrder) return;
    if (state.address == null || state.paymentMethod == null) {
      state = state.copyWith(error: incompleteMessage);
      update();
      return;
    }

    _isPlacingOrder = true;
    state = state.copyWith(isLoading: true, clearError: true);
    update();
    try {
      final addr = state.address!;
      final shippingAddress = <String, dynamic>{
        'full_name': addr['name']?.toString() ?? '',
        'phone_number': addr['phone']?.toString() ?? '',
        'address_line_1': addr['street']?.toString() ?? '',
        'city': addr['city']?.toString() ?? '',
        'state_province': addr['district']?.toString() ?? '',
        'postal_code': addr['postal_code']?.toString() ?? '',
        'country': 'SA',
        'address_type': 'home',
        'is_default': true,
      };

      final email = addr['email']?.toString() ?? '';
      if (email.isNotEmpty) {
        shippingAddress['email'] = email;
      }

      final notes = addr['notes']?.toString() ?? '';
      final order = await checkoutRepository.placeOrder({
        'payment_method': state.paymentMethod,
        'shipping_address': shippingAddress,
        'save_address': true,
        if (notes.isNotEmpty) 'notes': notes,
      });

      await cartRepository.clearCart();
      state = state.copyWith(
        isLoading: false,
        isOrderPlaced: true,
        placedOrder: order,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: AppErrorMapper.map(error).message,
      );
    } finally {
      _isPlacingOrder = false;
    }
    update();
  }

  void _onCartChanged() {
    update();
  }

  List<Map<String, dynamic>> _normalizePaymentMethods(
    List<Map<String, dynamic>> methods,
    Set<String> summaryMethodIds,
  ) {
    final normalized = methods
        .where((method) {
          final available = method['is_available'];
          if (available == false) return false;
          if (summaryMethodIds.isEmpty) return true;
          final id = method['id']?.toString() ?? '';
          return summaryMethodIds.contains(id);
        })
        .map((method) {
          return {
            'id': method['id'],
            'title': method['name'] ?? method['title'] ?? method['id'],
            'description': method['description'] ?? '',
          };
        })
        .toList();

    if (normalized.isNotEmpty) return normalized;

    return _fallbackPaymentMethods(summaryMethodIds);
  }

  List<Map<String, dynamic>> _fallbackPaymentMethods(Set<String> ids) {
    const all = [
      {
        'id': 'credit_card',
        'title': 'Credit Card',
        'description': 'Pay with Visa, Mastercard, or AMEX',
      },
      {
        'id': 'debit_card',
        'title': 'Debit Card',
        'description': 'Pay with your debit card',
      },
      {
        'id': 'apple_pay',
        'title': 'Apple Pay',
        'description': 'Pay with Apple Pay',
      },
      {
        'id': 'cash_on_delivery',
        'title': 'Cash on Delivery',
        'description': 'Pay when you receive your order',
      },
    ];
    if (ids.isEmpty) return all;
    return all.where((m) => ids.contains(m['id'])).toList();
  }

  String? _defaultPaymentMethod(List<Map<String, dynamic>> methods) {
    if (methods.isEmpty) return null;
    return methods.first['id']?.toString();
  }

  String _formatIssues(dynamic issues) {
    if (issues is! List || issues.isEmpty) {
      return 'Checkout is not available for your cart. Please review your items.';
    }
    return issues.map((e) => e.toString()).join('\n');
  }

  @override
  void onClose() {
    cartRepository.removeListener(_onCartChanged);
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    streetController.dispose();
    districtController.dispose();
    cityController.dispose();
    postalController.dispose();
    notesController.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    streetFocusNode.dispose();
    districtFocusNode.dispose();
    cityFocusNode.dispose();
    postalFocusNode.dispose();
    super.onClose();
  }
}
