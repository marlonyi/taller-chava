import 'category_stat.dart';
import 'product.dart';

class RangeBracket {
  final String label;
  final int count;
  final double avgPrice;
  final double avgRating;
  final int totalStock;

  const RangeBracket({
    required this.label,
    required this.count,
    this.avgPrice = 0,
    this.avgRating = 0,
    this.totalStock = 0,
  });
}

class ChartData {
  final List<Product> products;
  final List<CategoryStat> categories; // ordenadas por cantidad desc

  ChartData(this.products, this.categories);

  /// Construye los datos agregando los productos por categoría.
  factory ChartData.fromProducts(List<Product> products) =>
      ChartData(products, aggregate(products));

  /// Top N categorías ordenadas por cantidad de productos.
  List<CategoryStat> top(int n) => categories.take(n).toList();

  /// Top N categorías ordenadas por stock total descendente.
  List<CategoryStat> topByStock(int n) {
    final list = List<CategoryStat>.from(categories)
      ..sort((a, b) => b.totalStock.compareTo(a.totalStock));
    return list.take(n).toList();
  }

  /// Top N categorías ordenadas por precio promedio descendente.
  List<CategoryStat> topByPrice(int n) {
    final list = List<CategoryStat>.from(categories)
      ..sort((a, b) => b.avgPrice.compareTo(a.avgPrice));
    return list.take(n).toList();
  }

  /// Top N categorías ordenadas por rating promedio descendente.
  List<CategoryStat> topByRating(int n) {
    final list = List<CategoryStat>.from(categories)
      ..sort((a, b) => b.avgRating.compareTo(a.avgRating));
    return list.take(n).toList();
  }

  /// Top N categorías ordenadas por descuento promedio descendente.
  List<CategoryStat> topByDiscount(int n) {
    final list = List<CategoryStat>.from(categories)
      ..sort((a, b) => b.avgDiscount.compareTo(a.avgDiscount));
    return list.take(n).toList();
  }

  /// Top N categorías ordenadas por valor monetario de inventario descendente.
  List<CategoryStat> topByValue(int n) {
    final list = List<CategoryStat>.from(categories)
      ..sort((a, b) => b.totalValue.compareTo(a.totalValue));
    return list.take(n).toList();
  }

  /// Top N productos más costosos.
  List<Product> topProductsByPrice(int n) {
    final list = List<Product>.from(products)
      ..sort((a, b) => b.price.compareTo(a.price));
    return list.take(n).toList();
  }

  /// Top N productos más económicos.
  List<Product> cheapestProducts(int n) {
    final list = List<Product>.from(products)
      ..sort((a, b) => a.price.compareTo(b.price));
    return list.take(n).toList();
  }

  /// Top N productos con mayor porcentaje de descuento.
  List<Product> topProductsByDiscount(int n) {
    final list = List<Product>.from(products)
      ..sort((a, b) => b.discount.compareTo(a.discount));
    return list.take(n).toList();
  }

  /// Top N productos con mejor rating.
  List<Product> topProductsByRating(int n) {
    final list = List<Product>.from(products)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return list.take(n).toList();
  }

  /// Top N productos con mayor stock en almacén.
  List<Product> topProductsByStock(int n) {
    final list = List<Product>.from(products)
      ..sort((a, b) => b.stock.compareTo(a.stock));
    return list.take(n).toList();
  }

  /// Distribución de productos por rangos de precio.
  List<RangeBracket> get priceBrackets {
    final b1 = products.where((p) => p.price < 20).toList();
    final b2 = products.where((p) => p.price >= 20 && p.price < 50).toList();
    final b3 = products.where((p) => p.price >= 50 && p.price < 100).toList();
    final b4 = products.where((p) => p.price >= 100 && p.price < 300).toList();
    final b5 = products.where((p) => p.price >= 300).toList();

    RangeBracket make(String label, List<Product> list) {
      final count = list.length;
      final avgP =
          count == 0 ? 0.0 : list.fold(0.0, (s, p) => s + p.price) / count;
      final avgR =
          count == 0 ? 0.0 : list.fold(0.0, (s, p) => s + p.rating) / count;
      final stock = list.fold(0, (s, p) => s + p.stock);
      return RangeBracket(
        label: label,
        count: count,
        avgPrice: avgP,
        avgRating: avgR,
        totalStock: stock,
      );
    }

    return [
      make('< \$20', b1),
      make('\$20-\$50', b2),
      make('\$50-\$100', b3),
      make('\$100-\$300', b4),
      make('≥ \$300', b5),
    ];
  }

  /// Distribución de productos por rangos de rating.
  List<RangeBracket> get ratingBrackets {
    final b1 = products.where((p) => p.rating < 3.0).toList();
    final b2 =
        products.where((p) => p.rating >= 3.0 && p.rating < 3.8).toList();
    final b3 =
        products.where((p) => p.rating >= 3.8 && p.rating < 4.3).toList();
    final b4 =
        products.where((p) => p.rating >= 4.3 && p.rating < 4.7).toList();
    final b5 = products.where((p) => p.rating >= 4.7).toList();

    RangeBracket make(String label, List<Product> list) {
      final count = list.length;
      final avgP =
          count == 0 ? 0.0 : list.fold(0.0, (s, p) => s + p.price) / count;
      final avgR =
          count == 0 ? 0.0 : list.fold(0.0, (s, p) => s + p.rating) / count;
      final stock = list.fold(0, (s, p) => s + p.stock);
      return RangeBracket(
        label: label,
        count: count,
        avgPrice: avgP,
        avgRating: avgR,
        totalStock: stock,
      );
    }

    return [
      make('< 3.0 ★', b1),
      make('3.0-3.8 ★', b2),
      make('3.8-4.3 ★', b3),
      make('4.3-4.7 ★', b4),
      make('≥ 4.7 ★', b5),
    ];
  }

  /// Distribución por nivel de inventario.
  List<RangeBracket> get stockBrackets {
    final b1 = products.where((p) => p.stock < 20).toList();
    final b2 = products.where((p) => p.stock >= 20 && p.stock < 50).toList();
    final b3 = products.where((p) => p.stock >= 50 && p.stock < 80).toList();
    final b4 = products.where((p) => p.stock >= 80).toList();

    RangeBracket make(String label, List<Product> list) {
      final count = list.length;
      final avgP =
          count == 0 ? 0.0 : list.fold(0.0, (s, p) => s + p.price) / count;
      final stock = list.fold(0, (s, p) => s + p.stock);
      return RangeBracket(
        label: label,
        count: count,
        avgPrice: avgP,
        totalStock: stock,
      );
    }

    return [
      make('Crítico (<20)', b1),
      make('Bajo (20-49)', b2),
      make('Medio (50-79)', b3),
      make('Alto (≥80)', b4),
    ];
  }

  /// Distribución por nivel de descuento.
  List<RangeBracket> get discountBrackets {
    final b1 = products.where((p) => p.discount < 5).toList();
    final b2 = products.where((p) => p.discount >= 5 && p.discount < 10).toList();
    final b3 =
        products.where((p) => p.discount >= 10 && p.discount < 15).toList();
    final b4 = products.where((p) => p.discount >= 15).toList();

    RangeBracket make(String label, List<Product> list) {
      final count = list.length;
      final avgP =
          count == 0 ? 0.0 : list.fold(0.0, (s, p) => s + p.price) / count;
      final stock = list.fold(0, (s, p) => s + p.stock);
      return RangeBracket(
        label: label,
        count: count,
        avgPrice: avgP,
        totalStock: stock,
      );
    }

    return [
      make('< 5%', b1),
      make('5% - 10%', b2),
      make('10% - 15%', b3),
      make('≥ 15%', b4),
    ];
  }

  static List<CategoryStat> aggregate(List<Product> products) {
    final groups = <String, List<Product>>{};
    for (final p in products) {
      groups.putIfAbsent(p.category, () => []).add(p);
    }
    final stats = groups.entries.map((e) {
      final l = e.value;
      double avg(double Function(Product) f) =>
          l.map(f).reduce((a, b) => a + b) / l.length;
      final prices = l.map((p) => p.price).toList();
      final minP = prices.reduce((a, b) => a < b ? a : b);
      final maxP = prices.reduce((a, b) => a > b ? a : b);
      final totVal = l.fold(0.0, (s, p) => s + p.inventoryValue);
      final avgDiscP = avg((p) => p.discountedPrice);
      return CategoryStat(
        name: e.key,
        count: l.length,
        avgPrice: avg((p) => p.price),
        avgRating: avg((p) => p.rating),
        totalStock: l.fold(0, (s, p) => s + p.stock),
        avgDiscount: avg((p) => p.discount),
        highRated: l.where((p) => p.rating >= 4.5).length,
        lowRated: l.where((p) => p.rating < 4.5).length,
        totalValue: totVal,
        minPrice: minP,
        maxPrice: maxP,
        avgDiscountedPrice: avgDiscP,
        lowStockCount: l.where((p) => p.stock < 25).length,
        highStockCount: l.where((p) => p.stock >= 25).length,
      );
    }).toList()..sort((a, b) => b.count.compareTo(a.count));
    return stats;
  }
}
