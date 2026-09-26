import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/palette.dart';
import '../widgets/chart_card.dart';

/// Librería 1: fl_chart — gráficos 1 a 5.
class FlChartPage extends StatelessWidget {
  final ChartData data;
  const FlChartPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final products = data.products.take(15).toList();
    final top6 = data.top(6);
    final top5 = data.top(5);

    return ListView(
      children: [
        // 1. Línea (básico)
        ChartCard(
          number: 1,
          title: 'Línea: precio de 15 productos',
          advanced: false,
          observation: 'La línea muestra la variación de precio entre productos; los picos corresponden a artículos de lujo.',
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: _titles(bottom: (v) => '${v.toInt() + 1}'),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < products.length; i++)
                      FlSpot(i.toDouble(), products[i].price),
                  ],
                  isCurved: true,
                  color: palette[0],
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),

        // 2. Barras (básico)
        ChartCard(
          number: 2,
          title: 'Barras: stock total por categoría',
          advanced: false,
          observation: 'Permite comparar de un vistazo qué categoría tiene más unidades disponibles en inventario.',
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              titlesData: _titles(
                bottom: (v) => top6[v.toInt()].shortName,
                rotate: true,
              ),
              barGroups: [
                for (var i = 0; i < top6.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: top6[i].totalStock.toDouble(),
                        color: palette[i % palette.length],
                        width: 18,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),

        // 3. Circular / Pie (básico)
        ChartCard(
          number: 3,
          title: 'Pastel: productos por categoría',
          advanced: false,
          observation: 'Cada porción representa el porcentaje de productos de una categoría sobre el total del top 5.',
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 0,
                    sections: [
                      for (var i = 0; i < top5.length; i++)
                        PieChartSectionData(
                          value: top5[i].count.toDouble(),
                          title: '${top5[i].count}',
                          color: palette[i],
                          radius: 100,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              _Legend(names: top5.map((c) => c.name).toList()),
            ],
          ),
        ),

        // 4. Radar (avanzado)
        ChartCard(
          number: 4,
          title: 'Radar: comparación multivariable de 3 categorías',
          advanced: true,
          observation: 'Las métricas se normalizan de 0 a 100 para comparar precio, rating, stock, descuento y cantidad en un mismo eje.',
          height: 320,
          child: _radar(data.top(3)),
        ),

        // 5. Dispersión / Burbujas (avanzado)
        ChartCard(
          number: 5,
          title: 'Burbujas: precio vs rating (tamaño = stock)',
          advanced: true,
          observation: 'No se observa correlación fuerte entre precio y rating; las burbujas grandes indican alto inventario.',
          child: _scatter(data),
        ),
      ],
    );
  }

  Widget _radar(List<CategoryStat> cats) {
    final all = data.categories;
    double maxOf(double Function(CategoryStat) f) =>
        all.map(f).reduce((a, b) => a > b ? a : b);
    final metrics = <String, double Function(CategoryStat)>{
      'Precio': (c) => c.avgPrice,
      'Rating': (c) => c.avgRating,
      'Stock': (c) => c.totalStock.toDouble(),
      'Descuento': (c) => c.avgDiscount,
      'Cantidad': (c) => c.count.toDouble(),
    };
    final keys = metrics.keys.toList();
    return Column(
      children: [
        Expanded(
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              tickCount: 4,
              ticksTextStyle: const TextStyle(fontSize: 0),
              getTitle: (i, angle) => RadarChartTitle(text: keys[i]),
              dataSets: [
                for (var i = 0; i < cats.length; i++)
                  RadarDataSet(
                    borderColor: palette[i],
                    fillColor: palette[i].withValues(alpha: 0.2),
                    entryRadius: 3,
                    dataEntries: [
                      for (final f in metrics.values)
                        RadarEntry(value: f(cats[i]) / maxOf(f) * 100),
                    ],
                  ),
              ],
            ),
          ),
        ),
        Wrap(
          spacing: 12,
          children: [
            for (var i = 0; i < cats.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.circle, size: 10, color: palette[i]),
                  const SizedBox(width: 4),
                  Text(cats[i].name, style: const TextStyle(fontSize: 12)),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _scatter(ChartData d) {
    final cats = d.categories.map((c) => c.name).toList();
    final ps = d.products.where((p) => p.price < 200).toList();
    return ScatterChart(
      ScatterChartData(
        minY: 2.5,
        maxY: 5,
        borderData: FlBorderData(show: true),
        titlesData: _titles(bottom: (v) => '\$${v.toInt()}'),
        scatterSpots: [
          for (final p in ps)
            ScatterSpot(
              p.price,
              p.rating,
              dotPainter: FlDotCirclePainter(
                radius: 3 + p.stock / 15,
                color: palette[cats.indexOf(p.category) % palette.length]
                    .withValues(alpha: 0.6),
              ),
            ),
        ],
        scatterTouchData: ScatterTouchData(
          enabled: true,
          touchTooltipData: ScatterTouchTooltipData(
            getTooltipItems: (s) =>
                ScatterTooltipItem('\$${s.x.toStringAsFixed(1)} · ★${s.y}'),
          ),
        ),
      ),
    );
  }

  FlTitlesData _titles({
    required String Function(double) bottom,
    bool rotate = false,
  }) {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: rotate ? 50 : 24,
          getTitlesWidget: (v, meta) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Transform.rotate(
              angle: rotate ? -0.6 : 0,
              child: Text(bottom(v), style: const TextStyle(fontSize: 10)),
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final List<String> names;
  const _Legend({required this.names});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < names.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(Icons.square, size: 12, color: palette[i]),
                const SizedBox(width: 4),
                Text(names[i], style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
      ],
    );
  }
}
