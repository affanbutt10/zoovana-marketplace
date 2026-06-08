import '../models/product.dart';

class PagedProducts {
  const PagedProducts({
    required this.items,
    required this.page,
    required this.hasMore,
  });

  final List<Product> items;
  final int page;
  final bool hasMore;
}
