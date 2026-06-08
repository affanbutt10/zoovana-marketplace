import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../core/api/response_parser.dart';
import '../../app/data/models/product.dart';

class ProductService {
  final Dio _dio = ApiClient().marketDio;

  Future<List<Product>> getProducts({
    int page = 1,
    int pageSize = 20,
    bool inStockOnly = false,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final response = await _dio.get(
      ApiEndpoints.productsPath,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        'in_stock_only': inStockOnly,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      },
    );
    final data = ResponseParser.extractList(response.data);
    return data.map(Product.fromJson).toList();
  }

  Future<Product> getProduct(String id, {String? categorySlug}) async {
    final path = (categorySlug == null || categorySlug.isEmpty)
        ? ApiEndpoints.productById(id)
        : ApiEndpoints.productInCategory(categorySlug, id);
    final response = await _dio.get(path);
    return Product.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['product', 'item', 'data'],
      ),
    );
  }

  Future<List<Product>> getProductsByCategory(
    String slug,
    int page,
    String sort,
  ) async {
    final response = await _dio.get(
      ApiEndpoints.productsByCategory(slug),
      queryParameters: {
        'page': page,
        'sort_by': sort,
        'sort_order': 'desc',
        'page_size': 20,
      },
    );
    final data = ResponseParser.extractList(response.data);
    return data.map(Product.fromJson).toList();
  }

  Future<List<Product>> getRelatedProducts(String id) async {
    final response = await _dio.get(ApiEndpoints.relatedProducts(id));
    final data = ResponseParser.extractList(response.data);
    return data.map(Product.fromJson).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await _dio.get(
      ApiEndpoints.searchPath,
      queryParameters: {'q': query},
    );
    final data = ResponseParser.extractList(response.data);
    return data.map(Product.fromJson).toList();
  }

  Future<List<Map<String, dynamic>>> getProductReviews(String id) async {
    final response = await _dio.get(ApiEndpoints.productReviews(id));
    return ResponseParser.extractList(response.data);
  }

  Future<Map<String, dynamic>> createProduct(
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.sellerProductsPath,
      data: payload,
    );
    return ResponseParser.extractMap(response.data);
  }

  Future<Map<String, dynamic>> updateProduct(
    String id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.put(
      ApiEndpoints.sellerProductById(id),
      data: payload,
    );
    return ResponseParser.extractMap(response.data);
  }

  Future<void> deleteProduct(String id) async {
    await _dio.delete(ApiEndpoints.sellerProductById(id));
  }
}
