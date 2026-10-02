/// Producto obtenido desde la API pública https://dummyjson.com/products
class Product {
  final int id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final int stock;
  final double discount;
  final String brand;
  final double weight;
  final int minimumOrderQuantity;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.stock,
    required this.discount,
    this.brand = 'General',
    this.weight = 1.0,
    this.minimumOrderQuantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as int,
        title: j['title'] as String,
        category: j['category'] as String,
        price: (j['price'] as num).toDouble(),
        rating: (j['rating'] as num).toDouble(),
        stock: (j['stock'] as num).toInt(),
        discount: (j['discountPercentage'] as num).toDouble(),
        brand: (j['brand'] as String?) ?? 'General',
        weight: (j['weight'] as num?)?.toDouble() ?? 1.0,
        minimumOrderQuantity: (j['minimumOrderQuantity'] as num?)?.toInt() ?? 1,
      );

  /// Nombre corto para ejes.
  String get shortTitle =>
      title.length > 10 ? '${title.substring(0, 10)}…' : title;

  /// Precio con descuento aplicado.
  double get discountedPrice => price * (1 - discount / 100);

  /// Valor total estimado del inventario.
  double get inventoryValue => price * stock;

  /// Monto monetario ahorrado con el descuento.
  double get discountAmount => price * (discount / 100);
}
