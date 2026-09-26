import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/models.dart';
import '../theme/palette.dart';
import '../widgets/chart_card.dart';

/// Librería 2: syncfusion_flutter_charts — gráficos 6 a 10.
class SyncfusionPage extends StatelessWidget {
  final ChartData data;
  const SyncfusionPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final top6 = data.top(6);
    final top5 = data.top(5);
    final products = data.products.take(20).toList();

    return ListView(
      children: [
        // 6. Columnas (básico)
        ChartCard(
          number: 6,
          title: 'Columnas: precio promedio por categoría',
          advanced: false,
          observation: 'Las etiquetas de datos muestran el valor exacto; se identifica la categoría más costosa.',
          child: SfCartesianChart(
            primaryXAxis: const CategoryAxis(labelRotation: -35),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<CategoryStat, String>>[
              ColumnSeries<CategoryStat, String>(
                name: 'Precio promedio',
                dataSource: top6,
                xValueMapper: (c, _) => c.shortName,
                yValueMapper: (c, _) =>
                    double.parse(c.avgPrice.toStringAsFixed(1)),
                pointColorMapper: (c, i) => palette[i % palette.length],
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
            ],
          ),
        ),

        // 7. Área (básico)
        ChartCard(
          number: 7,
          title: 'Área: % de descuento de 20 productos',
          advanced: false,
          observation: 'El área rellena resalta el volumen de descuento acumulado y sus variaciones entre productos.',
          child: SfCartesianChart(
            primaryXAxis: const NumericAxis(interval: 2),
            series: <CartesianSeries<Product, int>>[
              AreaSeries<Product, int>(
                dataSource: products,
                xValueMapper: (p, i) => i + 1,
                yValueMapper: (p, _) => p.discount,
                color: palette[1].withValues(alpha: 0.5),
                borderColor: palette[1],
                borderWidth: 2,
              ),
            ],
          ),
        ),

        // 8. Dona (básico)
        ChartCard(
          number: 8,
          title: 'Dona: distribución del stock',
          advanced: false,
          observation: 'El hueco central libera espacio y la leyenda interactiva permite ocultar categorías.',
          child: SfCircularChart(
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.right,
            ),
            series: <CircularSeries<CategoryStat, String>>[
              DoughnutSeries<CategoryStat, String>(
                dataSource: top5,
                xValueMapper: (c, _) => c.name,
                yValueMapper: (c, _) => c.totalStock,
                pointColorMapper: (c, i) => palette[i],
                innerRadius: '55%',
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),

        // 9. Barras radiales (avanzado)
        ChartCard(
          number: 9,
          title: 'Barras radiales: rating promedio (máx. 5)',
          advanced: true,
          observation: 'Cada anillo es una categoría; el recorrido del arco indica qué tan cerca está de la calificación perfecta.',
          child: SfCircularChart(
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.right,
              overflowMode: LegendItemOverflowMode.wrap,
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries<CategoryStat, String>>[
              RadialBarSeries<CategoryStat, String>(
                dataSource: top5,
                maximumValue: 5,
                gap: '6%',
                radius: '100%',
                cornerStyle: CornerStyle.bothCurve,
                trackOpacity: 0.15,
                xValueMapper: (c, _) => c.name,
                yValueMapper: (c, _) =>
                    double.parse(c.avgRating.toStringAsFixed(2)),
                pointColorMapper: (c, i) => palette[i],
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),

        // 10. Combinado con doble eje, zoom y trackball (avanzado)
        ChartCard(
          number: 10,
          title: 'Combinado: stock (columnas) + rating (spline) con doble eje',
          advanced: true,
          observation: 'Usa eje secundario, zoom con pellizco y trackball; se aprecia que más stock no implica mejor rating.',
          height: 320,
          child: SfCartesianChart(
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enablePanning: true,
              zoomMode: ZoomMode.x,
            ),
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
              tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
            ),
            primaryXAxis: const CategoryAxis(labelRotation: -35),
            primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Stock')),
            axes: const <ChartAxis>[
              NumericAxis(
                name: 'ratingAxis',
                opposedPosition: true,
                minimum: 0,
                maximum: 5,
                title: AxisTitle(text: 'Rating'),
              ),
            ],
            series: <CartesianSeries<CategoryStat, String>>[
              ColumnSeries<CategoryStat, String>(
                name: 'Stock',
                dataSource: data.categories,
                xValueMapper: (c, _) => c.shortName,
                yValueMapper: (c, _) => c.totalStock,
                color: palette[0],
              ),
              SplineSeries<CategoryStat, String>(
                name: 'Rating',
                dataSource: data.categories,
                yAxisName: 'ratingAxis',
                xValueMapper: (c, _) => c.shortName,
                yValueMapper: (c, _) => c.avgRating,
                color: palette[3],
                width: 3,
                markerSettings: const MarkerSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
