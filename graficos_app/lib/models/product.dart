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
