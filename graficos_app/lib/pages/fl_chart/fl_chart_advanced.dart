import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/palette.dart';
import 'fl_chart_helpers.dart';

List<ChartItem> getFlChartAdvancedItems(ChartData data) {
  final products = data.products;
  final top6 = data.top(6);
  final top5 = data.top(5);

  Widget makeRadar(
    List<CategoryStat> cats,
    Map<String, double Function(CategoryStat)> metrics,
  ) {
    double maxOf(double Function(CategoryStat) f) =>
        cats.map(f).reduce((a, b) => a > b ? a : b).clamp(0.001, double.infinity);
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
                    borderColor: palette[i % palette.length],
                    fillColor: palette[i % palette.length].withValues(alpha: 0.2),
                    entryRadius: 3,
                    dataEntries: [
                      for (final f in metrics.values)
                        RadarEntry(value: (f(cats[i]) / maxOf(f)) * 100),
                    ],
                  ),
              ],
            ),
          ),
        ),
        flLegend(cats.map((c) => c.shortName).toList()),
      ],
    );
  }

  return [
    // 41. Radar: Comparación multivariable de 3 categorías principales
    ChartItem(
      number: 41,
      title: 'Radar: Comparativa multivariable en Top 3 categorías',
      advanced: true,
      height: 320,
      observation: 'Normaliza a escala 0-100: Precio, Rating, Stock, Descuento y Cantidad.',
      builder: (context) => makeRadar(
        data.top(3),
        {
          'Precio': (c) => c.avgPrice,
          'Rating': (c) => c.avgRating,
          'Stock': (c) => c.totalStock.toDouble(),
          'Descuento': (c) => c.avgDiscount,
          'Cantidad': (c) => c.count.toDouble(),
        },
      ),
    ),

    // 42. Burbujas / Dispersión: Precio vs Rating (tamaño = stock)
    ChartItem(
      number: 42,
      title: 'Dispersión: Precio vs Rating (Tamaño = Stock, Color = Cat)',
      advanced: true,
      observation: 'Cada burbuja es un producto; permite descubrir si artículos caros reciben mejores notas.',
      builder: (context) {
        final ps = products.where((p) => p.price < 250).toList();
        final cats = data.categories.map((c) => c.name).toList();
        return ScatterChart(
          ScatterChartData(
            minY: 2.0,
            maxY: 5.0,
            borderData: FlBorderData(show: true),
            titlesData: flTitles(
              bottom: (v) => '\$${v.toInt()}',
              left: (v) => '★${v.toStringAsFixed(1)}',
            ),
            scatterSpots: [
              for (final p in ps)
                ScatterSpot(
                  p.price,
                  p.rating,
                  dotPainter: FlDotCirclePainter(
                    radius: 3 + (p.stock / 15).clamp(1.0, 10.0),
                    color: palette[cats.indexOf(p.category) % palette.length]
                        .withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        );
      },
    ),

    // 43. Multilínea: Precio normal vs Precio con descuento de 15 productos
    ChartItem(
      number: 43,
      title: 'Multilínea: Precio de lista vs Precio con descuento',
      advanced: true,
      observation: 'Muestra la brecha de ahorro monetario directo que experimenta el comprador por producto.',
      builder: (context) {
        final sample = products.take(15).toList();
        return Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < sample.length; i++)
                          FlSpot(i.toDouble(), sample[i].price),
                      ],
                      isCurved: true,
                      color: palette[0],
                      barWidth: 3,
                    ),
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < sample.length; i++)
                          FlSpot(i.toDouble(), sample[i].discountedPrice),
                      ],
                      isCurved: true,
                      color: palette[2],
                      barWidth: 3,
                      dashArray: [5, 4],
                    ),
                  ],
                ),
              ),
            ),
            flLegend(['Precio de lista', 'Precio rebajado'], [palette[0], palette[2]]),
          ],
        );
      },
    ),

    // 44. Barras agrupadas: Stock vs Valor normalizado en Top 6
    ChartItem(
      number: 44,
      title: 'Barras agrupadas: Stock físico vs Valor (\$k) en Top 6',
      advanced: true,
      observation: 'Compara lado a lado unidades en bodega con el capital inmovilizado en miles de dólares.',
      builder: (context) => Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: flTitles(bottom: (v) => top6[v.toInt()].shortName, rotate: true),
                barGroups: [
                  for (var i = 0; i < top6.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: top6[i].totalStock.toDouble(),
                          color: palette[0],
                          width: 10,
                        ),
                        BarChartRodData(
                          toY: top6[i].totalValue / 50,
                          color: palette[1],
                          width: 10,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          flLegend(['Stock físico', 'Valor en inventario (escalado)'], [palette[0], palette[1]]),
        ],
      ),
    ),

    // 45. Radar: Evaluación de 4 categorías en 5 ejes
    ChartItem(
      number: 45,
      title: 'Radar: Perfil competitivo de 4 categorías clave',
      advanced: true,
      height: 320,
      observation: 'Mapea simultáneamente el rendimiento en Precio, Rating, Stock y Descuento.',
      builder: (context) => makeRadar(
        data.top(4),
        {
          'Precio prom': (c) => c.avgPrice,
          'Rating': (c) => c.avgRating,
          'Stock': (c) => c.totalStock.toDouble(),
          'Descuento %': (c) => c.avgDiscount,
        },
      ),
    ),

    // 46. Dispersión: Descuento % vs Rating (cuadrantes de oportunidad)
    ChartItem(
      number: 46,
      title: 'Dispersión: % Descuento vs Calificación de satisfacción',
      advanced: true,
      observation: 'Cuadrante superior derecho: gangas de alta calidad (mucho descuento y alto rating).',
      builder: (context) {
        final ps = products.take(40).toList();
        return ScatterChart(
          ScatterChartData(
            minY: 2.0,
            maxY: 5.0,
            borderData: FlBorderData(show: true),
            titlesData: flTitles(
              bottom: (v) => '${v.toInt()}%',
              left: (v) => '★${v.toStringAsFixed(1)}',
            ),
            scatterSpots: [
              for (final p in ps)
                ScatterSpot(
                  p.discount,
                  p.rating,
                  dotPainter: FlDotCirclePainter(
                    radius: 5,
                    color: p.rating >= 4.5 && p.discount >= 10
                        ? palette[2]
                        : palette[4].withValues(alpha: 0.6),
                  ),
                ),
            ],
          ),
        );
      },
    ),

    // 47. Línea con gradiente y área bajo la curva: Valor acumulado
    ChartItem(
      number: 47,
      title: 'Línea con área y gradiente: Valor acumulado de catálogo',
      advanced: true,
      observation: 'Curva acumulativa de capital a medida que se suman productos al inventario.',
      builder: (context) {
        final sample = products.take(20).toList();
        double sum = 0;
        final spots = <FlSpot>[];
        for (var i = 0; i < sample.length; i++) {
          sum += sample[i].inventoryValue;
          spots.add(FlSpot(i.toDouble(), sum));
        }
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(
              bottom: (v) => '${v.toInt() + 1}',
              left: (v) => '\$${(v / 1000).toStringAsFixed(0)}k',
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                gradient: LinearGradient(colors: [palette[0], palette[6]]),
                barWidth: 3.5,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      palette[0].withValues(alpha: 0.4),
                      palette[6].withValues(alpha: 0.05),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),

    // 48. Barras apiladas: Rating alto (>=4.5) vs Regular (<4.5)
    ChartItem(
      number: 48,
      title: 'Barras apiladas: Composición de calidad en Top 6',
      advanced: true,
      observation: 'Muestra la proporción interna de productos excelentes vs regulares en cada categoría.',
      builder: (context) => Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: flTitles(bottom: (v) => top6[v.toInt()].shortName, rotate: true),
                barGroups: [
                  for (var i = 0; i < top6.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: (top6[i].highRated + top6[i].lowRated).toDouble(),
                          rodStackItems: [
                            BarChartRodStackItem(0, top6[i].highRated.toDouble(), palette[2]),
                            BarChartRodStackItem(
                              top6[i].highRated.toDouble(),
                              (top6[i].highRated + top6[i].lowRated).toDouble(),
                              palette[3],
                            ),
                          ],
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          flLegend(['Rating ≥ 4.5 ★', 'Rating < 4.5 ★'], [palette[2], palette[3]]),
        ],
      ),
    ),

    // 49. Dispersión: Stock vs Precio de 30 productos
    ChartItem(
      number: 49,
      title: 'Dispersión: Unidades en stock vs Precio individual',
      advanced: true,
      observation: 'Detecta si los productos más costosos tienen menor stock en bodega como política de stock.',
      builder: (context) {
        final ps = products.take(30).toList();
        return ScatterChart(
          ScatterChartData(
            borderData: FlBorderData(show: true),
            titlesData: flTitles(
              bottom: (v) => '${v.toInt()}u',
              left: (v) => '\$${v.toInt()}',
            ),
            scatterSpots: [
              for (final p in ps)
                ScatterSpot(
                  p.stock.toDouble(),
                  p.price,
                  dotPainter: FlDotCirclePainter(
                    radius: 4.5,
                    color: palette[5].withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
        );
      },
    ),

    // 50. Radar: Desempeño comercial en Top 3 categorías
    ChartItem(
      number: 50,
      title: 'Radar: Balance comercial en las 3 categorías principales',
      advanced: true,
      height: 320,
      observation: 'Evalúa la armonía entre precio de venta, satisfacción del cliente y volumen de inventario.',
      builder: (context) => makeRadar(
        data.top(3),
        {
          'Valor Inv': (c) => c.totalValue,
          'Rating': (c) => c.avgRating,
          'Descuento': (c) => c.avgDiscount,
          'Stock': (c) => c.totalStock.toDouble(),
        },
      ),
    ),

    // 51. Barras con valor de referencia (BackDrawRod): Stock vs meta de 100
    ChartItem(
      number: 51,
      title: 'Barras con fondo de meta: Stock actual vs Meta (100u)',
      advanced: true,
      observation: 'La barra gris de fondo indica el nivel óptimo de 100 unidades por categoría.',
      builder: (context) => BarChart(
        BarChartData(
          maxY: 120,
          borderData: FlBorderData(show: false),
          titlesData: flTitles(bottom: (v) => top6[v.toInt()].shortName, rotate: true),
          barGroups: [
            for (var i = 0; i < top6.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: (top6[i].totalStock % 100).toDouble() + 20,
                    color: palette[0],
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 100,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    ),

    // 52. Multilínea: Ratings y Descuentos normalizados (0-100)
    ChartItem(
      number: 52,
      title: 'Multilínea normalizada: Ratings y Descuentos (Escala 0-100)',
      advanced: true,
      observation: 'Permite superponer dos métricas de unidades distintas en una misma gráfica comparativa.',
      builder: (context) {
        final sample = products.take(15).toList();
        return Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 100,
                  borderData: FlBorderData(show: false),
                  titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < sample.length; i++)
                          FlSpot(i.toDouble(), (sample[i].rating / 5.0) * 100),
                      ],
                      isCurved: true,
                      color: palette[2],
                      barWidth: 3,
                    ),
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < sample.length; i++)
                          FlSpot(i.toDouble(), (sample[i].discount / 25.0) * 100),
                      ],
                      isCurved: true,
                      color: palette[1],
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
            flLegend(['Rating normalizado', 'Descuento normalizado'], [palette[2], palette[1]]),
          ],
        );
      },
    ),

    // 53. Dispersión: Descuento vs Precio en productos accesibles (< $100)
    ChartItem(
      number: 53,
      title: 'Dispersión: Descuento vs Precio en artículos accesibles',
      advanced: true,
      observation: 'Muestra la dispersión de rebajas en la gama de consumo masivo por debajo de 100 dólares.',
      builder: (context) {
        final under100 = products.where((p) => p.price < 100).toList();
        return ScatterChart(
          ScatterChartData(
            borderData: FlBorderData(show: true),
            titlesData: flTitles(
              bottom: (v) => '\$${v.toInt()}',
              left: (v) => '${v.toInt()}%',
            ),
            scatterSpots: [
              for (final p in under100)
                ScatterSpot(
                  p.price,
                  p.discount,
                  dotPainter: FlDotCirclePainter(
                    radius: 4,
                    color: palette[6].withValues(alpha: 0.65),
                  ),
                ),
            ],
          ),
        );
      },
    ),

    // 54. Radar: Comparación de 5 categorías en 3 dimensiones
    ChartItem(
      number: 54,
      title: 'Radar triangular: Stock, Rating y Descuento en Top 5',
      advanced: true,
      height: 320,
      observation: 'Gráfico radar compacto enfocado en las tres métricas operativas esenciales.',
      builder: (context) => makeRadar(
        top5,
        {
          'Stock': (c) => c.totalStock.toDouble(),
          'Rating': (c) => c.avgRating,
          'Descuento': (c) => c.avgDiscount,
        },
      ),
    ),

    // 55. Línea escalonada (Stepped Line): Umbrales de precio
    ChartItem(
      number: 55,
      title: 'Línea escalonada (Step Line): Progresión ordenada de precios',
      advanced: true,
      observation: 'La línea escalonada resalta saltos discretos entre categorías de precio en el catálogo.',
      builder: (context) {
        final sorted = data.topProductsByPrice(15).reversed.toList();
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < sorted.length; i++)
                    FlSpot(i.toDouble(), sorted[i].price),
                ],
                isCurved: false,
                isStepLineChart: true,
                color: palette[3],
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),

    // 56. Barras agrupadas: Precio mínimo vs Precio máximo por categoría
    ChartItem(
      number: 56,
      title: 'Barras agrupadas: Rango de precios (Mínimo vs Máximo)',
      advanced: true,
      observation: 'Ilustra la amplitud de la gama de precios existente dentro de cada categoría.',
      builder: (context) => Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: flTitles(bottom: (v) => top6[v.toInt()].shortName, rotate: true),
                barGroups: [
                  for (var i = 0; i < top6.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: top6[i].minPrice,
                          color: palette[2],
                          width: 10,
                        ),
                        BarChartRodData(
                          toY: top6[i].maxPrice,
                          color: palette[7],
                          width: 10,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          flLegend(['Precio Mínimo', 'Precio Máximo'], [palette[2], palette[7]]),
        ],
      ),
    ),

    // 57. Dispersión: Valor total de inventario vs Precio unitario
    ChartItem(
      number: 57,
      title: 'Dispersión: Valor en inventario (\$k) vs Precio unitario',
      advanced: true,
      observation: 'Productos en la esquina superior derecha concentran el mayor riesgo y valor financiero.',
      builder: (context) {
        final ps = products.take(35).toList();
        return ScatterChart(
          ScatterChartData(
            borderData: FlBorderData(show: true),
            titlesData: flTitles(
              bottom: (v) => '\$${v.toInt()}',
              left: (v) => '\$${(v / 1000).toStringAsFixed(1)}k',
            ),
            scatterSpots: [
              for (final p in ps)
                ScatterSpot(
                  p.price,
                  p.inventoryValue,
                  dotPainter: FlDotCirclePainter(
                    radius: 5,
                    color: palette[1].withValues(alpha: 0.65),
                  ),
                ),
            ],
          ),
        );
      },
    ),

    // 58. Radar: Métricas de eficiencia comercial
    ChartItem(
      number: 58,
      title: 'Radar: Eficiencia comercial en Top 4 categorías',
      advanced: true,
      height: 320,
      observation: 'Compara satisfacción promedio, atractivo de descuento y volumen unitario.',
      builder: (context) => makeRadar(
        data.top(4),
        {
          'Rating ★': (c) => c.avgRating,
          'Descuento %': (c) => c.avgDiscount,
          'Variedad': (c) => c.count.toDouble(),
          'Stock': (c) => c.totalStock.toDouble(),
        },
      ),
    ),

    // 59. Línea compuesta: Curva con sombra difusa y marcadores
    ChartItem(
      number: 59,
      title: 'Línea de alta precisión: Fluctuación de precios con marcadores',
      advanced: true,
      observation: 'Presenta línea con marcadores circulares y área difusa para un aspecto visual enriquecido.',
      builder: (context) {
        final sample = products.skip(20).take(15).toList();
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < sample.length; i++)
                    FlSpot(i.toDouble(), sample[i].price),
                ],
                isCurved: true,
                color: palette[4],
                barWidth: 3.5,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (s, p, b, i) => FlDotCirclePainter(
                    radius: 4,
                    color: Colors.white,
                    strokeColor: palette[4],
                    strokeWidth: 2,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: palette[4].withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        );
      },
    ),

    // 60. Barras apiladas: Desglose de stock bajo (<25) vs normal (>=25)
    ChartItem(
      number: 60,
      title: 'Barras apiladas: Distribución de riesgo de inventario',
      advanced: true,
      observation: 'Cada barra representa el total de productos divididos entre stock bajo y stock holgado.',
      builder: (context) => Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: flTitles(bottom: (v) => top6[v.toInt()].shortName, rotate: true),
                barGroups: [
                  for (var i = 0; i < top6.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: top6[i].count.toDouble(),
                          rodStackItems: [
                            BarChartRodStackItem(0, top6[i].lowStockCount.toDouble(), palette[3]),
                            BarChartRodStackItem(
                              top6[i].lowStockCount.toDouble(),
                              top6[i].count.toDouble(),
                              palette[0],
                            ),
                          ],
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          flLegend(['Stock Bajo (<25)', 'Stock Adecuado (≥25)'], [palette[3], palette[0]]),
        ],
      ),
    ),

    // 61. Dispersión: Rating vs Descuento con color por nivel de inventario
    ChartItem(
      number: 61,
      title: 'Dispersión: Satisfacción vs Descuento con semáforo de stock',
      advanced: true,
      observation: 'Verde: stock alto, naranja: stock regular, rojo: stock crítico.',
      builder: (context) {
        final ps = products.take(40).toList();
        return ScatterChart(
          ScatterChartData(
            minY: 2.0,
            maxY: 5.0,
            borderData: FlBorderData(show: true),
            titlesData: flTitles(
              bottom: (v) => '★${v.toStringAsFixed(1)}',
              left: (v) => '${v.toInt()}%',
            ),
            scatterSpots: [
              for (final p in ps)
                ScatterSpot(
                  p.rating,
                  p.discount,
                  dotPainter: FlDotCirclePainter(
                    radius: 5,
                    color: p.stock < 20
                        ? palette[3]
                        : (p.stock < 50 ? palette[1] : palette[2]),
                  ),
                ),
            ],
          ),
        );
      },
    ),

    // 62. Radar: Balance de calidad y valor entre las categorías más populares
    ChartItem(
      number: 62,
      title: 'Radar: Síntesis de valor en categorías de alta rotación',
      advanced: true,
      height: 320,
      observation: 'Inspecciona simultáneamente precio medio, descuento, notas de usuarios y volumen de artículos.',
      builder: (context) => makeRadar(
        data.top(5),
        {
          'Variedad': (c) => c.count.toDouble(),
          'Precio': (c) => c.avgPrice,
          'Rating': (c) => c.avgRating,
          'Descuento': (c) => c.avgDiscount,
        },
      ),
    ),

    // 63. Multilínea: Comparación de precios de lista vs ahorros netos
    ChartItem(
      number: 63,
      title: 'Multilínea: Comparación de Precio vs Monto de Ahorro',
      advanced: true,
      observation: 'Compara el valor de venta final contra la cantidad exacta de dinero descontada al comprador.',
      builder: (context) {
        final sample = products.skip(10).take(15).toList();
        return Column(
          children: [
            Expanded(
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < sample.length; i++)
                          FlSpot(i.toDouble(), sample[i].price),
                      ],
                      isCurved: true,
                      color: palette[0],
                      barWidth: 3,
                    ),
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < sample.length; i++)
                          FlSpot(i.toDouble(), sample[i].discountAmount),
                      ],
                      isCurved: true,
                      color: palette[1],
                      barWidth: 2.5,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            flLegend(['Precio de Venta', 'Ahorro (\$ USD)'], [palette[0], palette[1]]),
          ],
        );
      },
    ),

    // 64. Barras agrupadas: Descuento promedio vs Rating promedio escalado
    ChartItem(
      number: 64,
      title: 'Barras agrupadas: Descuento (%) vs Rating escalado (x10)',
      advanced: true,
      observation: 'Permite cotejar visualmente si categorías con mejores notas otorgan más o menos promociones.',
      builder: (context) => Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: flTitles(bottom: (v) => top6[v.toInt()].shortName, rotate: true),
                barGroups: [
                  for (var i = 0; i < top6.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: top6[i].avgDiscount,
                          color: palette[4],
                          width: 10,
                        ),
                        BarChartRodData(
                          toY: top6[i].avgRating * 5,
                          color: palette[2],
                          width: 10,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          flLegend(['Descuento prom (%)', 'Rating prom (x5)'], [palette[4], palette[2]]),
        ],
      ),
    ),

    // 65. Radar integral: Síntesis de catálogo completo
    ChartItem(
      number: 65,
      title: 'Radar integral: Diagnóstico holístico de categorías líderes',
      advanced: true,
      height: 320,
      observation: 'Integra los 5 pilares: Precio, Satisfacción, Unidades físicas, Rebajas y Variedad de catálogo.',
      builder: (context) => makeRadar(
        data.top(3),
        {
          'Precio': (c) => c.avgPrice,
          'Rating': (c) => c.avgRating,
          'Stock': (c) => c.totalStock.toDouble(),
          'Descuento': (c) => c.avgDiscount,
          'Variedad': (c) => c.count.toDouble(),
        },
      ),
    ),
  ];
}
