import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;

import '../../models/models.dart';
import 'community_charts_helpers.dart';

List<ChartItem> getCommunityChartsBasicItems(ChartData data) {
  final products = data.products;
  final top6 = data.top(6);
  final top5 = data.top(5);
  final top8 = data.top(8);
  final pBrackets = data.priceBrackets;
  final sBrackets = data.stockBrackets;
  final dBrackets = data.discountBrackets;
  final rBrackets = data.ratingBrackets;

  return [
    // 196. BarChart vertical: Precio promedio en Top 6
    ChartItem(
      number: 196,
      title: 'Barras verticales: Precio promedio en Top 6 categorías',
      advanced: false,
      observation: 'Compara el costo medio de los artículos en cada categoría líder.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Precio',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgPrice,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
      ),
    ),

    // 197. LineChart: Stock de primeros 20 productos
    ChartItem(
      number: 197,
      title: 'Línea con puntos: Unidades de stock en 20 productos',
      advanced: false,
      observation: 'Los marcadores resaltan baches y abundancia de inventario.',
      builder: (context) => charts.LineChart(
        [
          charts.Series<Product, int>(
            id: 'Stock',
            data: products.take(20).toList(),
            domainFn: (p, i) => (i ?? 0) + 1,
            measureFn: (p, _) => p.stock,
            colorFn: (p, _) => cColor(2),
          ),
        ],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
      ),
    ),

    // 198. Dona: Cantidad de productos en Top 5 categorías
    ChartItem(
      number: 198,
      title: 'Dona: Distribución de productos en Top 5 categorías',
      advanced: false,
      observation: 'Las etiquetas externas identifican cada porción con su recuento exacto.',
      builder: (context) => charts.PieChart<String>(
        [
          charts.Series<CategoryStat, String>(
            id: 'Categorías',
            data: top5,
            domainFn: (c, _) => c.name,
            measureFn: (c, _) => c.count,
            colorFn: (_, i) => cColor(i ?? 0),
            labelAccessorFn: (c, _) => '${c.shortName}: ${c.count}',
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcWidth: 45,
          arcRendererDecorators: [
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.outside,
            ),
          ],
        ),
      ),
    ),

    // 199. BarChart vertical: Stock total en Top 6 categorías
    ChartItem(
      number: 199,
      title: 'Barras verticales: Stock acumulado en Top 6',
      advanced: false,
      observation: 'Volumen físico total de inventario en almacén.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Stock',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.totalStock,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
      ),
    ),

    // 200. LineChart: Calificaciones de primeros 20 productos
    ChartItem(
      number: 200,
      title: 'Línea continua: Calificaciones (★) de 20 productos',
      advanced: false,
      observation: 'Muestra la regularidad en la satisfacción del cliente.',
      builder: (context) => charts.LineChart(
        [
          charts.Series<Product, int>(
            id: 'Rating',
            data: products.take(20).toList(),
            domainFn: (p, i) => (i ?? 0) + 1,
            measureFn: (p, _) => p.rating,
            colorFn: (p, _) => cColor(0),
          ),
        ],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
      ),
    ),

    // 201. BarChart horizontal: Descuento promedio en Top 6
    ChartItem(
      number: 201,
      title: 'Barras horizontales: % Descuento promedio en Top 6',
      advanced: false,
      observation: 'La disposición horizontal facilita la lectura de departamentos.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Descuento',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgDiscount,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
        vertical: false,
      ),
    ),

    // 202. PieChart: Cuota de inventario en Top 5
    ChartItem(
      number: 202,
      title: 'Pastel: Cuota de inventario en Top 5 categorías',
      advanced: false,
      observation: 'Proporción de unidades físicas acaparadas por cada categoría líder.',
      builder: (context) => charts.PieChart<String>(
        [
          charts.Series<CategoryStat, String>(
            id: 'Inventario',
            data: top5,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.totalStock,
            colorFn: (_, i) => cColor(i ?? 0),
            labelAccessorFn: (c, _) => '${c.shortName}: ${c.totalStock}',
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcRendererDecorators: [
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.outside,
            ),
          ],
        ),
      ),
    ),

    // 203. LineChart: Variación de descuento en 15 productos
    ChartItem(
      number: 203,
      title: 'Línea: Variación de descuento en 15 productos',
      advanced: false,
      observation: 'Fluctuación en los porcentajes de rebajas entre productos contiguos.',
      builder: (context) => charts.LineChart(
        [
          charts.Series<Product, int>(
            id: 'Descuento',
            data: products.take(15).toList(),
            domainFn: (p, i) => (i ?? 0) + 1,
            measureFn: (p, _) => p.discount,
            colorFn: (p, _) => cColor(1),
          ),
        ],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
      ),
    ),

    // 204. BarChart vertical: Catálogo por rango de precio
    ChartItem(
      number: 204,
      title: 'Barras verticales: Catálogo según banda de precio',
      advanced: false,
      observation: 'Histograma de cantidad de referencias disponibles en cada estrato.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<RangeBracket, String>(
            id: 'Artículos',
            data: pBrackets,
            domainFn: (b, _) => b.label,
            measureFn: (b, _) => b.count,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
      ),
    ),

    // 205. BarChart horizontal: 8 productos con más stock
    ChartItem(
      number: 205,
      title: 'Barras horizontales: 8 productos con mayor inventario',
      advanced: false,
      observation: 'Los artículos con mayor disponibilidad física inmediata.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<Product, String>(
            id: 'Stock',
            data: data.topProductsByStock(8).reversed.toList(),
            domainFn: (p, _) => p.shortTitle,
            measureFn: (p, _) => p.stock,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
        vertical: false,
      ),
    ),

    // 206. PieChart: Proporción por rango de descuento
    ChartItem(
      number: 206,
      title: 'Pastel: Artículos según nivel de descuento',
      advanced: false,
      observation: 'Muestra la cuota de productos que gozan de ofertas leves o agresivas.',
      builder: (context) => charts.PieChart<String>(
        [
          charts.Series<RangeBracket, String>(
            id: 'Descuento',
            data: dBrackets,
            domainFn: (b, _) => b.label,
            measureFn: (b, _) => b.count,
            colorFn: (_, i) => cColor(i ?? 0),
            labelAccessorFn: (b, _) => '${b.label}: ${b.count}',
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcRendererDecorators: [
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.outside,
            ),
          ],
        ),
      ),
    ),

    // 207. LineChart: Precios de primeros 15 productos
    ChartItem(
      number: 207,
      title: 'Línea continua: Precios de lista de 15 productos',
      advanced: false,
      observation: 'Curva que refleja la dispersión en los precios individuales.',
      builder: (context) => charts.LineChart(
        [
          charts.Series<Product, int>(
            id: 'Precio',
            data: products.take(15).toList(),
            domainFn: (p, i) => (i ?? 0) + 1,
            measureFn: (p, _) => p.price,
            colorFn: (p, _) => cColor(4),
          ),
        ],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
      ),
    ),

    // 208. BarChart horizontal: Precios de los 8 productos más costosos
    ChartItem(
      number: 208,
      title: 'Barras horizontales: 8 productos más caros de la tienda',
      advanced: false,
      observation: 'Ranking de los artículos de gama más alta.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<Product, String>(
            id: 'Precio',
            data: data.topProductsByPrice(8).reversed.toList(),
            domainFn: (p, _) => p.shortTitle,
            measureFn: (p, _) => p.price,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
        vertical: false,
      ),
    ),

    // 209. BarChart vertical: Valor de inventario (\$k) en Top 6
    ChartItem(
      number: 209,
      title: 'Barras verticales: Capital de inventario (\$k) en Top 6',
      advanced: false,
      observation: 'Inversión monetaria acumulada en miles de dólares en las categorías clave.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Capital',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.totalValue / 1000).round(),
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
      ),
    ),

    // 210. Dona: Nivel de stock (Crítico, Bajo, Medio, Alto)
    ChartItem(
      number: 210,
      title: 'Dona: Estado de existencias (Crítico a Alto)',
      advanced: false,
      observation: 'Alerta sobre la proporción de artículos que requieren reorden en almacén.',
      builder: (context) => charts.PieChart<String>(
        [
          charts.Series<RangeBracket, String>(
            id: 'Stock',
            data: sBrackets,
            domainFn: (b, _) => b.label,
            measureFn: (b, _) => b.count,
            colorFn: (_, i) => cColor(i ?? 0),
            labelAccessorFn: (b, _) => '${b.label}: ${b.count}',
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcWidth: 40,
          arcRendererDecorators: [
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.outside,
            ),
          ],
        ),
      ),
    ),

    // 211. LineChart: Curva ascendente de precios ordenados
    ChartItem(
      number: 211,
      title: 'Línea ascendente: 20 productos ordenados por precio',
      advanced: false,
      observation: 'Pendiente de costo desde los artículos más asequibles.',
      builder: (context) => charts.LineChart(
        [
          charts.Series<Product, int>(
            id: 'Precio',
            data: data.cheapestProducts(20),
            domainFn: (p, i) => (i ?? 0) + 1,
            measureFn: (p, _) => p.price,
            colorFn: (p, _) => cColor(0),
          ),
        ],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
      ),
    ),

    // 212. BarChart horizontal: Stock en 8 productos más baratos
    ChartItem(
      number: 212,
      title: 'Barras horizontales: Stock en los 8 artículos más baratos',
      advanced: false,
      observation: 'Verifica la suficiencia de stock en la gama económica del catálogo.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<Product, String>(
            id: 'Stock',
            data: data.cheapestProducts(8).reversed.toList(),
            domainFn: (p, _) => p.shortTitle,
            measureFn: (p, _) => p.stock,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
        vertical: false,
      ),
    ),

    // 213. BarChart vertical: Rating promedio en Top 8
    ChartItem(
      number: 213,
      title: 'Barras verticales: Rating promedio en Top 8 categorías',
      advanced: false,
      observation: 'Evaluación de satisfacción de clientes en los 8 departamentos líderes.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Rating',
            data: top8,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgRating,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
      ),
    ),

    // 214. PieChart: Productos con rating >= 4.5 vs otros
    ChartItem(
      number: 214,
      title: 'Pastel: Productos con Rating ≥ 4.5 vs Otros',
      advanced: false,
      observation: 'Proporción de artículos con máxima excelencia de reseñas.',
      builder: (context) {
        final high = products.where((p) => p.rating >= 4.5).length;
        final low = products.length - high;
        return charts.PieChart<String>(
          [
            charts.Series<Map<String, dynamic>, String>(
              id: 'Excelencia',
              data: [
                {'name': '≥ 4.5 ★', 'val': high, 'col': 2},
                {'name': '< 4.5 ★', 'val': low, 'col': 3},
              ],
              domainFn: (m, _) => m['name'] as String,
              measureFn: (m, _) => m['val'] as int,
              colorFn: (m, _) => cColor(m['col'] as int),
              labelAccessorFn: (m, _) => '${m['name']}: ${m['val']}',
            ),
          ],
          animate: true,
          defaultRenderer: charts.ArcRendererConfig<String>(
            arcRendererDecorators: [
              charts.ArcLabelDecorator<String>(
                labelPosition: charts.ArcLabelPosition.outside,
              ),
            ],
          ),
        );
      },
    ),

    // 215. LineChart con área sombreada: Tendencia de precios
    ChartItem(
      number: 215,
      title: 'Línea con área: Distribución de precios de 15 productos',
      advanced: false,
      observation: 'El área rellena enfatiza el volumen financiero de la serie.',
      builder: (context) => charts.LineChart(
        [
          charts.Series<Product, int>(
            id: 'Precio',
            data: products.take(15).toList(),
            domainFn: (p, i) => (i ?? 0) + 1,
            measureFn: (p, _) => p.price,
            colorFn: (p, _) => cColor(5),
          ),
        ],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(
          includeArea: true,
          includePoints: true,
        ),
      ),
    ),

    // 216. BarChart horizontal: Descuento en categorías líderes
    ChartItem(
      number: 216,
      title: 'Barras horizontales: Descuento en categorías líderes',
      advanced: false,
      observation: 'Facilita la comparación de rebajas entre departamentos.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Descuento',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.avgDiscount,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
        vertical: false,
      ),
    ),

    // 217. BarChart vertical: Existencias en almacén por banda de precio
    ChartItem(
      number: 217,
      title: 'Barras verticales: Stock total por banda de precio',
      advanced: false,
      observation: 'Indica en qué niveles de precio se ubica la mayor cantidad de piezas.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<RangeBracket, String>(
            id: 'Stock',
            data: pBrackets,
            domainFn: (b, _) => b.label,
            measureFn: (b, _) => b.totalStock,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
      ),
    ),

    // 218. PieChart: Stock crítico (<20u) vs Normal
    ChartItem(
      number: 218,
      title: 'Pastel: Stock crítico (<20u) vs Resto',
      advanced: false,
      observation: 'Indicador porcentual de artículos con urgencia de reabastecimiento.',
      builder: (context) {
        final crit = products.where((p) => p.stock < 20).length;
        final rest = products.length - crit;
        return charts.PieChart<String>(
          [
            charts.Series<Map<String, dynamic>, String>(
              id: 'Estado',
              data: [
                {'name': 'Crítico (<20)', 'val': crit, 'col': 3},
                {'name': 'Normal (≥20)', 'val': rest, 'col': 0},
              ],
              domainFn: (m, _) => m['name'] as String,
              measureFn: (m, _) => m['val'] as int,
              colorFn: (m, _) => cColor(m['col'] as int),
              labelAccessorFn: (m, _) => '${m['name']}: ${m['val']}',
            ),
          ],
          animate: true,
          defaultRenderer: charts.ArcRendererConfig<String>(
            arcRendererDecorators: [
              charts.ArcLabelDecorator<String>(
                labelPosition: charts.ArcLabelPosition.outside,
              ),
            ],
          ),
        );
      },
    ),

    // 219. LineChart: Rating en productos de bajo costo (< $50)
    ChartItem(
      number: 219,
      title: 'Línea con puntos: Rating en productos accesibles (< \$50)',
      advanced: false,
      observation: 'Verifica la satisfacción de los clientes en artículos económicos.',
      builder: (context) {
        final cheap = products.where((p) => p.price < 50).take(15).toList();
        return charts.LineChart(
          [
            charts.Series<Product, int>(
              id: 'Rating',
              data: cheap,
              domainFn: (p, i) => (i ?? 0) + 1,
              measureFn: (p, _) => p.rating,
              colorFn: (p, _) => cColor(2),
            ),
          ],
          animate: true,
          defaultRenderer: charts.LineRendererConfig(includePoints: true),
        );
      },
    ),

    // 220. BarChart horizontal: Precios mínimos por categoría (Top 6)
    ChartItem(
      number: 220,
      title: 'Barras horizontales: Precio mínimo registrado en Top 6',
      advanced: false,
      observation: 'Precio de partida más accesible por familia de producto.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Precio Mínimo',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.minPrice,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
        vertical: false,
      ),
    ),

    // 221. BarChart vertical: Variedad de artículos en Top 8
    ChartItem(
      number: 221,
      title: 'Barras verticales: Variedad de productos en Top 8',
      advanced: false,
      observation: 'Cantidad de referencias activas en el catálogo por departamento.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Variedad',
            data: top8,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.count,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
      ),
    ),

    // 222. PieChart: Cuota de las 3 categorías principales en stock
    ChartItem(
      number: 222,
      title: 'Pastel: Cuota de inventario en Top 3 categorías',
      advanced: false,
      observation: 'Participación porcentual de stock entre las 3 categorías con mayor volumen.',
      builder: (context) => charts.PieChart<String>(
        [
          charts.Series<CategoryStat, String>(
            id: 'Top 3',
            data: data.topByStock(3),
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.totalStock,
            colorFn: (_, i) => cColor(i ?? 0),
            labelAccessorFn: (c, _) => '${c.shortName}: ${c.totalStock}',
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcRendererDecorators: [
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.outside,
            ),
          ],
        ),
      ),
    ),

    // 223. LineChart: Descuentos en productos con rating >= 4.0
    ChartItem(
      number: 223,
      title: 'Línea con puntos: Descuentos en productos destacados (≥4.0)',
      advanced: false,
      observation: 'Examina qué ofertas reciben los productos mejor valorados.',
      builder: (context) {
        final high = products.where((p) => p.rating >= 4.0).take(15).toList();
        return charts.LineChart(
          [
            charts.Series<Product, int>(
              id: 'Descuento',
              data: high,
              domainFn: (p, i) => (i ?? 0) + 1,
              measureFn: (p, _) => p.discount,
              colorFn: (p, _) => cColor(6),
            ),
          ],
          animate: true,
          defaultRenderer: charts.LineRendererConfig(includePoints: true),
        );
      },
    ),

    // 224. BarChart horizontal: Precios máximos en Top 6
    ChartItem(
      number: 224,
      title: 'Barras horizontales: Precio tope por categoría en Top 6',
      advanced: false,
      observation: 'El artículo insignia con mayor precio dentro de cada categoría.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Precio Tope',
            data: top6,
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.maxPrice,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
        vertical: false,
      ),
    ),

    // 225. BarChart vertical: Artículos por banda de descuento
    ChartItem(
      number: 225,
      title: 'Barras verticales: Artículos según nivel de descuento',
      advanced: false,
      observation: 'Recuento de artículos en cada tramo porcentual de promoción.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<RangeBracket, String>(
            id: 'Descuento',
            data: dBrackets,
            domainFn: (b, _) => b.label,
            measureFn: (b, _) => b.count,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
      ),
    ),

    // 226. Dona: Cuota de capital en inventario en Top 4
    ChartItem(
      number: 226,
      title: 'Dona: Capital de inventario en Top 4 categorías',
      advanced: false,
      observation: 'Distribución porcentual del valor financiero total inmovilizado.',
      builder: (context) => charts.PieChart<String>(
        [
          charts.Series<CategoryStat, String>(
            id: 'Valor',
            data: data.topByValue(4),
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => c.totalValue.round(),
            colorFn: (_, i) => cColor(i ?? 0),
            labelAccessorFn: (c, _) =>
                '${c.shortName}: \$${(c.totalValue / 1000).toStringAsFixed(1)}k',
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcWidth: 45,
          arcRendererDecorators: [
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.outside,
            ),
          ],
        ),
      ),
    ),

    // 227. LineChart: Niveles de stock en productos de belleza
    ChartItem(
      number: 227,
      title: 'Línea con puntos: Unidades de stock en la categoría líder',
      advanced: false,
      observation: 'Muestra la dispersión de unidades físicas dentro de la categoría con más productos.',
      builder: (context) {
        final list = products.where((p) => p.category == top5.first.name).toList();
        return charts.LineChart(
          [
            charts.Series<Product, int>(
              id: 'Stock',
              data: list,
              domainFn: (p, i) => (i ?? 0) + 1,
              measureFn: (p, _) => p.stock,
              colorFn: (p, _) => cColor(3),
            ),
          ],
          animate: true,
          defaultRenderer: charts.LineRendererConfig(includePoints: true),
        );
      },
    ),

    // 228. BarChart horizontal: 8 productos con mayor % descuento
    ChartItem(
      number: 228,
      title: 'Barras horizontales: 8 productos con más descuento',
      advanced: false,
      observation: 'Ranking de los descuentos más agresivos aplicados en tienda.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<Product, String>(
            id: 'Descuento',
            data: data.topProductsByDiscount(8).reversed.toList(),
            domainFn: (p, _) => p.shortTitle,
            measureFn: (p, _) => p.discount,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
        vertical: false,
      ),
    ),

    // 229. BarChart vertical: Rating promedio según banda de precio
    ChartItem(
      number: 229,
      title: 'Barras verticales: Rating promedio por rango de precio',
      advanced: false,
      observation: 'Compara si los artículos de mayor costo reciben mejores valoraciones.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<RangeBracket, String>(
            id: 'Rating',
            data: pBrackets,
            domainFn: (b, _) => b.label,
            measureFn: (b, _) => b.avgRating,
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
      ),
    ),

    // 230. PieChart: Distribución de productos por rango de calificación
    ChartItem(
      number: 230,
      title: 'Pastel: Segmentación por nivel de satisfacción',
      advanced: false,
      observation: 'Cuota de catálogo dividida en tramos de estrellas.',
      builder: (context) => charts.PieChart<String>(
        [
          charts.Series<RangeBracket, String>(
            id: 'Rating',
            data: rBrackets,
            domainFn: (b, _) => b.label,
            measureFn: (b, _) => b.count,
            colorFn: (_, i) => cColor(i ?? 0),
            labelAccessorFn: (b, _) => '${b.label}: ${b.count}',
          ),
        ],
        animate: true,
        defaultRenderer: charts.ArcRendererConfig<String>(
          arcRendererDecorators: [
            charts.ArcLabelDecorator<String>(
              labelPosition: charts.ArcLabelPosition.outside,
            ),
          ],
        ),
      ),
    ),

    // 231. LineChart: Precios de productos con rating >= 4.0
    ChartItem(
      number: 231,
      title: 'Línea con puntos: Precios en productos con Rating ≥ 4.0',
      advanced: false,
      observation: 'Precios de lista de los artículos con mayor satisfacción de compra.',
      builder: (context) {
        final high = products.where((p) => p.rating >= 4.0).take(15).toList();
        return charts.LineChart(
          [
            charts.Series<Product, int>(
              id: 'Precio',
              data: high,
              domainFn: (p, i) => (i ?? 0) + 1,
              measureFn: (p, _) => p.price,
              colorFn: (p, _) => cColor(1),
            ),
          ],
          animate: true,
          defaultRenderer: charts.LineRendererConfig(includePoints: true),
        );
      },
    ),

    // 232. BarChart horizontal: Ranking de valor de inventario en Top 6
    ChartItem(
      number: 232,
      title: 'Barras horizontales: Capital de inventario en Top 6',
      advanced: false,
      observation: 'Visualización clara de capital en miles de dólares por departamento.',
      builder: (context) => charts.BarChart(
        [
          charts.Series<CategoryStat, String>(
            id: 'Capital',
            data: top6.reversed.toList(),
            domainFn: (c, _) => c.shortName,
            measureFn: (c, _) => (c.totalValue / 1000).round(),
            colorFn: (_, i) => cColor(i ?? 0),
          ),
        ],
        animate: true,
        vertical: false,
      ),
    ),

    // 233. BarChart vertical: Precio promedio en categorías con rating >= 4.0
    ChartItem(
      number: 233,
      title: 'Barras verticales: Precio medio en categorías con Rating ≥ 4.0',
      advanced: false,
      observation: 'Evalúa el nivel tarifario de los departamentos mejor calificados.',
      builder: (context) {
        final highCats = data.categories.where((c) => c.avgRating >= 4.0).take(6).toList();
        return charts.BarChart(
          [
            charts.Series<CategoryStat, String>(
              id: 'Precio',
              data: highCats,
              domainFn: (c, _) => c.shortName,
              measureFn: (c, _) => c.avgPrice,
              colorFn: (_, i) => cColor(i ?? 0),
            ),
          ],
          animate: true,
        );
      },
    ),

    // 234. PieChart: Categorías con rating >= 4.0 vs resto
    ChartItem(
      number: 234,
      title: 'Pastel: Categorías con Rating ≥ 4.0 vs Resto',
      advanced: false,
      observation: 'Muestra qué porcentaje de familias de productos superan el estándar de 4 estrellas.',
      builder: (context) {
        final high = data.categories.where((c) => c.avgRating >= 4.0).length;
        final low = data.categories.length - high;
        return charts.PieChart<String>(
          [
            charts.Series<Map<String, dynamic>, String>(
              id: 'Calidad',
              data: [
                {'name': '≥ 4.0 ★', 'val': high, 'col': 2},
                {'name': '< 4.0 ★', 'val': low, 'col': 4},
              ],
              domainFn: (m, _) => m['name'] as String,
              measureFn: (m, _) => m['val'] as int,
              colorFn: (m, _) => cColor(m['col'] as int),
              labelAccessorFn: (m, _) => '${m['name']}: ${m['val']}',
            ),
          ],
          animate: true,
          defaultRenderer: charts.ArcRendererConfig<String>(
            arcRendererDecorators: [
              charts.ArcLabelDecorator<String>(
                labelPosition: charts.ArcLabelPosition.outside,
              ),
            ],
          ),
        );
      },
    ),

    // 235. LineChart: Margen de ahorro en 15 artículos
    ChartItem(
      number: 235,
      title: 'Línea con puntos: Monto de ahorro (\$ USD) en 15 artículos',
      advanced: false,
      observation: 'Calcula en dólares el dinero exacto ahorrado por el comprador en cada producto.',
      builder: (context) => charts.LineChart(
        [
          charts.Series<Product, int>(
            id: 'Ahorro',
            data: products.take(15).toList(),
            domainFn: (p, i) => (i ?? 0) + 1,
            measureFn: (p, _) => p.discountAmount,
            colorFn: (p, _) => cColor(0),
          ),
        ],
        animate: true,
        defaultRenderer: charts.LineRendererConfig(includePoints: true),
      ),
    ),
  ];
}
