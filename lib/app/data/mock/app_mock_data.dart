import 'dart:math' as math;
import 'dart:typed_data';

import '../models/cart.dart';
import '../models/category.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/receipt.dart';
import '../models/user.dart';

class AppMockData {
  AppMockData._();

  static final List<Category> categories = [
    Category(
      id: 'cat-care',
      name: 'Cat Care',
      nameAr: 'رعاية القطط',
      slug: 'cat-care',
      imageUrl: 'assets/category_img02.png',
      level: 0,
      productCount: 1,
    ),
    Category(
      id: 'dog-care',
      name: 'Dog Care',
      nameAr: 'رعاية الكلاب',
      slug: 'dog-care',
      imageUrl: 'assets/category_img01.png',
      level: 0,
      productCount: 1,
    ),
    Category(
      id: 'bird-living',
      name: 'Bird Living',
      nameAr: 'عالم الطيور',
      slug: 'bird-living',
      imageUrl: 'assets/category_img03.png',
      level: 0,
      productCount: 1,
    ),
    Category(
      id: 'wellness',
      name: 'Pet Wellness',
      nameAr: 'صحة الحيوانات',
      slug: 'wellness',
      imageUrl: 'assets/category_img04.png',
      level: 0,
      productCount: 1,
    ),
    Category(
      id: 'accessories',
      name: 'Accessories',
      nameAr: 'الاكسسوارات',
      slug: 'accessories',
      imageUrl: 'assets/category_img05.png',
      level: 0,
      productCount: 1,
    ),
    Category(
      id: 'habitats',
      name: 'Habitats',
      nameAr: 'المساكن',
      slug: 'habitats',
      imageUrl: 'assets/category_img06.png',
      level: 0,
      productCount: 1,
    ),
  ];

  static final List<Product> products = [
    Product(
      id: 'prod-neko-fold',
      categoryId: 'cat-care',
      categorySlug: 'cat-care',
      name: 'Neko Fold Kitten',
      nameAr: 'قطة نيكو فولد',
      description: 'Scottish Fold kitten with vaccination starter kit.',
      descriptionAr: 'قطة سكوتش فولد مع باقة تطعيمات ابتدائية.',
      price: 820,
      compareAtPrice: 940,
      stock: 3,
      isInStock: true,
      isFeatured: true,
      isActive: true,
      imageUrl: 'assets/welcome_cat.png',
      imageUrls: const ['assets/welcome_cat.png', 'assets/cat_avatar.jpeg'],
      createdAt: DateTime.parse('2026-03-26T10:30:00.000'),
    ),
    Product(
      id: 'prod-golden-buddy',
      categoryId: 'dog-care',
      categorySlug: 'dog-care',
      name: 'Buddy Retriever Pup',
      nameAr: 'جرو بودي ريتريفر',
      description: 'Golden Retriever puppy with starter feeding bundle.',
      descriptionAr: 'جرو جولدن ريتريفر مع باقة تغذية البداية.',
      price: 1250,
      compareAtPrice: 1390,
      stock: 2,
      isInStock: true,
      isFeatured: true,
      isActive: true,
      imageUrl: 'assets/dog_vector_lg.png',
      imageUrls: const [
        'assets/dog_vector_lg.png',
        'assets/category_img01.png',
      ],
      createdAt: DateTime.parse('2026-03-28T08:00:00.000'),
    ),
    Product(
      id: 'prod-premium-kibble',
      categoryId: 'cat-care',
      categorySlug: 'cat-care',
      name: 'Premium Cat Kibble',
      nameAr: 'دراي فود فاخر للقطط',
      description: 'Grain-free salmon recipe with skin and coat support.',
      descriptionAr: 'تركيبة سلمون خالية من الحبوب لدعم الجلد والفراء.',
      price: 145,
      compareAtPrice: 175,
      stock: 18,
      isInStock: true,
      isFeatured: true,
      isActive: true,
      imageUrl: 'assets/category_img02.png',
      imageUrls: const ['assets/category_img02.png'],
      createdAt: DateTime.parse('2026-03-20T09:00:00.000'),
    ),
    Product(
      id: 'prod-luxe-leash',
      categoryId: 'accessories',
      categorySlug: 'accessories',
      name: 'Luxe Walk Set',
      nameAr: 'طقم مشي فاخر',
      description: 'Matching leash, collar, and travel pouch for daily walks.',
      descriptionAr: 'طقم متناسق للمشي يشمل المقود والطوق وحقيبة صغيرة.',
      price: 110,
      compareAtPrice: 145,
      stock: 14,
      isInStock: true,
      isFeatured: false,
      isActive: true,
      imageUrl: 'assets/category_img05.png',
      imageUrls: const ['assets/category_img05.png'],
      createdAt: DateTime.parse('2026-03-29T16:10:00.000'),
    ),
    Product(
      id: 'prod-smart-feeder',
      categoryId: 'wellness',
      categorySlug: 'wellness',
      name: 'Smart Feeder Pro',
      nameAr: 'مغذي ذكي برو',
      description: 'App-connected automatic feeder with portion control.',
      descriptionAr: 'مغذي ذكي متصل بالتطبيق مع التحكم في الكميات.',
      price: 310,
      compareAtPrice: 389,
      stock: 7,
      isInStock: true,
      isFeatured: true,
      isActive: true,
      imageUrl: 'assets/category_img04.png',
      imageUrls: const ['assets/category_img04.png'],
      createdAt: DateTime.parse('2026-03-30T13:20:00.000'),
    ),
    Product(
      id: 'prod-bird-suite',
      categoryId: 'bird-living',
      categorySlug: 'bird-living',
      name: 'Canary Sky Suite',
      nameAr: 'منزل الكناري الفاخر',
      description: 'Spacious bird habitat with tray, perch, and swing set.',
      descriptionAr: 'بيت واسع للطيور مع صينية وقاعدة ومجموعة أرجوحة.',
      price: 260,
      compareAtPrice: 320,
      stock: 5,
      isInStock: true,
      isFeatured: false,
      isActive: true,
      imageUrl: 'assets/bird_vector_lg.png',
      imageUrls: const [
        'assets/bird_vector_lg.png',
        'assets/category_img03.png',
      ],
      createdAt: DateTime.parse('2026-03-25T11:45:00.000'),
    ),
    Product(
      id: 'prod-groom-kit',
      categoryId: 'wellness',
      categorySlug: 'wellness',
      name: 'Grooming Care Kit',
      nameAr: 'مجموعة العناية والتنظيف',
      description: 'Brush, paw balm, coat mist, and calming wipes.',
      descriptionAr: 'فرشاة ومرطب للمخالب وبخاخ للفراء ومناديل مهدئة.',
      price: 95,
      compareAtPrice: 118,
      stock: 22,
      isInStock: true,
      isFeatured: false,
      isActive: true,
      imageUrl: 'assets/category_img04.png',
      imageUrls: const ['assets/category_img04.png'],
      createdAt: DateTime.parse('2026-03-23T12:15:00.000'),
    ),
    Product(
      id: 'prod-travel-carrier',
      categoryId: 'habitats',
      categorySlug: 'habitats',
      name: 'Cloud Travel Carrier',
      nameAr: 'حقيبة السفر كلاود',
      description:
          'Airline-ready carrier with breathable mesh and comfort base.',
      descriptionAr: 'حقيبة سفر مريحة بشبك تهوية وقاعدة مبطنة.',
      price: 185,
      compareAtPrice: 225,
      stock: 9,
      isInStock: true,
      isFeatured: false,
      isActive: true,
      imageUrl: 'assets/category_img06.png',
      imageUrls: const ['assets/category_img06.png'],
      createdAt: DateTime.parse('2026-03-31T09:30:00.000'),
    ),
  ];

  static const List<String> starterSearches = [
    'premium cat food',
    'golden retriever',
    'bird cage',
    'smart feeder',
  ];

  static List<Product> get featuredProducts =>
      products.where((product) => product.isFeatured).take(6).toList();

  static List<Product> get freshArrivals =>
      [...products]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  static Product? productById(String id) {
    return _firstWhereOrNull(products, (product) => product.id == id);
  }

  static Category? categoryBySlug(String slug) {
    return _firstWhereOrNull(categories, (category) => category.slug == slug);
  }

  static List<Product> productsForCategory(String slug) {
    return products
        .where(
          (product) =>
              product.categorySlug == slug || product.categoryId == slug,
        )
        .toList();
  }

  static List<Product> pagedProductsForCategory({
    required String slug,
    required int page,
    required String sort,
    int pageSize = 6,
  }) {
    final sorted = _sortProducts(productsForCategory(slug), sort);
    final start = math.max(0, (page - 1) * pageSize);
    if (start >= sorted.length) {
      return const [];
    }
    final end = math.min(sorted.length, start + pageSize);
    return sorted.sublist(start, end);
  }

  static List<Product> search(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return featuredProducts;
    }

    final matches = products.where((product) {
      final haystack = [
        product.name,
        product.nameAr,
        product.description,
        product.descriptionAr,
        product.categorySlug,
      ].join(' ').toLowerCase();
      return haystack.contains(normalized);
    }).toList();

    if (matches.isNotEmpty) {
      return matches;
    }

    return featuredProducts;
  }

  static List<Product> relatedProducts(String productId) {
    final product = productById(productId);
    if (product == null) {
      return featuredProducts;
    }

    final related = products
        .where(
          (item) =>
              item.id != product.id &&
              item.categorySlug == product.categorySlug,
        )
        .toList();

    return related.isNotEmpty
        ? related.take(4).toList()
        : featuredProducts.take(4).toList();
  }

  static List<Map<String, dynamic>> reviewsForProduct(String productId) {
    final product = productById(productId);
    final name = product?.name ?? 'This item';
    return [
      {
        'id': 'review-1-$productId',
        'author': 'Sara M.',
        'rating': 5,
        'comment': '$name arrived in excellent condition and feels premium.',
      },
      {
        'id': 'review-2-$productId',
        'author': 'Omar K.',
        'rating': 4,
        'comment': 'Smooth checkout and fast delivery. Great value overall.',
      },
    ];
  }

  static final List<Address> addresses = [
    Address(
      id: 'address-1',
      fullName: 'Affan Khalid',
      phoneNumber: '+966 55 123 4567',
      addressLine1: 'King Fahd Road, Al Olaya',
      city: 'Riyadh',
      postalCode: '12212',
      isDefault: true,
    ),
    Address(
      id: 'address-2',
      fullName: 'Affan Khalid',
      phoneNumber: '+966 55 123 4567',
      addressLine1: 'Prince Sultan Street, Al Zahra',
      city: 'Jeddah',
      postalCode: '23521',
      isDefault: false,
    ),
  ];

  static final User user = User(
    id: 'mock-user-1',
    name: 'Affan Khalid',
    email: 'affan@example.com',
    phone: '+966 55 123 4567',
    isActive: true,
    isVerified: false,
    isEmailVerified: false,
    isPhoneVerified: false,
    registrationStatus: 'active',
    addresses: addresses,
  );

  static List<Product> get wishlist => [products[0], products[4], products[7]];

  static final List<Order> orders = [
    Order(
      id: 'ZVN-10482',
      placedAt: DateTime.parse('2026-04-02T12:00:00.000'),
      status: 'Processing',
      total: 420,
      currency: 'SAR',
      subOrders: [
        SubOrder(
          id: 'sub-10482-a',
          sellerName: 'Zoovana Essentials',
          subtotal: 420,
          items: [
            OrderItem(
              id: 'order-item-1',
              productId: 'prod-smart-feeder',
              productName: 'Smart Feeder Pro',
              productNameAr: 'مغذي ذكي برو',
              quantity: 1,
              price: 310,
              lineTotal: 310,
              imageUrl: 'assets/category_img04.png',
            ),
            OrderItem(
              id: 'order-item-2',
              productId: 'prod-luxe-leash',
              productName: 'Luxe Walk Set',
              productNameAr: 'طقم المشي الفاخر',
              quantity: 1,
              price: 110,
              lineTotal: 110,
              imageUrl: 'assets/category_img05.png',
            ),
          ],
        ),
      ],
    ),
    Order(
      id: 'ZVN-10411',
      placedAt: DateTime.parse('2026-03-27T09:15:00.000'),
      status: 'Delivered',
      total: 405,
      currency: 'SAR',
      subOrders: [
        SubOrder(
          id: 'sub-10411-a',
          sellerName: 'Premium Pet Pantry',
          subtotal: 405,
          items: [
            OrderItem(
              id: 'order-item-3',
              productId: 'prod-premium-kibble',
              productName: 'Premium Cat Kibble',
              productNameAr: 'طعام القطط الفاخر',
              quantity: 1,
              price: 145,
              lineTotal: 145,
              imageUrl: 'assets/category_img02.png',
            ),
            OrderItem(
              id: 'order-item-4',
              productId: 'prod-travel-carrier',
              productName: 'Cloud Travel Carrier',
              productNameAr: 'حقيبة السفر السحابية',
              quantity: 1,
              price: 185,
              lineTotal: 185,
              imageUrl: 'assets/category_img06.png',
            ),
            OrderItem(
              id: 'order-item-5',
              productId: 'prod-groom-kit',
              productName: 'Grooming Care Kit',
              productNameAr: 'طقم العناية والتجميل',
              quantity: 1,
              price: 75,
              lineTotal: 75,
              imageUrl: 'assets/category_img04.png',
            ),
          ],
        ),
      ],
    ),
    Order(
      id: 'ZVN-10372',
      placedAt: DateTime.parse('2026-03-14T15:45:00.000'),
      status: 'Shipped',
      total: 260,
      currency: 'SAR',
      subOrders: [
        SubOrder(
          id: 'sub-10372-a',
          sellerName: 'Bird Living Studio',
          subtotal: 260,
          items: [
            OrderItem(
              id: 'order-item-6',
              productId: 'prod-bird-suite',
              productName: 'Canary Sky Suite',
              productNameAr: 'جناح كناري السماء',
              quantity: 1,
              price: 260,
              lineTotal: 260,
              imageUrl: 'assets/bird_vector_lg.png',
            ),
          ],
        ),
      ],
    ),
  ];

  static List<TrackingEvent> trackingForOrder(String orderId) {
    return {
          'ZVN-10482': [
            TrackingEvent(
              status: 'Order Confirmed',
              description: 'Your order is confirmed and queued for packing.',
              timestamp: DateTime.parse('2026-04-02T12:05:00.000'),
            ),
            TrackingEvent(
              status: 'Preparing Shipment',
              description: 'Warehouse team is preparing your premium items.',
              timestamp: DateTime.parse('2026-04-03T10:45:00.000'),
            ),
          ],
          'ZVN-10411': [
            TrackingEvent(
              status: 'Order Confirmed',
              description: 'Payment was captured successfully.',
              timestamp: DateTime.parse('2026-03-27T09:18:00.000'),
            ),
            TrackingEvent(
              status: 'Out for Delivery',
              description: 'Courier is on the way to your address.',
              timestamp: DateTime.parse('2026-03-28T11:30:00.000'),
            ),
            TrackingEvent(
              status: 'Delivered',
              description: 'Package delivered to the front desk.',
              timestamp: DateTime.parse('2026-03-28T15:55:00.000'),
            ),
          ],
          'ZVN-10372': [
            TrackingEvent(
              status: 'Order Confirmed',
              description: 'Order accepted by the seller.',
              timestamp: DateTime.parse('2026-03-14T15:48:00.000'),
            ),
            TrackingEvent(
              status: 'Shipped',
              description: 'Shipment departed from the fulfillment center.',
              timestamp: DateTime.parse('2026-03-15T09:20:00.000'),
            ),
          ],
        }[orderId] ??
        [
          TrackingEvent(
            status: 'Order Placed',
            description: 'Your order has been recorded successfully.',
            timestamp: DateTime.parse('2026-04-01T10:00:00.000'),
          ),
        ];
  }

  static final List<Receipt> receipts = [
    Receipt(
      id: 'receipt-10411',
      number: 'R-10411',
      date: DateTime.parse('2026-03-28T16:00:00.000'),
      total: 405,
      items: [
        ReceiptItem(
          productId: 'prod-premium-kibble',
          productName: 'Premium Cat Kibble',
              productNameAr: 'طعام القطط الفاخر',
          quantity: 1,
          unitPrice: 145,
          totalPrice: 145,
        ),
        ReceiptItem(
          productId: 'prod-travel-carrier',
          productName: 'Cloud Travel Carrier',
              productNameAr: 'حقيبة السفر السحابية',
          quantity: 1,
          unitPrice: 185,
          totalPrice: 185,
        ),
        ReceiptItem(
          productId: 'prod-groom-kit',
          productName: 'Grooming Care Kit',
              productNameAr: 'طقم العناية والتجميل',
          quantity: 1,
          unitPrice: 75,
          totalPrice: 75,
        ),
      ],
    ),
    Receipt(
      id: 'receipt-10482',
      number: 'R-10482',
      date: DateTime.parse('2026-04-02T12:05:00.000'),
      total: 420,
      items: [
        ReceiptItem(
          productId: 'prod-smart-feeder',
          productName: 'Smart Feeder Pro',
              productNameAr: 'مغذي ذكي برو',
          quantity: 1,
          unitPrice: 310,
          totalPrice: 310,
        ),
        ReceiptItem(
          productId: 'prod-luxe-leash',
          productName: 'Luxe Walk Set',
              productNameAr: 'طقم المشي الفاخر',
          quantity: 1,
          unitPrice: 110,
          totalPrice: 110,
        ),
      ],
    ),
    Receipt(
      id: 'receipt-10372',
      number: 'R-10372',
      date: DateTime.parse('2026-03-15T09:25:00.000'),
      total: 260,
      items: [
        ReceiptItem(
          productId: 'prod-bird-suite',
          productName: 'Canary Sky Suite',
              productNameAr: 'جناح كناري السماء',
          quantity: 1,
          unitPrice: 260,
          totalPrice: 260,
        ),
      ],
    ),
  ];

  static Receipt? receiptById(String id) {
    return _firstWhereOrNull(receipts, (receipt) => receipt.id == id);
  }

  static List<Receipt> receiptsByOrder(String orderId) {
    return receipts
        .where((receipt) => receipt.id.contains(orderId.split('-').last))
        .toList();
  }

  static Uint8List receiptPdfBytes(String id) {
    final content = 'Mock PDF content for receipt $id';
    return Uint8List.fromList(content.codeUnits);
  }

  static final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'card',
      'title': 'Credit & Debit Card',
      'description': 'Visa, Mastercard, and Mada',
      'icon': 'credit_card',
    },
    {
      'id': 'apple_pay',
      'title': 'Apple Pay',
      'description': 'Fast checkout on supported devices',
      'icon': 'phone_iphone',
    },
    {
      'id': 'cash_on_delivery',
      'title': 'Cash on Delivery',
      'description': 'Pay when your order arrives',
      'icon': 'local_shipping',
    },
  ];

  static Map<String, dynamic> get notificationPreferences => {
    'email': true,
    'sms': false,
    'push': true,
  };

  static Map<String, dynamic> authPayload({
    String? email,
    String? name,
    String? phone,
  }) {
    return {
      'access_token': 'mock_access_token',
      'refresh_token': 'mock_refresh_token',
      'user': {
        'id': user.id,
        'email': email ?? user.email,
        'name': name ?? user.name,
        'phone': phone ?? user.phone,
      },
    };
  }

  static Cart get defaultCart => buildCartFromSelections({
    'prod-smart-feeder': 1,
    'prod-premium-kibble': 1,
    'prod-travel-carrier': 1,
  });

  static Cart buildCartFromGuestItems(
    List<GuestCartItem> items, {
    String? promoCode,
  }) {
    final selections = <String, int>{};
    for (final item in items) {
      selections[item.productId] =
          (selections[item.productId] ?? 0) + item.quantity;
    }
    return buildCartFromSelections(selections, promoCode: promoCode);
  }

  static Cart buildCartFromSelections(
    Map<String, int> selections, {
    String? promoCode,
  }) {
    final items = <CartItem>[];
    for (final entry in selections.entries) {
      final product = productById(entry.key);
      if (product == null || entry.value <= 0) {
        continue;
      }
      items.add(
        CartItem(
          id: 'mock-cart-${product.id}',
          productId: product.id,
          productName: product.name,
          productNameAr: product.nameAr,
          price: product.price,
          quantity: entry.value,
          imageUrl: product.imageUrl,
          stock: product.stock,
        ),
      );
    }

    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final discount = promoCode != null && promoCode.isNotEmpty
        ? math.min(subtotal * 0.1, 45).toDouble()
        : 0.0;
    final shipping = items.isEmpty
        ? 0.0
        : (subtotal - discount >= 250 ? 0.0 : 18.0);
    final total = math.max(0, subtotal - discount + shipping).toDouble();

    return Cart(
      id: 'mock-cart',
      status: 'active',
      items: items,
      itemCount: items.length,
      subtotal: subtotal,
      discountAmount: discount,
      taxAmount: 0.0,
      total: total,
      currency: 'SAR',
      promoCode: promoCode,
    );
  }

  static Cart addProductToCart(Cart cart, String productId, int quantity) {
    final selections = {
      for (final item in cart.items) item.productId: item.quantity,
    };
    selections[productId] = (selections[productId] ?? 0) + quantity;
    return buildCartFromSelections(selections, promoCode: cart.promoCode);
  }

  static Cart updateCartItemQuantity(Cart cart, String itemId, int quantity) {
    final selections = {
      for (final item in cart.items) item.productId: item.quantity,
    };
    final matchedItem = _firstWhereOrNull(
      cart.items,
      (entry) => entry.id == itemId,
    );
    if (matchedItem == null) {
      return cart;
    }
    if (quantity <= 0) {
      selections.remove(matchedItem.productId);
    } else {
      selections[matchedItem.productId] = quantity;
    }
    return buildCartFromSelections(selections, promoCode: cart.promoCode);
  }

  static Cart removeCartItem(Cart cart, String itemId) {
    final selections = {
      for (final item in cart.items) item.productId: item.quantity,
    };
    final item = _firstWhereOrNull(cart.items, (entry) => entry.id == itemId);
    if (item != null) {
      selections.remove(item.productId);
    }
    return buildCartFromSelections(selections, promoCode: cart.promoCode);
  }

  static Cart applyPromo(Cart cart, String code) {
    final selections = {
      for (final item in cart.items) item.productId: item.quantity,
    };
    return buildCartFromSelections(selections, promoCode: code);
  }

  static Cart clearCart() {
    return buildCartFromSelections(const {});
  }

  static Map<String, dynamic> cartTotals(Cart cart) {
    return {
      'subtotal': cart.subtotal,
      'discount': cart.discountAmount,
      'shipping': 0.0,
      'total': cart.total,
      'promo_code': cart.promoCode,
    };
  }

  static List<Map<String, dynamic>> shippingOptions() {
    return const [
      {
        'id': 'express',
        'label': 'Express Delivery',
        'description': 'Same-day delivery in major cities',
        'price': 25.0,
      },
      {
        'id': 'standard',
        'label': 'Standard Delivery',
        'description': 'Delivered within 2-4 business days',
        'price': 12.0,
      },
      {
        'id': 'pickup',
        'label': 'Store Pickup',
        'description': 'Collect from your nearest Zoovana partner store',
        'price': 0.0,
      },
    ];
  }

  static List<Map<String, dynamic>> breadcrumbsForCategory(String slug) {
    final category = categoryBySlug(slug);
    if (category == null) {
      return const [];
    }
    return [
      {'label': 'Home', 'slug': 'home'},
      {'label': 'Categories', 'slug': 'categories'},
      {'label': category.name, 'slug': category.slug},
    ];
  }

  static List<Product> _sortProducts(List<Product> source, String sort) {
    final items = [...source];
    switch (sort) {
      case 'price_asc':
        items.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        items.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'newest':
      default:
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return items;
  }

  static T? _firstWhereOrNull<T>(
    Iterable<T> source,
    bool Function(T item) test,
  ) {
    for (final item in source) {
      if (test(item)) {
        return item;
      }
    }
    return null;
  }
}
