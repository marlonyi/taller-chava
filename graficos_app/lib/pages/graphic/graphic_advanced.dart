import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

import '../../models/models.dart';
import '../../theme/palette.dart';

List<ChartItem> getGraphicAdvancedItems(ChartData data) {
  final products = data.products;
  final top8 = data.top(8);
  final top6 = data.top(6);
  final top5 = data.top(5);

  Widget makeHeatmap({
    required List<String> xValues,
    required List<String> yValues,
    required num Function(String x, String y) counter,
    required String titleX,
    required String titleY,
  }) {
    final rows = <Map<String, dynamic>>[];
    for (final x in xValues) {
      for (final y in yValues) {
        rows.add({'x': x, 'y': y, 'n': counter(x, y)});
      }
    }
    return Chart(
      data: rows,
      variables: {
        'x': Variable(
          accessor: (Map m) => m['x'] as String,
          scale: OrdinalScale(values: xValues),
        ),
        'y': Variable(
          accessor: (Map m) => m['y'] as String,
          scale: OrdinalScale(values: yValues),
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

  return [
    // 171. Rosa de Nightingale: Precio promedio por categoría
    ChartItem(
      number: 171,
      title: 'Rosa de Nightingale: Precio promedio en Top 8 categorías',
      advanced: true,
      height: 320,
      observation: 'Gráfico polar donde el radio de cada pétalo codifica el precio medio.',
      builder: (context) {
        final rows = [
          for (final c in top8)
            {'cat': c.shortName, 'price': double.parse(c.avgPrice.toStringAsFixed(1))},
        ];
        return Chart(
          data: rows,
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
                encoder: (t) => Label(
                  t['cat'].toString(),
                  LabelStyle(textStyle: const TextStyle(fontSize: 9)),
                ),
              ),
              elevation: ElevationEncode(value: 3),
            ),
          ],
          coord: PolarCoord(startRadius: 0.1),
        );
      },
    ),

    // 172. Mapa de calor (PolygonMark): Categoría × Rango de Rating
    ChartItem(
      number: 172,
      title: 'Mapa de calor: Categoría × Rango de Calificación',
      advanced: true,
      height: 320,
      observation: 'La intensidad de azul indica la densidad de productos en cada combinación.',
      builder: (context) {
        const buckets = ['<3.5', '3.5-4', '4-4.5', '≥4.5'];
        String bucket(double r) => r < 3.5
            ? buckets[0]
            : r < 4
                ? buckets[1]
                : r < 4.5
                    ? buckets[2]
                    : buckets[3];
        return makeHeatmap(
          xValues: top6.map((c) => c.shortName).toList(),
          yValues: buckets,
          counter: (cat, b) => products
              .where((p) =>
                  top6.firstWhere((c) => c.shortName == cat).name == p.category &&
                  bucket(p.rating) == b)
              .length,
          titleX: 'Categoría',
          titleY: 'Rating',
        );
      },
    ),

    // 173. Rosa de Nightingale: Stock total por categoría (Top 6)
    ChartItem(
      number: 173,
      title: 'Rosa de Nightingale: Stock total en Top 6 categorías',
      advanced: true,
      height: 320,
      observation: 'El radio polar ilustra la magnitud de existencias en almacén por departamento.',
      builder: (context) {
        final rows = [
          for (final c in top6) {'cat': c.shortName, 'stock': c.totalStock},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(variable: 'cat', values: palette),
              label: LabelEncode(
                encoder: (t) => Label(
                  '${t['cat']}: ${t['stock']}',
                  LabelStyle(textStyle: const TextStyle(fontSize: 9)),
                ),
              ),
              elevation: ElevationEncode(value: 2),
            ),
          ],
          coord: PolarCoord(startRadius: 0.15),
        );
      },
    ),

    // 174. Mapa de calor: Categoría × Rango de Precio
    ChartItem(
      number: 174,
      title: 'Mapa de calor: Categoría × Nivel de Precio',
      advanced: true,
      height: 320,
      observation: 'Concentración de productos en cada nivel de precio para cada categoría.',
      builder: (context) {
        const buckets = ['< \$25', '\$25-\$50', '\$50-\$100', '≥ \$100'];
        String bucket(double p) => p < 25
            ? buckets[0]
            : p < 50
                ? buckets[1]
                : p < 100
                    ? buckets[2]
                    : buckets[3];
        return makeHeatmap(
          xValues: top6.map((c) => c.shortName).toList(),
          yValues: buckets,
          counter: (cat, b) => products
              .where((p) =>
                  top6.firstWhere((c) => c.shortName == cat).name == p.category &&
                  bucket(p.price) == b)
              .length,
          titleX: 'Categoría',
          titleY: 'Precio',
        );
      },
    ),

    // 175. Rosa de Nightingale: Descuento promedio por categoría
    ChartItem(
      number: 175,
      title: 'Rosa de Nightingale: % Descuento promedio en Top 6',
      advanced: true,
      height: 320,
      observation: 'Radio codificado con el porcentaje medio de rebajas en cada área.',
      builder: (context) {
        final rows = [
          for (final c in top6)
            {'cat': c.shortName, 'disc': double.parse(c.avgDiscount.toStringAsFixed(1))},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'disc': Variable(
              accessor: (Map m) => m['disc'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(variable: 'cat', values: palette),
              label: LabelEncode(
                encoder: (t) => Label(
                  '${t['cat']}\n${t['disc']}%',
                  LabelStyle(textStyle: const TextStyle(fontSize: 8)),
                ),
              ),
              elevation: ElevationEncode(value: 3),
            ),
          ],
          coord: PolarCoord(startRadius: 0.1),
        );
      },
    ),

    // 176. Mapa de calor: Nivel de Stock × Nivel de Descuento
    ChartItem(
      number: 176,
      title: 'Mapa de calor: Nivel de Stock × Nivel de Descuento',
      advanced: true,
      height: 320,
      observation: 'Evalúa la frecuencia cruzada entre escasez/abundancia y volumen de rebaja.',
      builder: (context) {
        const sLabels = ['<20', '20-50', '50-80', '≥80'];
        const dLabels = ['<5%', '5-10%', '10-15%', '≥15%'];
        String sBucket(int s) => s < 20
            ? sLabels[0]
            : s < 50
                ? sLabels[1]
                : s < 80
                    ? sLabels[2]
                    : sLabels[3];
        String dBucket(double d) => d < 5
            ? dLabels[0]
            : d < 10
                ? dLabels[1]
                : d < 15
                    ? dLabels[2]
                    : dLabels[3];
        return makeHeatmap(
          xValues: sLabels,
          yValues: dLabels,
          counter: (s, d) => products
              .where((p) => sBucket(p.stock) == s && dBucket(p.discount) == d)
              .length,
          titleX: 'Stock',
          titleY: 'Descuento',
        );
      },
    ),

    // 177. Gráfico polar: Variedad de catálogo (Coxcomb)
    ChartItem(
      number: 177,
      title: 'Diagrama Polar Coxcomb: Variedad de artículos en Top 8',
      advanced: true,
      height: 320,
      observation: 'Cada sector polar esférico refleja la cantidad de referencias ofertadas.',
      builder: (context) {
        final rows = [
          for (final c in top8) {'cat': c.shortName, 'count': c.count},
        ];
        return Chart(
          data: rows,
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
                encoder: (t) => Label(
                  '${t['cat']}: ${t['count']}',
                  LabelStyle(textStyle: const TextStyle(fontSize: 8)),
                ),
              ),
              elevation: ElevationEncode(value: 2),
            ),
          ],
          coord: PolarCoord(startRadius: 0.2),
        );
      },
    ),

    // 178. Mapa de calor: Categoría × Nivel de Stock
    ChartItem(
      number: 178,
      title: 'Mapa de calor: Categoría × Nivel de Inventario',
      advanced: true,
      height: 320,
      observation: 'Distribución cruzada de existencias por familia de productos.',
      builder: (context) {
        const sLabels = ['Crítico (<20)', 'Medio (20-60)', 'Alto (>60)'];
        String sBucket(int s) => s < 20
            ? sLabels[0]
            : s <= 60
                ? sLabels[1]
                : sLabels[2];
        return makeHeatmap(
          xValues: top6.map((c) => c.shortName).toList(),
          yValues: sLabels,
          counter: (cat, s) => products
              .where((p) =>
                  top6.firstWhere((c) => c.shortName == cat).name == p.category &&
                  sBucket(p.stock) == s)
              .length,
          titleX: 'Categoría',
          titleY: 'Stock',
        );
      },
    ),

    // 179. Gráfico de dispersión multivariable: X=Precio, Y=Rating, Tamaño=Stock, Color=Categoría
    ChartItem(
      number: 179,
      title: 'Dispersión multivariable: X=Precio, Y=Rating, Tamaño=Stock',
      advanced: true,
      observation: 'Codificación en 4 canales gráficos simultáneos: X, Y, Radio y Paleta de color.',
      builder: (context) {
        final sample = products.where((p) => p.price < 250).take(35).toList();
        final rows = [
          for (final p in sample)
            {
              'price': p.price,
              'rating': p.rating,
              'stock': p.stock,
              'cat': p.category,
            },
        ];
        return Chart(
          data: rows,
          variables: {
            'price': Variable(
              accessor: (Map m) => m['price'] as num,
              scale: LinearScale(min: 0),
            ),
            'rating': Variable(
              accessor: (Map m) => m['rating'] as num,
              scale: LinearScale(min: 1, max: 5),
            ),
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
          },
          marks: [
            PointMark(
              size: SizeEncode(
                variable: 'stock',
                values: [4.0, 12.0],
              ),
              color: ColorEncode(variable: 'cat', values: palette),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
          selections: {'tap': PointSelection()},
          tooltip: TooltipGuide(),
        );
      },
    ),

    // 180. Barras con DodgeModifier (agrupadas): Rating alto vs bajo
    ChartItem(
      number: 180,
      title: 'Barras agrupadas (Dodge): Rating ≥ 4.5 vs < 4.5',
      advanced: true,
      observation: 'Usa DodgeModifier para ubicar las barras de calidad una al lado de la otra.',
      builder: (context) {
        final rows = <Map<String, dynamic>>[];
        for (final c in top6) {
          rows.add({'cat': c.shortName, 'type': '≥ 4.5 ★', 'val': c.highRated});
          rows.add({'cat': c.shortName, 'type': '< 4.5 ★', 'val': c.lowRated});
        }
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'val': Variable(
              accessor: (Map m) => m['val'] as num,
              scale: LinearScale(min: 0),
            ),
            'type': Variable(accessor: (Map m) => m['type'] as String),
          },
          marks: [
            IntervalMark(
              position: Varset('cat') * Varset('val') / Varset('type'),
              color: ColorEncode(variable: 'type', values: [palette[2], palette[4]]),
              modifiers: [DodgeModifier()],
              label: LabelEncode(encoder: (t) => Label(t['val'].toString())),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 181. Rosa de Nightingale: Valor total de inventario en Top 6
    ChartItem(
      number: 181,
      title: 'Rosa de Nightingale: Capital en inventario (\$k) en Top 6',
      advanced: true,
      height: 320,
      observation: 'Codifica el volumen financiero inmovilizado en cada sección mediante el radio.',
      builder: (context) {
        final rows = [
          for (final c in top6)
            {
              'cat': c.shortName,
              'val': double.parse((c.totalValue / 1000).toStringAsFixed(1)),
            },
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'val': Variable(
              accessor: (Map m) => m['val'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(variable: 'cat', values: palette),
              label: LabelEncode(
                encoder: (t) => Label(
                  '${t['cat']}\n\$${t['val']}k',
                  LabelStyle(textStyle: const TextStyle(fontSize: 8)),
                ),
              ),
              elevation: ElevationEncode(value: 3),
            ),
          ],
          coord: PolarCoord(startRadius: 0.1),
        );
      },
    ),

    // 182. Mapa de calor: Rango de Precio × Rango de Rating
    ChartItem(
      number: 182,
      title: 'Mapa de calor: Rango de Precio × Rango de Calificación',
      advanced: true,
      height: 320,
      observation: 'Matriz bidimensional de densidad que ilustra dónde se concentran los artículos de la tienda.',
      builder: (context) {
        const pLabels = ['< \$25', '\$25-\$50', '\$50-\$100', '≥ \$100'];
        const rLabels = ['< 3.5 ★', '3.5-4 ★', '4-4.5 ★', '≥ 4.5 ★'];
        String pBucket(double p) => p < 25
            ? pLabels[0]
            : p < 50
                ? pLabels[1]
                : p < 100
                    ? pLabels[2]
                    : pLabels[3];
        String rBucket(double r) => r < 3.5
            ? rLabels[0]
            : r < 4
                ? rLabels[1]
                : r < 4.5
                    ? rLabels[2]
                    : rLabels[3];
        return makeHeatmap(
          xValues: pLabels,
          yValues: rLabels,
          counter: (p, r) => products
              .where((item) => pBucket(item.price) == p && rBucket(item.rating) == r)
              .length,
          titleX: 'Precio',
          titleY: 'Rating',
        );
      },
    ),

    // 183. Barras con StackModifier (apiladas): Stock bajo vs normal
    ChartItem(
      number: 183,
      title: 'Barras apiladas (Stack): Stock bajo vs Stock adecuado',
      advanced: true,
      observation: 'Apilamiento proporcional que suma el total de catálogo por categoría.',
      builder: (context) {
        final rows = <Map<String, dynamic>>[];
        for (final c in top6) {
          rows.add({'cat': c.shortName, 'status': 'Bajo (<25)', 'val': c.lowStockCount});
          rows.add({'cat': c.shortName, 'status': 'Adecuado (≥25)', 'val': c.highStockCount});
        }
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'val': Variable(
              accessor: (Map m) => m['val'] as num,
              scale: LinearScale(min: 0),
            ),
            'status': Variable(accessor: (Map m) => m['status'] as String),
          },
          marks: [
            IntervalMark(
              position: Varset('cat') * Varset('val') / Varset('status'),
              color: ColorEncode(variable: 'status', values: [palette[3], palette[0]]),
              modifiers: [StackModifier()],
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 184. Gráfico de burbujas multivariable: X=Descuento, Y=Precio, Tamaño=Stock
    ChartItem(
      number: 184,
      title: 'Burbujas: X=Descuento, Y=Precio, Tamaño=Unidades en Bodega',
      advanced: true,
      observation: 'Correlación multivariable de tres dimensiones comerciales.',
      builder: (context) {
        final sample = products.where((p) => p.price < 200).take(30).toList();
        final rows = [
          for (final p in sample)
            {'disc': p.discount, 'price': p.price, 'stock': p.stock},
        ];
        return Chart(
          data: rows,
          variables: {
            'disc': Variable(
              accessor: (Map m) => m['disc'] as num,
              scale: LinearScale(min: 0),
            ),
            'price': Variable(
              accessor: (Map m) => m['price'] as num,
              scale: LinearScale(min: 0),
            ),
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            PointMark(
              size: SizeEncode(
                variable: 'stock',
                values: [4.0, 14.0],
              ),
              color: ColorEncode(value: palette[1].withValues(alpha: 0.65)),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
          selections: {'tap': PointSelection()},
          tooltip: TooltipGuide(),
        );
      },
    ),

    // 185. Rosa de Nightingale: Proporción de stock en Top 5
    ChartItem(
      number: 185,
      title: 'Rosa de Nightingale: Cuota de inventario en Top 5',
      advanced: true,
      height: 320,
      observation: 'Diagrama radial que resalta visualmente el liderazgo de stock.',
      builder: (context) {
        final rows = [
          for (final c in top5) {'cat': c.shortName, 'stock': c.totalStock},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(variable: 'cat', values: palette),
              label: LabelEncode(
                encoder: (t) => Label(
                  '${t['cat']}\n${t['stock']}u',
                  LabelStyle(textStyle: const TextStyle(fontSize: 8)),
                ),
              ),
              elevation: ElevationEncode(value: 2),
            ),
          ],
          coord: PolarCoord(startRadius: 0.1),
        );
      },
    ),

    // 186. Mapa de calor: Categoría × Nivel de Descuento
    ChartItem(
      number: 186,
      title: 'Mapa de calor: Categoría × Nivel de Descuento (%)',
      advanced: true,
      height: 320,
      observation: 'Densidad de promociones aplicadas en las distintas categorías.',
      builder: (context) {
        const dLabels = ['< 5%', '5-10%', '10-15%', '≥ 15%'];
        String dBucket(double d) => d < 5
            ? dLabels[0]
            : d < 10
                ? dLabels[1]
                : d < 15
                    ? dLabels[2]
                    : dLabels[3];
        return makeHeatmap(
          xValues: top6.map((c) => c.shortName).toList(),
          yValues: dLabels,
          counter: (cat, d) => products
              .where((p) =>
                  top6.firstWhere((c) => c.shortName == cat).name == p.category &&
                  dBucket(p.discount) == d)
              .length,
          titleX: 'Categoría',
          titleY: 'Descuento',
        );
      },
    ),

    // 187. Línea con Crosshair y TooltipGuide interactivo
    ChartItem(
      number: 187,
      title: 'Línea interactiva con Crosshair: Tendencia de precios',
      advanced: true,
      observation: 'Toca en cualquier parte para ver la cruceta dinámica y tarjeta de detalle flotante.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 20; i++)
            {'idx': '${i + 1}', 'price': products[i].price},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'price': Variable(
              accessor: (Map m) => m['price'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            LineMark(
              shape: ShapeEncode(value: BasicLineShape(smooth: true)),
              color: ColorEncode(value: palette[0]),
              size: SizeEncode(value: 3),
            ),
            PointMark(
              size: SizeEncode(value: 5),
              color: ColorEncode(value: palette[3]),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
          selections: {'tap': PointSelection(dim: Dim.x)},
          tooltip: TooltipGuide(),
          crosshair: CrosshairGuide(),
        );
      },
    ),

    // 188. Barras horizontales con DodgeModifier: Stock vs Variedad
    ChartItem(
      number: 188,
      title: 'Barras agrupadas horizontales: Stock escalado vs Variedad',
      advanced: true,
      observation: 'Disposición horizontal de barras dobles para comparar dos dimensiones por departamento.',
      builder: (context) {
        final rows = <Map<String, dynamic>>[];
        for (final c in top6) {
          rows.add({'cat': c.shortName, 'type': 'Variedad', 'val': c.count});
          rows.add({'cat': c.shortName, 'type': 'Stock (x0.1)', 'val': (c.totalStock / 10).round()});
        }
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'val': Variable(
              accessor: (Map m) => m['val'] as num,
              scale: LinearScale(min: 0),
            ),
            'type': Variable(accessor: (Map m) => m['type'] as String),
          },
          marks: [
            IntervalMark(
              position: Varset('cat') * Varset('val') / Varset('type'),
              color: ColorEncode(variable: 'type', values: [palette[0], palette[6]]),
              modifiers: [DodgeModifier()],
              label: LabelEncode(encoder: (t) => Label(t['val'].toString())),
            ),
          ],
          coord: RectCoord(transposed: true),
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 189. Rosa de Nightingale: Ratings promedio en Top 6
    ChartItem(
      number: 189,
      title: 'Rosa de Nightingale: Rating promedio en Top 6 categorías',
      advanced: true,
      height: 320,
      observation: 'Cada pétalo codifica en radio la satisfacción promedio de clientes.',
      builder: (context) {
        final rows = [
          for (final c in top6)
            {'cat': c.shortName, 'rating': double.parse(c.avgRating.toStringAsFixed(2))},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'rating': Variable(
              accessor: (Map m) => m['rating'] as num,
              scale: LinearScale(min: 2, max: 5),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(variable: 'cat', values: palette),
              label: LabelEncode(
                encoder: (t) => Label(
                  '${t['cat']}\n★${t['rating']}',
                  LabelStyle(textStyle: const TextStyle(fontSize: 8)),
                ),
              ),
              elevation: ElevationEncode(value: 3),
            ),
          ],
          coord: PolarCoord(startRadius: 0.1),
        );
      },
    ),

    // 190. Mapa de calor: Stock × Rating
    ChartItem(
      number: 190,
      title: 'Mapa de calor: Nivel de Stock × Nivel de Calificación',
      advanced: true,
      height: 320,
      observation: 'Determina si artículos con mejores valoraciones tienden a tener menor o mayor inventario.',
      builder: (context) {
        const sLabels = ['< 25u', '25-50u', '50-80u', '≥ 80u'];
        const rLabels = ['< 3.5 ★', '3.5-4 ★', '4-4.5 ★', '≥ 4.5 ★'];
        String sBucket(int s) => s < 25
            ? sLabels[0]
            : s < 50
                ? sLabels[1]
                : s < 80
                    ? sLabels[2]
                    : sLabels[3];
        String rBucket(double r) => r < 3.5
            ? rLabels[0]
            : r < 4
                ? rLabels[1]
                : r < 4.5
                    ? rLabels[2]
                    : rLabels[3];
        return makeHeatmap(
          xValues: sLabels,
          yValues: rLabels,
          counter: (s, r) => products
              .where((item) => sBucket(item.stock) == s && rBucket(item.rating) == r)
              .length,
          titleX: 'Stock',
          titleY: 'Rating',
        );
      },
    ),

    // 191. Dispersión con selecciones táctiles (PointSelection) y Tooltip
    ChartItem(
      number: 191,
      title: 'Dispersión interactiva: Precio vs Descuento con selección táctil',
      advanced: true,
      observation: 'Toca cualquier punto para seleccionarlo de forma interactiva y desplegar su valor.',
      builder: (context) {
        final sample = products.take(30).toList();
        final rows = [
          for (final p in sample)
            {'price': p.price, 'discount': p.discount, 'title': p.shortTitle},
        ];
        return Chart(
          data: rows,
          variables: {
            'price': Variable(
              accessor: (Map m) => m['price'] as num,
              scale: LinearScale(min: 0),
            ),
            'discount': Variable(
              accessor: (Map m) => m['discount'] as num,
              scale: LinearScale(min: 0),
            ),
            'title': Variable(accessor: (Map m) => m['title'] as String),
          },
          marks: [
            PointMark(
              size: SizeEncode(value: 8),
              color: ColorEncode(value: palette[2]),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
          selections: {'tap': PointSelection()},
          tooltip: TooltipGuide(),
        );
      },
    ),

    // 192. Barras apiladas (StackModifier): Catálogo por bandas de precio
    ChartItem(
      number: 192,
      title: 'Barras apiladas: Composición de precio en Top 4 categorías',
      advanced: true,
      observation: 'Estratifica cada columna de categoría en rangos de precios (económico, medio, premium).',
      builder: (context) {
        const pLabels = ['< \$50', '\$50-\$100', '≥ \$100'];
        String pBucket(double p) => p < 50
            ? pLabels[0]
            : p < 100
                ? pLabels[1]
                : pLabels[2];
        final rows = <Map<String, dynamic>>[];
        for (final c in top5.take(4)) {
          for (final b in pLabels) {
            final count = products
                .where((p) => p.category == c.name && pBucket(p.price) == b)
                .length;
            rows.add({'cat': c.shortName, 'tier': b, 'n': count});
          }
        }
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'n': Variable(
              accessor: (Map m) => m['n'] as num,
              scale: LinearScale(min: 0),
            ),
            'tier': Variable(accessor: (Map m) => m['tier'] as String),
          },
          marks: [
            IntervalMark(
              position: Varset('cat') * Varset('n') / Varset('tier'),
              color: ColorEncode(variable: 'tier', values: [palette[0], palette[1], palette[3]]),
              modifiers: [StackModifier()],
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 193. Rosa de Nightingale: Desempeño relativo en 6 categorías líderes
    ChartItem(
      number: 193,
      title: 'Rosa de Nightingale: Mapeo de inventario y rotación',
      advanced: true,
      height: 320,
      observation: 'Cada sector circular compara el tamaño relativo de catálogo e inventario.',
      builder: (context) {
        final rows = [
          for (final c in top6)
            {'cat': c.shortName, 'val': (c.totalStock / 20).round()},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'val': Variable(
              accessor: (Map m) => m['val'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(variable: 'cat', values: palette),
              label: LabelEncode(
                encoder: (t) => Label(
                  '${t['cat']}',
                  LabelStyle(textStyle: const TextStyle(fontSize: 8)),
                ),
              ),
              elevation: ElevationEncode(value: 3),
            ),
          ],
          coord: PolarCoord(startRadius: 0.1),
        );
      },
    ),

    // 194. Mapa de calor: Distribución cruzada de valor de inventario
    ChartItem(
      number: 194,
      title: 'Mapa de calor: Categoría × Rango de Valor Monetario',
      advanced: true,
      height: 320,
      observation: 'Permite identificar qué segmentos concentran mayor peso en capital inmovilizado.',
      builder: (context) {
        const vLabels = ['< \$1k', '\$1k-\$3k', '≥ \$3k'];
        String vBucket(double v) => v < 1000
            ? vLabels[0]
            : v < 3000
                ? vLabels[1]
                : vLabels[2];
        return makeHeatmap(
          xValues: top6.map((c) => c.shortName).toList(),
          yValues: vLabels,
          counter: (cat, v) => products
              .where((p) =>
                  top6.firstWhere((c) => c.shortName == cat).name == p.category &&
                  vBucket(p.inventoryValue) == v)
              .length,
          titleX: 'Categoría',
          titleY: 'Valor',
        );
      },
    ),

    // 195. Gráfico polar compuesto: Densidad multivariable de catálogo
    ChartItem(
      number: 195,
      title: 'Diagrama Polar Coxcomb: Síntesis de catálogo multivariable',
      advanced: true,
      height: 320,
      observation: 'Combina coordenadas polares, elevación de sombreado y codificación por color.',
      builder: (context) {
        final rows = [
          for (final c in top6)
            {'cat': c.shortName, 'score': (c.avgRating * c.count).round()},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'score': Variable(
              accessor: (Map m) => m['score'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(variable: 'cat', values: palette),
              label: LabelEncode(
                encoder: (t) => Label(
                  '${t['cat']}',
                  LabelStyle(textStyle: const TextStyle(fontSize: 8)),
                ),
              ),
              elevation: ElevationEncode(value: 4),
            ),
          ],
          coord: PolarCoord(startRadius: 0.15),
        );
      },
    ),
  ];
}
