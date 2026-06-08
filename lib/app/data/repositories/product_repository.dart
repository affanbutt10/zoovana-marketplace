import '../../../apis/services/product_service.dart';
import '../../core/services/cache_service.dart';
import '../../core/services/timed_cache_service.dart';
import '../models/product.dart';

/// All data comes directly from the backend API.
/// On network failure the timed cache is used as a read-through layer.
/// If no cache exists the error is re-thrown so the UI can show it.
class ProductRepository {
  ProductRepository({required this.service, this.cacheService});

  final ProductService service;
  final CacheService? cacheService;

  TimedCacheService? get _timed => cacheService != null
      ? TimedCacheService(cacheService!.prefs)
      : null;

  Future<List<Product>> getProducts({int page = 1, int limit = 20}) async {
    final cacheKey = 'products-$page-$limit';
    try {
      final products = await service.getProducts(page: page, pageSize: limit);
      await _timed?.write(
        cacheKey,
        products.map((p) => p.toJson()).toList(),
        ttl: TimedCacheService.ttlProducts,
      );
      return products;
    } catch (e) {
      final cached =
          _timed?.readList(cacheKey) ?? cacheService?.readJsonList(cacheKey);
      if (cached != null) {
        return cached
            .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      rethrow;
    }
  }

  Future<List<Product>> getFeaturedProducts({
    int page = 1,
    int limit = 8,
  }) async {
    final cacheKey = 'featured-$page-$limit';
    try {
      final products = await service.getProducts(
        page: page,
        pageSize: limit * 2,
      );
      final featured = products.where((p) => p.isFeatured).toList();
      final result = featured.isNotEmpty
          ? featured.take(limit).toList()
          : products.take(limit).toList();
      await _timed?.write(
        cacheKey,
        result.map((p) => p.toJson()).toList(),
        ttl: TimedCacheService.ttlProducts,
      );
      return result;
    } catch (e) {
      final cached =
          _timed?.readList(cacheKey) ?? cacheService?.readJsonList(cacheKey);
      if (cached != null) {
        return cached
            .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      rethrow;
    }
  }

  Future<Product> getProduct(String id) async {
    final cacheKey = 'product-$id';
    try {
      final product = await service.getProduct(id);
      await _timed?.write(
        cacheKey,
        product.toJson(),
        ttl: TimedCacheService.ttlProduct,
      );
      return product;
    } catch (e) {
      final cached =
          _timed?.readMap(cacheKey) ?? cacheService?.readJsonMap(cacheKey);
      if (cached != null) return Product.fromJson(cached);
      rethrow;
    }
  }

  Future<List<Product>> getRelatedProducts(String id) async {
    try {
      return await service.getRelatedProducts(id);
    } catch (e) {
      // Related products are non-critical — return empty on failure
      // so the product detail screen still loads.
      return const [];
    }
  }

  Future<List<Map<String, dynamic>>> getProductReviews(String id) async {
    try {
      return await service.getProductReviews(id);
    } catch (e) {
      // Reviews are non-critical — return empty on failure.
      return const [];
    }
  }

  Future<Map<String, dynamic>> createProduct(Map<String, dynamic> payload) {
    return service.createProduct(payload);
  }

  Future<Map<String, dynamic>> updateProduct(
    String id,
    Map<String, dynamic> payload,
  ) {
    return service.updateProduct(id, payload);
  }

  Future<void> deleteProduct(String id) {
    return service.deleteProduct(id);
  }

  Future<List<Product>> searchProducts(String query) async {
    final cacheKey = 'search-$query';
    try {
      final products = await service.searchProducts(query);
      await _timed?.write(
        cacheKey,
        products.map((p) => p.toJson()).toList(),
        ttl: TimedCacheService.ttlSearch,
      );
      return products;
    } catch (e) {
      final cached =
          _timed?.readList(cacheKey) ?? cacheService?.readJsonList(cacheKey);
      if (cached != null) {
        return cached
            .map((item) => Product.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
      rethrow;
    }
  }
}
