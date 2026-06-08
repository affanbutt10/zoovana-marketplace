/// Category model matching the real API response shape:
/// GET /catalog/categories → data: [ { id, name_en, name_ar, slug, level,
///   product_count, image_url, parent_id } ]
class Category {
  final String id;
  final String name;
  final String nameAr;
  final String slug;
  final String? imageUrl;
  final int productCount;
  final int level;
  final String? parentId;

  /// Derived: a category is considered active if it has at least one product.
  /// The real API does not return an `is_active` field for categories.
  bool get isActive => productCount > 0;

  Category({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
    this.imageUrl,
    required this.productCount,
    required this.level,
    this.parentId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: (json['name_en'] ?? json['name'] ?? '') as String,
      nameAr: (json['name_ar'] ?? '') as String,
      slug: (json['slug'] ?? '') as String,
      imageUrl: json['image_url'] as String?,
      productCount: (json['product_count'] ?? 0) as int,
      level: (json['level'] ?? 0) as int,
      parentId: json['parent_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': name,
      'name_ar': nameAr,
      'slug': slug,
      'image_url': imageUrl,
      'product_count': productCount,
      'level': level,
      'parent_id': parentId,
    };
  }
}
