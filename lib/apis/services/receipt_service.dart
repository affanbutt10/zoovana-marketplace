import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../core/api/response_parser.dart';
import '../../app/data/models/receipt.dart';

class ReceiptService {
  // Receipts live on marketDio (zoovana-marketplace.vercel.app/api/market)
  final Dio _dio = ApiClient().marketDio;
  final Dio _printDio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.mobileApiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'text/html,application/xhtml+xml'},
    ),
  );

  /// GET /my/receipts?page=1&page_size=12
  /// Response: { success, data: { items: [], pagination: {...} } }
  Future<List<Receipt>> getReceipts({int page = 1, int pageSize = 12}) async {
    final response = await _dio.get(
      ApiEndpoints.receiptsPath,
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    // data is { items: [], pagination: {} }
    final dataMap = ResponseParser.extractMap(
      response.data,
      candidateKeys: const ['data'],
    );
    final items = ResponseParser.extractList(
      dataMap,
      candidateKeys: const ['items'],
    );
    return items.map(Receipt.fromJson).toList();
  }

  /// GET /my/receipts/order/{orderId}
  /// Response: { success, data: { id, receipt_number, ... } }  — single object
  Future<List<Receipt>> getReceiptsByOrder(String orderId) async {
    final response = await _dio.get(ApiEndpoints.receiptsByOrder(orderId));
    final dataMap = ResponseParser.extractMap(
      response.data,
      candidateKeys: const ['data', 'receipt'],
    );
    return [Receipt.fromJson(dataMap)];
  }

  Future<Receipt> getReceipt(String id) async {
    final response = await _dio.get(ApiEndpoints.receiptById(id));
    return Receipt.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['receipt', 'data'],
      ),
    );
  }

  Future<Uint8List> getReceiptPdf(String id) async {
    final response = await _dio.get<List<int>>(
      ApiEndpoints.receiptPdf(id),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  }

  Future<String> getReceiptPrintHtml(String id) async {
    final path = ApiEndpoints.receiptPrint(id);
    debugPrint(
      '[ReceiptService] getReceiptPrintHtml — GET '
      '${ApiEndpoints.mobileApiBaseUrl}$path',
    );
    try {
      final response = await _getReceiptPrintHtml(path);
      debugPrint(
        '[ReceiptService] getReceiptPrintHtml — status: ${response.statusCode} | '
        'length: ${response.data?.length ?? 0}',
      );
      return response.data ?? '';
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        debugPrint(
          '[ReceiptService] getReceiptPrintHtml — unauthenticated print failed, retrying with token',
        );
        final token = await ApiClient().secureStorage.read(key: 'access_token');
        if (token != null && token.isNotEmpty) {
          final response = await _getReceiptPrintHtml(
            path,
            authorization: 'Bearer $token',
          );
          debugPrint(
            '[ReceiptService] getReceiptPrintHtml — token retry status: ${response.statusCode} | '
            'length: ${response.data?.length ?? 0}',
          );
          return response.data ?? '';
        }
      }
      debugPrint(
        '[ReceiptService] getReceiptPrintHtml — DioException: ${e.type} | '
        'status: ${e.response?.statusCode} | message: ${e.message}',
      );
      rethrow;
    }
  }

  Future<Response<String>> _getReceiptPrintHtml(
    String path, {
    String? authorization,
  }) {
    return _printDio.get<String>(
      path,
      options: Options(
        responseType: ResponseType.plain,
        headers: {'Authorization': ?authorization},
      ),
    );
  }

  /// GET /orders/{orderId}/pdf — order invoice PDF.
  Future<Uint8List> getOrderPdf(String orderId) async {
    final response = await _dio.get<List<int>>(
      ApiEndpoints.orderPdf(orderId),
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data ?? const []);
  }
}
