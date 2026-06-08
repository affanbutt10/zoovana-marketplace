import '../../../data/models/order.dart';
import 'checkout_summary.dart';

class CheckoutViewState {
  const CheckoutViewState({
    this.step = 0,
    this.paymentMethods = const [],
    this.paymentMethod,
    this.address,
    this.summary,
    this.placedOrder,
    this.isOrderPlaced = false,
    this.isLoading = false,
    this.error,
  });

  final int step;
  final List<Map<String, dynamic>> paymentMethods;
  final String? paymentMethod;
  final Map<String, dynamic>? address;
  final CheckoutSummary? summary;
  final Order? placedOrder;
  final bool isOrderPlaced;
  final bool isLoading;
  final String? error;

  CheckoutViewState copyWith({
    int? step,
    List<Map<String, dynamic>>? paymentMethods,
    String? paymentMethod,
    Map<String, dynamic>? address,
    CheckoutSummary? summary,
    Order? placedOrder,
    bool? isOrderPlaced,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearPlacedOrder = false,
  }) {
    return CheckoutViewState(
      step: step ?? this.step,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      address: address ?? this.address,
      summary: summary ?? this.summary,
      placedOrder: clearPlacedOrder ? null : (placedOrder ?? this.placedOrder),
      isOrderPlaced: isOrderPlaced ?? this.isOrderPlaced,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
