import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:graficos_app/models/models.dart';
import 'package:graficos_app/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> _json(int id, String cat, num price, num rating) => {
  'id': id,
  'title': 'Producto número $id',
  'category': cat,
  'price': price,
  'rating': rating,
  'stock': 10,
  'discountPercentage': 5,
};

void main() {
  test('Product.fromJson convierte números y acorta el título', () {
    final p = Product.fromJson(_json(1, 'beauty', 10, 4));
    expect(p.price, 10.0);
    expect(p.discount, 5.0);
    expect(p.shortTitle, 'Producto n…');
  });

  test('ChartData agrega por categoría y ordena por cantidad', () {
    final data = ChartData.fromProducts([
      Product.fromJson(_json(1, 'a', 10, 4.6)),
      Product.fromJson(_json(2, 'b', 20, 4.0)),
      Product.fromJson(_json(3, 'b', 40, 4.8)),
    ]);
    final b = data.categories.first;
    expect(b.name, 'b');
    expect(b.count, 2);
    expect(b.avgPrice, 30);
    expect(b.totalStock, 20);
    expect(b.highRated, 1);
    expect(b.lowRated, 1);
    expect(data.top(1).length, 1);
  });

  test('ApiService lanza excepción si la respuesta no es 200', () {
    final api = ApiService(
      client: MockClient((_) async => http.Response('', 500)),
    );
    expect(api.fetch(), throwsException);
  });

  test('ApiService parsea la respuesta de la API', () async {
    final api = ApiService(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'products': [_json(1, 'a', 10, 4)],
          }),
          200,
        ),
      ),
    );
    final data = await api.fetch();
    expect(data.products.single.category, 'a');
  });
}
