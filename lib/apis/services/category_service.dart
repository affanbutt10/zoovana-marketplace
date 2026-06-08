import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../core/api_endpoints.dart';
import '../../core/api/response_parser.dart';
import '../../app/data/models/category.dart';
import '../../app/data/models/product.dart';

class CategoryService {
  final Dio _dio = ApiClient().marketDio;

  /// GET /catalog/categories
  /// Real params: page, page_size, with_products_only
  Future<List<Category>> getCategories({
    int page = 1,
    int pageSize = 50,
    bool withProductsOnly = false,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.categoriesPath,
      queryParameters: {
        'page': page,
        'page_size': pageSize,
        'with_products_only': withProductsOnly,
      },
    );
    // Response: { success, data: [...], meta: {...} }
    final data = ResponseParser.extractList(response.data);
    return data.map(Category.fromJson).toList();
  }

  Future<Category> getCategory(String slug) async {
    final response = await _dio.get(ApiEndpoints.categoryBySlug(slug));
    return Category.fromJson(
      ResponseParser.extractMap(
        response.data,
        candidateKeys: const ['category', 'data'],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getCategoryBreadcrumbs(String slug) async {
    final response = await _dio.get(ApiEndpoints.categoryBreadcrumbs(slug));
    return ResponseParser.extractList(response.data);
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
}
