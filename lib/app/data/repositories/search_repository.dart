import '../../../apis/services/product_service.dart';
import '../../core/services/cache_service.dart';
import '../mock/app_mock_data.dart';
import '../models/product.dart';

class SearchRepository {
  SearchRepository({required this.service, this.cacheService});

  final ProductService service;
  final CacheService? cacheService;

  Future<List<Product>> loadAllProducts({
    int page = 1,
    int pageSize = 20,
    bool inStockOnly = false,
    String sortBy = 'created_at',
    String sortOrder = 'desc',
  }) async {
    final cacheKey = 'products-$page-$pageSize';
    try {
      final products = await service.getProducts(
        page: page,
        pageSize: pageSize,
        inStockOnly: inStockOnly,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      await cacheService?.writeJson(
        cacheKey,
        products.map((item) => item.toJson()).toList(),
      );
      return products;
    } catch (_) {
      final cached = cacheService?.readJsonList(cacheKey);
      if (cached != null) {
        return cached
            .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      return AppMockData.search('');
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return loadAllProducts();
    }

    final cacheKey = 'search-$query';
    try {
      final products = await service.searchProducts(query);
      if (products.isEmpty) {
        return AppMockData.search(query);
      }
      await cacheService?.writeJson(
        cacheKey,
        products.map((item) => item.toJson()).toList(),
      );
      return products;
    } catch (_) {
      final cached = cacheService?.readJsonList(cacheKey);
      if (cached != null) {
        return cached
            .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      return AppMockData.search(query);
    }
  }
}
