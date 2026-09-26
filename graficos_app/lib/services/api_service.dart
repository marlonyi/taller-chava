import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/models.dart';

class ApiService {
  static const _url = 'https://dummyjson.com/products?limit=100';

  final http.Client _client;

  /// Se puede inyectar un [http.Client] (por ejemplo, un mock en pruebas).
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<ChartData> fetch() async {
    final res = await _client.get(Uri.parse(_url));
    if (res.statusCode != 200) {
      throw Exception('Error HTTP ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final products = (body['products'] as List)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    return ChartData.fromProducts(products);
  }
}
