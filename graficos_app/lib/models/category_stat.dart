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
  final double totalValue;
  final double minPrice;
  final double maxPrice;
  final double avgDiscountedPrice;
  final int lowStockCount; // stock < 25
  final int highStockCount; // stock >= 25

  CategoryStat({
    required this.name,
    required this.count,
    required this.avgPrice,
    required this.avgRating,
    required this.totalStock,
    required this.avgDiscount,
    required this.highRated,
    required this.lowRated,
    this.totalValue = 0,
    this.minPrice = 0,
    this.maxPrice = 0,
    this.avgDiscountedPrice = 0,
    this.lowStockCount = 0,
    this.highStockCount = 0,
  });

  String get shortName => name.length > 9 ? '${name.substring(0, 9)}…' : name;
  double get priceRange => maxPrice - minPrice;
}
