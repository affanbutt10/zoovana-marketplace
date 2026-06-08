import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../core/api/response_parser.dart';

class CheckoutService {
  // Checkout lives on marketDio (zoovana-marketplace.vercel.app/api/market)
  final Dio _dio = ApiClient().marketDio;

  Future<Map<String, dynamic>> getSummary() async {
    final response = await _dio.get(ApiEndpoints.checkoutSummaryPath);
    return ResponseParser.extractMap(response.data);
  }

  Future<Map<String, dynamic>> validateCheckout() async {
    final response = await _dio.get(ApiEndpoints.checkoutValidatePath);
    return ResponseParser.extractMap(response.data);
  }

  /// Returns available payment methods from the server.
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final response = await _dio.get(ApiEndpoints.checkoutPaymentMethodsPath);
    return ResponseParser.extractList(response.data);
  }

  /// Places an order with the given [payload]. Returns the created order data.
  Future<Map<String, dynamic>> placeOrder(Map<String, dynamic> payload) async {
    final response = await _dio.post(ApiEndpoints.checkoutPath, data: payload);
    return ResponseParser.extractMap(response.data);
  }
}
