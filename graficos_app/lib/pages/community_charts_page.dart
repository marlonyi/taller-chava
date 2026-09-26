import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../data/api_service.dart';
import '../widgets/chart_card.dart';

charts.Color _c(int i) => charts.ColorUtil.fromDartColor(palette[i % palette.length]);

/// Librería 4: community_charts_flutter — gráficos 16 a 20.
class CommunityChartsPage extends StatelessWidget {
  final ChartData data;
  const CommunityChartsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final top5 = data.top(5);
    final top6 = data.top(6);
    final products = data.products.take(20).toList();

    return ListView(
      children: [
        // 16. Barras agrupadas (básico)
        ChartCard(
          number: 16,
          title: 'Barras agrupadas: rating vs descuento promedio',
          advanced: false,
          observation:
              'Agrupar dos series por categoría permite comparar dos medidas lado a lado.',
          child: charts.BarChart(
            [
              charts.Series<CategoryStat, String>(
                id: 'Rating',
                data: top5,
                domainFn: (c, _) => c.shortName,
                measureFn: (c, _) => c.avgRating,
                colorFn: (_, _) => _c(0),
              ),
              charts.Series<CategoryStat, String>(
                id: 'Descuento %',
                data: top5,
                domainFn: (c, _) => c.shortName,
                measureFn: (c, _) => c.avgDiscount,
                colorFn: (_, _) => _c(1),
              ),
            ],
            animate: true,
            barGroupingType: charts.BarGroupingType.grouped,
            behaviors: [charts.SeriesLegend()],
          ),
        ),

        // 17. Línea con puntos (básico)
        ChartCard(
          number: 17,
          title: 'Línea con puntos: stock de 20 productos',
          advanced: false,
          observation:
              'Los marcadores resaltan cada observación; se ven productos con inventario muy bajo.',
          child: charts.LineChart(
            [
              charts.Series<Product, int>(
                id: 'Stock',
                data: products,
                domainFn: (p, i) => i! + 1,
                measureFn: (p, _) => p.stock,
                colorFn: (_, _) => _c(2),
              ),
            ],
            animate: true,
            defaultRenderer: charts.LineRendererConfig(includePoints: true),
          ),
        ),

        // 18. Dona (básico)
        ChartCard(
          number: 18,
          title: 'Dona: cantidad de productos por categoría',
          advanced: false,
          observation:
              'Las etiquetas externas identifican cada porción sin necesidad de leyenda.',
          child: charts.PieChart<String>(
            [
              charts.Series<CategoryStat, String>(
                id: 'Categorías',
                data: top5,
                domainFn: (c, _) => c.name,
                measureFn: (c, _) => c.count,
                colorFn: (_, i) => _c(i!),
                labelAccessorFn: (c, _) => '${c.shortName}: ${c.count}',
              ),
            ],
            animate: true,
            defaultRenderer: charts.ArcRendererConfig<String>(
              arcWidth: 50,
              arcRendererDecorators: [
                charts.ArcLabelDecorator<String>(
                    labelPosition: charts.ArcLabelPosition.outside),
              ],
            ),
          ),
        ),

        // 19. Combinado barras + línea (avanzado)
        ChartCard(
          number: 19,
          title: 'Combinado: cantidad (barras) + descuento % (línea)',
          advanced: true,
          observation:
              'OrdinalComboChart mezcla renderizadores distintos sobre el mismo eje de categorías.',
          child: charts.OrdinalComboChart(
            [
              charts.Series<CategoryStat, String>(
                id: 'Cantidad',
                data: top6,
                domainFn: (c, _) => c.shortName,
                measureFn: (c, _) => c.count,
                colorFn: (_, _) => _c(4),
              ),
              charts.Series<CategoryStat, String>(
                id: 'Descuento %',
                data: top6,
                domainFn: (c, _) => c.shortName,
                measureFn: (c, _) => c.avgDiscount,
                colorFn: (_, _) => _c(3),
              )..setAttribute(charts.rendererIdKey, 'linea'),
            ],
            animate: true,
            defaultRenderer: charts.BarRendererConfig(
                groupingType: charts.BarGroupingType.grouped),
            customSeriesRenderers: [
              charts.LineRendererConfig(
                  customRendererId: 'linea', includePoints: true),
            ],
            behaviors: [charts.SeriesLegend()],
          ),
        ),

        // 20. Barras horizontales apiladas (avanzado)
        ChartCard(
          number: 20,
          title: 'Barras apiladas horizontales: rating alto vs bajo',
          advanced: true,
          observation:
              'Cada barra suma el total de la categoría y se divide en productos con rating ≥ 4.5 y < 4.5.',
          child: charts.BarChart(
            [
              charts.Series<CategoryStat, String>(
                id: 'Rating ≥ 4.5',
                data: top6,
                domainFn: (c, _) => c.shortName,
                measureFn: (c, _) => c.highRated,
                colorFn: (_, _) => _c(2),
              ),
              charts.Series<CategoryStat, String>(
                id: 'Rating < 4.5',
                data: top6,
                domainFn: (c, _) => c.shortName,
                measureFn: (c, _) => c.lowRated,
                colorFn: (_, _) => _c(3),
              ),
            ],
            animate: true,
            vertical: false,
            barGroupingType: charts.BarGroupingType.stacked,
            behaviors: [charts.SeriesLegend()],
          ),
        ),
      ],
    );
  }
}
