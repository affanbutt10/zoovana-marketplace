import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/auth_controller.dart';
import '../../../core/errors/app_error_mapper.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/services/cache_service.dart';
import '../../../data/mock/app_mock_data.dart';
import '../../../data/models/category.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/cart_repository.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/search_repository.dart';

enum SearchSortOption {
  relevance,
  priceLowHigh,
  priceHighLow,
  newest,
  topRated,
}

class SearchController extends GetxController {
  SearchController({
    required this.repository,
    required this.categoryRepository,
    required this.cacheService,
    required this.authController,
    required this.cartRepository,
  });

  final SearchRepository repository;
  final CategoryRepository categoryRepository;
  final CacheService cacheService;
  final AuthController authController;
  final CartRepository cartRepository;

  final TextEditingController queryController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  static const recentSearchesKey = 'recent_search_queries';
  static const _maxRecentSearches = 10;

  Timer? _debounce;
  bool isLoading = false;
  String? error;
  List<String> recentSearches = const [];
  List<Product> results = const [];
  List<Product> _rawResults = const [];
  List<Category> categories = const [];
  String activeQuery = '';
  String? selectedCategorySlug;
  SearchSortOption sortOption = SearchSortOption.relevance;
  double? selectedMinPrice;
  double? selectedMaxPrice;

  @override
  void onInit() {
    super.onInit();
    recentSearches =
        cacheService.readJsonList(recentSearchesKey)?.cast<String>() ??
        const [];
    _loadCategories();
    search('');
  }

  void onQueryChanged(String value) {
    _debounce?.cancel();
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      activeQuery = '';
      isLoading = true;
      error = null;
      update();
      _debounce = Timer(const Duration(milliseconds: 300), () async {
        await search('');
      });
      return;
    }

    if (trimmed.length < 2) {
      activeQuery = trimmed;
      results = const [];
      _rawResults = const [];
      isLoading = false;
      error = null;
      update();
      return;
    }

    isLoading = true;
    error = null;
    update();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      await search(trimmed);
    });
  }

  Future<void> search(String query) async {
    activeQuery = query;
    isLoading = true;
    error = null;
    update();
    try {
      _rawResults = await repository.searchProducts(query);
      _applyFiltersAndSort();
      if (query.isNotEmpty) {
        await _saveRecentSearch(query);
      }
    } catch (err) {
      error = AppErrorMapper.map(err).message;
      results = const [];
      _rawResults = const [];
    }
    isLoading = false;
    update();
  }

  List<String> categorySuggestionsForLocale(String languageCode) {
    final source = categories.isNotEmpty ? categories : AppMockData.categories;
    final sorted = [...source]
      ..sort((a, b) => b.productCount.compareTo(a.productCount));
    return sorted
        .take(6)
        .map((category) {
          if (languageCode == 'ar' && category.nameAr.isNotEmpty) {
            return category.nameAr;
          }
          return category.name;
        })
        .toList(growable: false);
  }
  String get currentQuery => activeQuery;
  double get minResultPrice {
    if (_rawResults.isEmpty) return 0;
    return _rawResults
        .map((product) => product.price)
        .reduce((value, element) => value < element ? value : element);
  }

  double get maxResultPrice {
    if (_rawResults.isEmpty) return 0;
    return _rawResults
        .map((product) => product.price)
        .reduce((value, element) => value > element ? value : element);
  }

  bool get hasActiveFilters =>
      selectedCategorySlug != null ||
      selectedMinPrice != null ||
      selectedMaxPrice != null ||
      sortOption != SearchSortOption.relevance;

  void selectCategory(String? slug) {
    selectedCategorySlug = slug;
    _applyFiltersAndSort();
    update();
  }

  void setSort(SearchSortOption option) {
    sortOption = option;
    _applyFiltersAndSort();
    update();
  }

  void setPriceRange(double min, double max) {
    selectedMinPrice = min;
    selectedMaxPrice = max;
    _applyFiltersAndSort();
    update();
  }

  void clearFilters() {
    selectedCategorySlug = null;
    selectedMinPrice = null;
    selectedMaxPrice = null;
    sortOption = SearchSortOption.relevance;
    _applyFiltersAndSort();
    update();
  }

  Future<void> addToCart(Product product) async {
    if (product.isOutOfStock) {
      if (Get.context != null) {
        AppSnackbar.show(
          Get.context!,
          message: AppLocalizations.of(Get.context!)?.outOfStock ??
              'Out of Stock',
          type: SnackbarType.error,
        );
      }
      return;
    }

    if (authController.isAuthenticated) {
      try {
        await cartRepository.addToCart(
          product.id,
          1,
          catalogId: product.catalogId,
          variantId: product.variantId,
        );
        if (Get.context != null) {
          AppSnackbar.show(
            Get.context!,
            message: AppLocalizations.of(Get.context!)?.productAddedToCart ??
                'Added to cart',
          );
        }
      } catch (error) {
        if (Get.context != null) {
          AppSnackbar.show(
            Get.context!,
            message: AppErrorMapper.isOutOfStockError(error)
                ? (AppLocalizations.of(Get.context!)?.outOfStock ??
                    'Out of Stock')
                : AppErrorMapper.map(error).message,
            type: SnackbarType.error,
          );
        }
      }
    } else {
      await cartRepository.addToGuestCart(
        product.id,
        1,
        catalogId: product.catalogId,
        variantId: product.variantId,
      );
      if (Get.context != null) {
        AppSnackbar.show(
          Get.context!,
          message: AppLocalizations.of(Get.context!)?.productAddedToCart ??
              'Added to cart',
        );
      }
    }
  }

  void selectRecentSearch(String query) {
    queryController.text = query;
    onQueryChanged(query);
  }

  Future<void> clearRecentSearches() async {
    recentSearches = const [];
    await cacheService.writeJson(recentSearchesKey, []);
    update();
  }

  Future<void> _saveRecentSearch(String query) async {
    final list = [
      query,
      ...recentSearches.where((item) => item != query),
    ].take(_maxRecentSearches).toList();
    recentSearches = list;
    await cacheService.writeJson(recentSearchesKey, list);
  }

  Future<void> _loadCategories() async {
    categories = await categoryRepository.getCategories();
    if (categories.isEmpty) {
      categories = AppMockData.categories
          .where((item) => item.isActive)
          .toList();
    }
    update();
  }

  void _applyFiltersAndSort() {
    var filtered = [..._rawResults];
    final categorySlug = selectedCategorySlug;
    final min = selectedMinPrice;
    final max = selectedMaxPrice;

    if (categorySlug != null) {
      filtered = filtered
          .where((product) => product.categorySlug == categorySlug)
          .toList();
    }
    if (min != null) {
      filtered = filtered.where((product) => product.price >= min).toList();
    }
    if (max != null) {
      filtered = filtered.where((product) => product.price <= max).toList();
    }

    switch (sortOption) {
      case SearchSortOption.relevance:
        break;
      case SearchSortOption.priceLowHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case SearchSortOption.priceHighLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case SearchSortOption.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SearchSortOption.topRated:
        filtered.sort((a, b) {
          final featured = b.isFeatured.toString().compareTo(
            a.isFeatured.toString(),
          );
          if (featured != 0) return featured;
          return b.stock.compareTo(a.stock);
        });
    }

    results = filtered;
  }

  @override
  void onClose() {
    _debounce?.cancel();
    queryController.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
