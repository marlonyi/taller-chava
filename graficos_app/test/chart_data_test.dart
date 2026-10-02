import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graficos_app/models/models.dart';
import 'package:graficos_app/pages/community_charts/community_charts_advanced.dart';
import 'package:graficos_app/pages/community_charts/community_charts_basic.dart';
import 'package:graficos_app/pages/fl_chart/fl_chart_advanced.dart';
import 'package:graficos_app/pages/fl_chart/fl_chart_basic.dart';
import 'package:graficos_app/pages/graphic/graphic_advanced.dart';
import 'package:graficos_app/pages/graphic/graphic_basic.dart';
import 'package:graficos_app/pages/syncfusion/syncfusion_advanced.dart';
import 'package:graficos_app/pages/syncfusion/syncfusion_basic.dart';
import 'package:graficos_app/services/api_service.dart';
import 'package:graficos_app/widgets/chart_card.dart';
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

  test('Cada librería contiene exactamente 40 básicas y 25 avanzadas (260 total)', () {
    final sampleData = ChartData.fromProducts([
      for (var i = 1; i <= 30; i++)
        Product.fromJson(_json(i, 'cat${i % 6}', 10.0 + i, 3.0 + (i % 20) / 10.0)),
    ]);

    final flBasic = getFlChartBasicItems(sampleData);
    final flAdv = getFlChartAdvancedItems(sampleData);
    expect(flBasic.length, 40, reason: 'fl_chart debe tener 40 básicas');
    expect(flAdv.length, 25, reason: 'fl_chart debe tener 25 avanzadas');

    final sfBasic = getSyncfusionBasicItems(sampleData);
    final sfAdv = getSyncfusionAdvancedItems(sampleData);
    expect(sfBasic.length, 40, reason: 'Syncfusion debe tener 40 básicas');
    expect(sfAdv.length, 25, reason: 'Syncfusion debe tener 25 avanzadas');

    final grBasic = getGraphicBasicItems(sampleData);
    final grAdv = getGraphicAdvancedItems(sampleData);
    expect(grBasic.length, 40, reason: 'graphic debe tener 40 básicas');
    expect(grAdv.length, 25, reason: 'graphic debe tener 25 avanzadas');

    final ccBasic = getCommunityChartsBasicItems(sampleData);
    final ccAdv = getCommunityChartsAdvancedItems(sampleData);
    expect(ccBasic.length, 40, reason: 'community_charts debe tener 40 básicas');
    expect(ccAdv.length, 25, reason: 'community_charts debe tener 25 avanzadas');

    final allItems = [
      ...flBasic,
      ...flAdv,
      ...sfBasic,
      ...sfAdv,
      ...grBasic,
      ...grAdv,
      ...ccBasic,
      ...ccAdv,
    ];

    expect(allItems.length, 260, reason: 'El proyecto debe contener 260 gráficos en total');
    final numbers = allItems.map((i) => i.number).toSet();
    expect(numbers.length, 260, reason: 'Todos los números del 1 al 260 deben ser únicos');
    expect(numbers.first, 1);
    expect(numbers.last, 260);
  });

  testWidgets('Renderiza correctamente los gráficos 245 y 259 sin errores', (tester) async {
    final sampleData = ChartData.fromProducts([
      for (var i = 1; i <= 30; i++)
        Product.fromJson(_json(i, 'cat${i % 6}', 10.0 + i, 3.0 + (i % 20) / 10.0)),
    ]);
    final ccAdv = getCommunityChartsAdvancedItems(sampleData);
    final item245 = ccAdv.firstWhere((i) => i.number == 245);
    final item259 = ccAdv.firstWhere((i) => i.number == 259);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Builder(builder: (context) => item245.buildCard(context)),
              Builder(builder: (context) => item259.buildCard(context)),
            ],
          ),
        ),
      ),
    ));

    expect(find.textContaining('245'), findsOneWidget);
    expect(find.textContaining('259'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Todos los 260 gráficos construyen widgets válidos', (tester) async {
    final sampleData = ChartData.fromProducts([
      for (var i = 1; i <= 30; i++)
        Product.fromJson(_json(i, 'cat${i % 6}', 10.0 + i, 3.0 + (i % 20) / 10.0)),
    ]);
    final allItems = [
      ...getFlChartBasicItems(sampleData),
      ...getFlChartAdvancedItems(sampleData),
      ...getSyncfusionBasicItems(sampleData),
      ...getSyncfusionAdvancedItems(sampleData),
      ...getGraphicBasicItems(sampleData),
      ...getGraphicAdvancedItems(sampleData),
      ...getCommunityChartsBasicItems(sampleData),
      ...getCommunityChartsAdvancedItems(sampleData),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            for (final item in allItems) {
              final card = item.buildCard(context);
              expect(card, isNotNull, reason: 'Gráfico #${item.number} debe construir un Card válido');
            }
            return const SizedBox();
          },
        ),
      ),
    ));
    expect(tester.takeException(), isNull);
  });

  testWidgets('ChartCard renderiza correctamente sus campos de información', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: ChartCard(
          number: 1,
          title: 'Gráfico de Prueba',
          advanced: true,
          observation: 'Observación de prueba',
          child: Text('Contenido Gráfico 2D'),
        ),
      ),
    ));

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Gráfico de Prueba'), findsOneWidget);
    expect(find.text('Avanzado'), findsOneWidget);
    expect(find.text('Observación: Observación de prueba'), findsOneWidget);
    expect(find.text('Contenido Gráfico 2D'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}



