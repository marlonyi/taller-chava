import 'dart:convert';

import 'package:http/http.dart' as http;

/// Producto obtenido desde la API pública https://dummyjson.com/products
class Product {
  final int id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final double discount;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as int,
        title: j['title'] as String,
        category: j['category'] as String,
        price: (j['price'] as num).toDouble(),
        rating: (j['rating'] as num).toDouble(),
        stock: (j['stock'] as num).toInt(),
        discount: (j['discountPercentage'] as num).toDouble(),
      );

  /// Nombre corto para ejes.
  String get shortTitle =>
      title.length > 10 ? '${title.substring(0, 10)}…' : title;
}

/// Estadísticas agregadas por categoría.
class CategoryStat {
  final String name;
  final int count;
  final double avgPrice;
  final double avgRating;
  final int totalStock;
  final double avgDiscount;
  final int highRated; // rating >= 4.5
  final int lowRated; // rating < 4.5

  CategoryStat({
    required this.name,
    required this.count,
    required this.avgPrice,
    required this.avgRating,
    required this.totalStock,
    required this.avgDiscount,
    required this.highRated,
    required this.lowRated,
  });

  String get shortName => name.length > 9 ? '${name.substring(0, 9)}…' : name;
}

class ChartData {
  final List<Product> products;
  final List<CategoryStat> categories; // ordenadas por cantidad desc

  ChartData(this.products, this.categories);

  /// Top N categorías.
  List<CategoryStat> top(int n) => categories.take(n).toList();
}

class ApiService {
  static const _url = 'https://dummyjson.com/products?limit=100';

  static Future<ChartData> fetch() async {
    final res = await http.get(Uri.parse(_url));
    if (res.statusCode != 200) {
      throw Exception('Error HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final products = (body['products'] as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    return ChartData(products, _aggregate(products));
  }

  static List<CategoryStat> _aggregate(List<Product> products) {
    final groups = <String, List<Product>>{};
    for (final p in products) {
      groups.putIfAbsent(p.category, () => []).add(p);
    }
    final stats = groups.entries.map((e) {
      final l = e.value;
      double avg(double Function(Product) f) =>
          l.map(f).reduce((a, b) => a + b) / l.length;
      return CategoryStat(
        name: e.key,
        count: l.length,
        avgPrice: avg((p) => p.price),
        avgRating: avg((p) => p.rating),
        totalStock: l.fold(0, (s, p) => s + p.stock),
        avgDiscount: avg((p) => p.discount),
        highRated: l.where((p) => p.rating >= 4.5).length,
        lowRated: l.where((p) => p.rating < 4.5).length,
      );
    }).toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    return stats;
  }
}
