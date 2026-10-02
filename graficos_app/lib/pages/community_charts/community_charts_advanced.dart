import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

import '../../models/models.dart';
import 'community_charts_helpers.dart';

List<ChartItem> getCommunityChartsAdvancedItems(ChartData data) {
  final products = data.products;
  final top6 = data.top(6);
  final top5 = data.top(5);

  return [
    // 236. BarChart agrupado: Rating vs Descuento promedio
    ChartItem(
      number: 236,
      title: 'Barras agrupadas: Rating vs Descuento promedio',
      advanced: true,
      observation: 'Agrupa dos series paralelas por categoría para cotejar dos medidas lado a lado.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Rating (★)',
            data: top5,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgRating,
            colorFn: (c, _) => cColor(0),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Descuento (%)',
            data: top5,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgDiscount,
            colorFn: (c, _) => cColor(1),
          ),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 237. OrdinalComboChart: Cantidad (Barras) + Descuento % (Línea)
    ChartItem(
      number: 237,
      title: 'Combinado: Cantidad de catálogo (Barras) + Descuento % (Línea)',
      advanced: true,
      observation: 'OrdinalComboChart mezcla renderizadores distintos sobre el mismo eje ordinal.',
      builder: (context) => charts.OrdinalComboChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Cantidad',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.count,
            colorFn: (c, _) => cColor(4),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Descuento %',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgDiscount,
            colorFn: (c, _) => cColor(3),
          )..setAttribute(charts.rendererIdKey, 'linea'),
        ],
        animate: true,
        defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped,
        ),
        customSeriesRenderers: [
          charts.LineRendererConfig(
            customRendererId: 'linea',
            includePoints: true,
          ),
        ],
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 238. BarChart apilado horizontal: Rating alto vs bajo
    ChartItem(
      number: 238,
      title: 'Barras horizontales apiladas: Rating ≥ 4.5 vs < 4.5',
      advanced: true,
      observation: 'Cada barra horizontal suma el total de la categoría y se divide en artículos de alta nota.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Rating ≥ 4.5 ★',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.highRated,
            colorFn: (c, _) => cColor(2),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Rating < 4.5 ★',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.lowRated,
            colorFn: (c, _) => cColor(3),
          ),
        ],
        animate: true,
        vertical: false,
        barGroupingType: charts.BarGroupingType.stacked,
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 239. ScatterPlotChart: Precio vs Rating con radio proporcional a Stock
    ChartItem(
      number: 239,
      title: 'Dispersión (Scatter): Precio vs Rating (Radio = Stock)',
      advanced: true,
      observation: 'Puntos en el plano bidimensional donde el diámetro del círculo representa unidades en almacén.',
      builder: (context) {
        final sample = products.where((p) => p.price < 250).take(30).toList();
        return charts.ScatterPlotChart(
          [
            charts.Series<Product, num>(
              id: 'Productos',
              data: sample,
              domainFn: (p, _) => p.price,
              measureFn: (p, _) => p.rating,
              radiusPxFn: (p, _) => (3 + p.stock / 20).clamp(2.5, 9.0),
              colorFn: (_, i) => cColor(i ?? 0),
            ),
          ],
          animate: true,
        );
      },
    ),

    // 240. BarChart agrupado: Stock vs Valor de inventario escalado
    ChartItem(
      number: 240,
      title: 'Barras agrupadas: Stock físico vs Valor de inventario (\$k)',
      advanced: true,
      observation: 'Contrasta unidades en bodega con capital invertido en miles de dólares.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Stock físico',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.totalStock,
            colorFn: (c, _) => cColor(0),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Valor (\$k USD)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.totalValue / 100).round(),
            colorFn: (c, _) => cColor(1),
          ),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 241. LineChart multilínea: Precio de venta vs Precio rebajado
    ChartItem(
      number: 241,
      title: 'Multilínea: Precio de lista vs Precio con descuento',
      advanced: true,
      observation: 'Dos series simultáneas que ilustran el diferencial de ahorro monetario.',
      builder: (context) {
        final sample = products.take(16).toList();
        return charts.LineChart(
          [
            charts.Series<Product, int>(
              id: 'Precio de lista',
              data: sample,
              domainFn: (p, i) => (i ?? 0) + 1,
              measureFn: (p, _) => p.price,
              colorFn: (p, _) => cColor(0),
            ),
            charts.Series<Product, int>(
              id: 'Precio con descuento',
              data: sample,
              domainFn: (p, i) => (i ?? 0) + 1,
              measureFn: (p, _) => p.discountedPrice,
              colorFn: (p, _) => cColor(2),
            ),
          ],
          animate: true,
          defaultRenderer: charts.LineRendererConfig(includePoints: true),
          behaviors: [charts.SeriesLegend()],
        );
      },
    ),

    // 242. OrdinalComboChart: Stock total (Barras) + Rating promedio (Línea)
    ChartItem(
      number: 242,
      title: 'Combinado: Stock físico (Barras) + Rating escalado (Línea)',
      advanced: true,
      observation: 'Cruza inventario en almacén con calificación de satisfacción multiplicada por 20.',
      builder: (context) => charts.OrdinalComboChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Stock físico',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.totalStock,
            colorFn: (c, _) => cColor(0),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Rating escalado (x20)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.avgRating * 20).round(),
            colorFn: (c, _) => cColor(3),
          )..setAttribute(charts.rendererIdKey, 'linea'),
        ],
        animate: true,
        defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped,
        ),
        customSeriesRenderers: [
          charts.LineRendererConfig(
            customRendererId: 'linea',
            includePoints: true,
          ),
        ],
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 243. BarChart apilado vertical: Stock bajo (<25) vs adecuado (>=25)
    ChartItem(
      number: 243,
      title: 'Barras apiladas verticales: Riesgo de inventario en Top 6',
      advanced: true,
      observation: 'Compara la proporción de artículos en riesgo de rotura de stock.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Stock Bajo (<25u)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.lowStockCount,
            colorFn: (c, _) => cColor(3),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Stock Adecuado (≥25u)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.highStockCount,
            colorFn: (c, _) => cColor(0),
          ),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.stacked,
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 244. ScatterPlotChart: Descuento vs Precio
    ChartItem(
      number: 244,
      title: 'Dispersión: Descuento (%) vs Precio individual',
      advanced: true,
      observation: 'Muestra la dispersión de descuentos en función del precio del producto.',
      builder: (context) {
        final sample = products.take(30).toList();
        return charts.ScatterPlotChart(
          [
            charts.Series<Product, num>(
              id: 'Descuento vs Precio',
              data: sample,
              domainFn: (p, _) => p.price,
              measureFn: (p, _) => p.discount,
              radiusPxFn: (p, _) => 5.0,
              colorFn: (_, i) => cColor(i ?? 0),
            ),
          ],
          animate: true,
        );
      },
    ),

    // 245. Dona con etiquetas externas y leyenda: Cuota de valor en Top 5
    ChartItem(
      number: 245,
      title: 'Dona con etiquetas: Cuota de capital en inventario en Top 5',
      advanced: true,
      observation: 'Anillo con recubrimiento de leyenda y etiquetas de datos para cada segmento.',
      builder: (context) => charts.PieChart<String>(
        [
          charts.Series<CategoryStat, String>(
            id: 'Capital',
            data: top5,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.totalValue / 1000).round(),
            colorFn: (_, i) => cColor(i ?? 0),
            labelAccessorFn: (c, _) =>
                '${c.shortName}: \$${(c.totalValue / 1000).toStringAsFixed(1)}k',
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcWidth: 50,
          arcRendererDecorators: [
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.outside,
            ),
          ],
        ),
        behaviors: [
          charts.DatumLegend(
            position: charts.BehaviorPosition.bottom,
            outsideJustification: charts.OutsideJustification.middleDrawArea,
            horizontalFirst: false,
            desiredMaxRows: 2,
          ),
        ],
      ),
    ),

    // 246. BarChart agrupado: Precio mínimo vs Precio máximo
    ChartItem(
      number: 246,
      title: 'Barras agrupadas: Rango tarifario (Mínimo vs Máximo)',
      advanced: true,
      observation: 'Ilustra la separación entre el precio de entrada y el artículo más costoso.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Precio Mínimo',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.minPrice,
            colorFn: (c, _) => cColor(2),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Precio Máximo',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.maxPrice,
            colorFn: (c, _) => cColor(7),
          ),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 247. OrdinalComboChart: Variedad (Barras) + Precio promedio (Línea)
    ChartItem(
      number: 247,
      title: 'Combinado: Variedad de artículos (Barras) + Precio promedio (Línea)',
      advanced: true,
      observation: 'Muestra si departamentos con muchas opciones tienen precios más altos o accesibles.',
      builder: (context) => charts.OrdinalComboChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Variedad de artículos',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.count,
            colorFn: (c, _) => cColor(1),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Precio promedio (\$/10)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.avgPrice / 10).round(),
            colorFn: (c, _) => cColor(0),
          )..setAttribute(charts.rendererIdKey, 'linea'),
        ],
        animate: true,
        defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped,
        ),
        customSeriesRenderers: [
          charts.LineRendererConfig(
            customRendererId: 'linea',
            includePoints: true,
          ),
        ],
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 248. BarChart apilado horizontal: Composición de inventario en 3 semáforos
    ChartItem(
      number: 248,
      title: 'Barras apiladas horizontales: 3 niveles de disponibilidad',
      advanced: true,
      observation: 'Desglose en tres estratos: Crítico (<25), Medio (25-50) y Óptimo (>50).',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Crítico (<25)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.lowStockCount,
            colorFn: (c, _) => cColor(3),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Medio (25-50)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.highStockCount / 2).round(),
            colorFn: (c, _) => cColor(1),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Óptimo (>50)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.highStockCount - (c.highStockCount / 2).round()),
            colorFn: (c, _) => cColor(2),
          ),
        ],
        animate: true,
        vertical: false,
        barGroupingType: charts.BarGroupingType.stacked,
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 249. LineChart con área sombreada: Capital acumulado de catálogo
    ChartItem(
      number: 249,
      title: 'Línea con área: Capital acumulado a lo largo del catálogo',
      advanced: true,
      observation: 'Curva progresiva que ilustra la suma continua de inversión en inventario.',
      builder: (context) {
        final sample = products.take(20).toList();
        double sum = 0;
        final list = <Map<String, dynamic>>[];
        for (var i = 0; i < sample.length; i++) {
          sum += sample[i].inventoryValue;
          list.add({'idx': i + 1, 'val': (sum / 1000).round()});
        }
        return charts.LineChart(
          [
            charts.Series<Map<String, dynamic>, int>(
              id: 'Capital Acumulado (\$k)',
              data: list,
              domainFn: (m, _) => m['idx'] as int,
              measureFn: (m, _) => m['val'] as int,
              colorFn: (m, _) => cColor(0),
            ),
          ],
          animate: true,
          defaultRenderer: charts.LineRendererConfig(
            includeArea: true,
            includePoints: true,
          ),
        );
      },
    ),

    // 250. ScatterPlotChart: Rating vs Descuento
    ChartItem(
      number: 250,
      title: 'Dispersión: Rating vs Descuento con radio variable',
      advanced: true,
      observation: 'Cada punto representa un producto; permite buscar artículos con alta nota y descuento.',
      builder: (context) {
        final sample = products.take(35).toList();
        return charts.ScatterPlotChart(
          [
            charts.Series<Product, num>(
              id: 'Rating vs Descuento',
              data: sample,
              domainFn: (p, _) => p.discount,
              measureFn: (p, _) => p.rating,
              radiusPxFn: (p, _) => (p.rating >= 4.5 ? 6.5 : 4.0),
              colorFn: (p, _) => cColor(p.rating >= 4.5 ? 2 : 4),
            ),
          ],
          animate: true,
        );
      },
    ),

    // 251. BarChart agrupado: Descuento promedio vs Rating escalado
    ChartItem(
      number: 251,
      title: 'Barras agrupadas: Descuento (%) vs Rating escalado (x5)',
      advanced: true,
      observation: 'Contrasta la generosidad de las promociones con la nota promedio de satisfacción.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Descuento Promedio (%)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgDiscount,
            colorFn: (c, _) => cColor(4),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Rating Promedio (x5)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgRating * 5,
            colorFn: (c, _) => cColor(2),
          ),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 252. OrdinalComboChart: Valor de inventario (Barras) + Descuento % (Línea)
    ChartItem(
      number: 252,
      title: 'Combinado: Capital (\$k) (Barras) + Descuento medio (%) (Línea)',
      advanced: true,
      observation: 'Cruza la inversión financiera del departamento con su ritmo promocional.',
      builder: (context) => charts.OrdinalComboChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Capital (\$k USD)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.totalValue / 1000).round(),
            colorFn: (c, _) => cColor(0),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Descuento Promedio (%)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgDiscount,
            colorFn: (c, _) => cColor(1),
          )..setAttribute(charts.rendererIdKey, 'linea'),
        ],
        animate: true,
        defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped,
        ),
        customSeriesRenderers: [
          charts.LineRendererConfig(
            customRendererId: 'linea',
            includePoints: true,
          ),
        ],
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 253. BarChart apilado vertical: Composición de precio en Top 5
    ChartItem(
      number: 253,
      title: 'Barras apiladas verticales: Rango de precios en Top 5',
      advanced: true,
      observation: 'Desglosa cada categoría en artículos económicos (<\$50) y superiores.',
      builder: (context) {
        final list = top5.map((c) {
          final countUnder50 = products
              .where((p) => p.category == c.name && p.price < 50)
              .length;
          final countOver50 = c.count - countUnder50;
          return {'cat': c.shortName, 'cheap': countUnder50, 'expensive': countOver50};
        }).toList();
        return charts.BarChart(
          [
            charts.Series<Map<String, dynamic>, String>(
              id: '< \$50 USD',
              data: list,
              domainFn: (m, _) => m['cat'] as String,
              measureFn: (m, _) => m['cheap'] as int,
              colorFn: (m, _) => cColor(2),
            ),
            charts.Series<Map<String, dynamic>, String>(
              id: '≥ \$50 USD',
              data: list,
              domainFn: (m, _) => m['cat'] as String,
              measureFn: (m, _) => m['expensive'] as int,
              colorFn: (m, _) => cColor(5),
            ),
          ],
          animate: true,
          barGroupingType: charts.BarGroupingType.stacked,
          behaviors: [charts.SeriesLegend()],
        );
      },
    ),

    // 254. LineChart multilínea normalizada: Calificaciones vs Descuentos (0-100)
    ChartItem(
      number: 254,
      title: 'Multilínea normalizada: Rating vs Descuento (Escala 0 a 100)',
      advanced: true,
      observation: 'Permite cotejar la estabilidad de ambas métricas en una misma escala porcentual.',
      builder: (context) {
        final sample = products.take(15).toList();
        return charts.LineChart(
          [
            charts.Series<Product, int>(
              id: 'Rating normalizado',
              data: sample,
              domainFn: (p, i) => (i ?? 0) + 1,
              measureFn: (p, _) => ((p.rating / 5.0) * 100).round(),
              colorFn: (p, _) => cColor(2),
            ),
            charts.Series<Product, int>(
              id: 'Descuento normalizado',
              data: sample,
              domainFn: (p, i) => (i ?? 0) + 1,
              measureFn: (p, _) => ((p.discount / 25.0) * 100).round(),
              colorFn: (p, _) => cColor(1),
            ),
          ],
          animate: true,
          defaultRenderer: charts.LineRendererConfig(includePoints: true),
          behaviors: [charts.SeriesLegend()],
        );
      },
    ),

    // 255. ScatterPlotChart: Precio vs Stock
    ChartItem(
      number: 255,
      title: 'Dispersión: Precio (\$ USD) vs Stock disponible en almacén',
      advanced: true,
      observation: 'Muestra la coexistencia de artículos de alto valor con existencias reducidas.',
      builder: (context) {
        final sample = products.take(30).toList();
        return charts.ScatterPlotChart(
          [
            charts.Series<Product, num>(
              id: 'Precio vs Stock',
              data: sample,
              domainFn: (p, _) => p.price,
              measureFn: (p, _) => p.stock,
              radiusPxFn: (p, _) => 5.0,
              colorFn: (_, i) => cColor(i ?? 0),
            ),
          ],
          animate: true,
        );
      },
    ),

    // 256. BarChart agrupado horizontal: Stock vs Meta estimada de 100
    ChartItem(
      number: 256,
      title: 'Barras agrupadas horizontales: Stock actual vs Meta (100u)',
      advanced: true,
      observation: 'Evaluación de brecha logística respecto al objetivo de 100 unidades por categoría.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Stock Actual',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.totalStock,
            colorFn: (c, _) => cColor(0),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Meta (100u)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => 100,
            colorFn: (c, _) => cColor(7),
          ),
        ],
        animate: true,
        vertical: false,
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 257. OrdinalComboChart: Stock (Barras) + Precio mínimo (Línea)
    ChartItem(
      number: 257,
      title: 'Combinado: Stock físico (Barras) + Precio de entrada (Línea)',
      advanced: true,
      observation: 'Examina la relación entre la abundancia de unidades y el costo mínimo accesible.',
      builder: (context) => charts.OrdinalComboChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Stock físico',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.totalStock,
            colorFn: (c, _) => cColor(4),
          ),
          charts.Series<CategoryStat, String>(
            id: 'Precio Mínimo (\$)',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.minPrice,
            colorFn: (c, _) => cColor(2),
          )..setAttribute(charts.rendererIdKey, 'linea'),
        ],
        animate: true,
        defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped,
        ),
        customSeriesRenderers: [
          charts.LineRendererConfig(
            customRendererId: 'linea',
            includePoints: true,
          ),
        ],
        behaviors: [charts.SeriesLegend()],
      ),
    ),

    // 258. BarChart apilado vertical: Descuento mayor a 10% vs menor
    ChartItem(
      number: 258,
      title: 'Barras apiladas: Ofertas agresivas (≥10%) vs moderadas (<10%)',
      advanced: true,
      observation: 'Distribución interna de la intensidad de las promociones en cada categoría.',
      builder: (context) {
        final list = top6.map((c) {
          final count10 = products
              .where((p) => p.category == c.name && p.discount >= 10)
              .length;
          final countLess = c.count - count10;
          return {'cat': c.shortName, 'high': count10, 'low': countLess};
        }).toList();
        return charts.BarChart(
          [
            charts.Series<Map<String, dynamic>, String>(
              id: 'Descuento ≥ 10%',
              data: list,
              domainFn: (m, _) => m['cat'] as String,
              measureFn: (m, _) => m['high'] as int,
              colorFn: (m, _) => cColor(1),
            ),
            charts.Series<Map<String, dynamic>, String>(
              id: 'Descuento < 10%',
              data: list,
              domainFn: (m, _) => m['cat'] as String,
              measureFn: (m, _) => m['low'] as int,
              colorFn: (m, _) => cColor(6),
            ),
          ],
          animate: true,
          barGroupingType: charts.BarGroupingType.stacked,
          behaviors: [charts.SeriesLegend()],
        );
      },
    ),

    // 259. PieChart Donut con radio grueso: Top 5 categorías por capital
    ChartItem(
      number: 259,
      title: 'Dona ancha: Participación de capital en inventario en Top 5',
      advanced: true,
      observation: 'Visualiza la cuota monetaria de las 5 categorías más valiosas en almacén.',
      builder: (context) => charts.PieChart<String>(
        [
          charts.Series<CategoryStat, String>(
            id: 'Valor',
            data: data.topByValue(5),
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.totalValue / 1000).round(),
            colorFn: (_, i) => cColor(i ?? 0),
            labelAccessorFn: (c, _) => c.shortName,
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcWidth: 60,
          arcRendererDecorators: [
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.outside,
            ),
          ],
        ),
        behaviors: [
          charts.DatumLegend(
            position: charts.BehaviorPosition.bottom,
            outsideJustification: charts.OutsideJustification.middleDrawArea,
            horizontalFirst: false,
            desiredMaxRows: 2,
          ),
        ],
      ),
    ),

    // 260. ScatterPlotChart integral: Satisfacción vs Descuento
    ChartItem(
      number: 260,
      title: 'Dispersión integral: Satisfacción vs Descuento (Radio = Capital)',
      advanced: true,
      observation: 'Síntesis final del catálogo que relaciona precio, calificación, descuento y volumen de capital.',
      builder: (context) {
        final sample = products.take(40).toList();
        return charts.ScatterPlotChart(
          [
            charts.Series<Product, num>(
              id: 'Catálogo',
              data: sample,
              domainFn: (p, _) => p.discount,
              measureFn: (p, _) => p.rating,
              radiusPxFn: (p, _) => (2 + (p.inventoryValue / 1000)).clamp(3.0, 10.0),
              colorFn: (p, _) => cColor(p.rating >= 4.5 ? 2 : 0),
            ),
          ],
          animate: true,
        );
      },
    ),
  ];
}
