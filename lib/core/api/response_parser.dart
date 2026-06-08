class ResponseParser {
  const ResponseParser._();

  static Map<String, dynamic> asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (key, entryValue) => MapEntry(key.toString(), entryValue),
      );
    }
    return <String, dynamic>{};
  }

  static List<dynamic> asList(dynamic value) {
    if (value is List) {
      return value;
    }
    return const [];
  }

  static Map<String, dynamic> extractMap(
    dynamic data, {
    List<String> candidateKeys = const [
      'data',
      'item',
      'result',
      'product',
      'category',
      'cart',
      'order',
      'receipt',
      'user',
      'profile',
    ],
  }) {
    final root = asMap(data);
    if (root.isEmpty) {
      return <String, dynamic>{};
    }

    for (final key in candidateKeys) {
      final value = root[key];
      if (value is Map) {
        return asMap(value);
      }
    }

    return root;
  }

  static List<Map<String, dynamic>> extractList(
    dynamic data, {
    List<String> candidateKeys = const [
      'data',
      'results',
      'items',
      'products',
      'categories',
      'orders',
      'receipts',
      'reviews',
      'tracking',
      'breadcrumbs',
      'addresses',
      'payment_methods',
      'shipping_options',
    ],
  }) {
    final directList = asList(data);
    if (directList.isNotEmpty) {
      return directList.map(asMap).where((entry) => entry.isNotEmpty).toList();
    }

    final root = asMap(data);
    for (final key in candidateKeys) {
      final value = root[key];
      if (value is List) {
        return value.map(asMap).where((entry) => entry.isNotEmpty).toList();
      }
    }

    return const [];
  }

  static Map<String, dynamic> flatten(
    Map<String, dynamic> payload, {
    List<String> nestedKeys = const ['data', 'result', 'tokens', 'session'],
  }) {
    final flattened = <String, dynamic>{};
    for (final key in nestedKeys) {
      flattened.addAll(asMap(payload[key]));
    }
    flattened.addAll(payload);
    return flattened;
  }
}
