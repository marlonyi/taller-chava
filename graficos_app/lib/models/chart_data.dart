import 'category_stat.dart';
import 'product.dart';

class ChartData {
  final List<Product> products;
  final List<CategoryStat> categories; // ordenadas por cantidad desc

  ChartData(this.products, this.categories);

  /// Construye los datos agregando los productos por categoría.
  factory ChartData.fromProducts(List<Product> products) =>
      ChartData(products, aggregate(products));

  /// Top N categorías.
  List<CategoryStat> top(int n) => categories.take(n).toList();

  static List<CategoryStat> aggregate(List<Product> products) {
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
    }).toList()..sort((a, b) => b.count.compareTo(a.count));
    return stats;
  }
}
