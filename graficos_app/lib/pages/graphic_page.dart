import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../data/api_service.dart';
import '../widgets/chart_card.dart';

/// Librería 3: graphic (Gramática de gráficos) — gráficos 11 a 15.
class GraphicPage extends StatelessWidget {
  final ChartData data;
  const GraphicPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final catRows = [
      for (final c in data.top(8))
        {'cat': c.shortName, 'count': c.count, 'price': c.avgPrice},
    ];
    final prodRows = [
      for (var i = 0; i < 20; i++)
        {'idx': '${i + 1}', 'rating': data.products[i].rating},
    ];
    final pointRows = [
      for (final p in data.products)
        {'stock': p.stock, 'discount': p.discount},
    ];

    return ListView(
      children: [
        // 11. Barras horizontales (básico)
        ChartCard(
          number: 11,
          title: 'Barras horizontales: cantidad por categoría',
          advanced: false,
          observation:
              'La orientación horizontal facilita leer nombres largos de categorías.',
          child: Chart(
            data: catRows,
            variables: {
              'cat': Variable(accessor: (Map m) => m['cat'] as String),
              'count': Variable(
                accessor: (Map m) => m['count'] as num,
                scale: LinearScale(min: 0),
              ),
            },
            marks: [
              IntervalMark(
                color: ColorEncode(variable: 'cat', values: palette),
                label: LabelEncode(
                    encoder: (t) => Label(t['count'].toString())),
              ),
            ],
            coord: RectCoord(transposed: true),
            axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
          ),
        ),

        // 12. Línea suave con área (básico)
        ChartCard(
          number: 12,
          title: 'Línea suave + área: rating de 20 productos',
          advanced: false,
          observation:
              'La curva suavizada muestra la tendencia de calificaciones; la mayoría supera 3.5.',
          child: Chart(
            data: prodRows,
            variables: {
              'idx': Variable(accessor: (Map m) => m['idx'] as String),
              'rating': Variable(
                accessor: (Map m) => m['rating'] as num,
                scale: LinearScale(min: 0, max: 5),
              ),
            },
            marks: [
              AreaMark(
                shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
                color: ColorEncode(value: palette[2].withValues(alpha: 0.25)),
              ),
              LineMark(
                shape: ShapeEncode(value: BasicLineShape(smooth: true)),
                color: ColorEncode(value: palette[2]),
                size: SizeEncode(value: 2.5),
              ),
            ],
            axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
            selections: {'tap': PointSelection(dim: Dim.x)},
            tooltip: TooltipGuide(),
            crosshair: CrosshairGuide(),
          ),
        ),

        // 13. Puntos (básico)
        ChartCard(
          number: 13,
          title: 'Puntos: stock vs % descuento',
          advanced: false,
          observation:
              'Los puntos dispersos indican que el descuento no depende del nivel de inventario.',
          child: Chart(
            data: pointRows,
            variables: {
              'stock': Variable(
                accessor: (Map m) => m['stock'] as num,
                scale: LinearScale(min: 0),
              ),
              'discount': Variable(
                accessor: (Map m) => m['discount'] as num,
                scale: LinearScale(min: 0),
              ),
            },
            marks: [
              PointMark(
                size: SizeEncode(value: 7),
                color: ColorEncode(value: palette[4].withValues(alpha: 0.7)),
              ),
            ],
            axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
          ),
        ),

        // 14. Rosa de Nightingale (avanzado)
        ChartCard(
          number: 14,
          title: 'Rosa de Nightingale: precio promedio por categoría',
          advanced: true,
          observation:
              'Gráfico polar donde el radio de cada pétalo codifica el precio; útil para datos cíclicos o categóricos.',
          height: 320,
          child: Chart(
            data: catRows,
            variables: {
              'cat': Variable(accessor: (Map m) => m['cat'] as String),
              'price': Variable(
                accessor: (Map m) => m['price'] as num,
                scale: LinearScale(min: 0),
              ),
            },
            marks: [
              IntervalMark(
                color: ColorEncode(variable: 'cat', values: palette),
                label: LabelEncode(
                    encoder: (t) => Label(t['cat'].toString(),
                        LabelStyle(textStyle: const TextStyle(fontSize: 9)))),
                elevation: ElevationEncode(value: 3),
              ),
            ],
            coord: PolarCoord(startRadius: 0.1),
          ),
        ),

        // 15. Mapa de calor (avanzado)
        ChartCard(
          number: 15,
          title: 'Mapa de calor: productos por categoría y rango de rating',
          advanced: true,
          observation:
              'La intensidad del color indica cuántos productos caen en cada celda categoría × rango de rating.',
          height: 320,
          child: _heatmap(),
        ),
      ],
    );
  }

  Widget _heatmap() {
    const buckets = ['<3.5', '3.5-4', '4-4.5', '≥4.5'];
    String bucket(double r) => r < 3.5
        ? buckets[0]
        : r < 4
            ? buckets[1]
            : r < 4.5
                ? buckets[2]
                : buckets[3];
    final cats = data.top(6);
    final rows = <Map<String, dynamic>>[];
    for (final c in cats) {
      for (final b in buckets) {
        final n = data.products
            .where((p) => p.category == c.name && bucket(p.rating) == b)
            .length;
        rows.add({'cat': c.shortName, 'bucket': b, 'n': n});
      }
    }
    return Chart(
      data: rows,
      variables: {
        'cat': Variable(accessor: (Map m) => m['cat'] as String),
        'bucket': Variable(
          accessor: (Map m) => m['bucket'] as String,
          scale: OrdinalScale(values: buckets),
        ),
        'n': Variable(accessor: (Map m) => m['n'] as num),
      },
      marks: [
        PolygonMark(
          color: ColorEncode(
            variable: 'n',
            values: [const Color(0xFFEFF6FF), const Color(0xFF1D4ED8)],
          ),
          label: LabelEncode(encoder: (t) => Label(t['n'].toString())),
        ),
      ],
      axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
    );
  }
}
