import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../theme/palette.dart';
import 'fl_chart_helpers.dart';

List<ChartItem> getFlChartBasicItems(ChartData data) {
  final products = data.products;
  final top6 = data.top(6);
  final top5 = data.top(5);
  final top8 = data.top(8);
  final pBrackets = data.priceBrackets;
  final rBrackets = data.ratingBrackets;
  final sBrackets = data.stockBrackets;
  final dBrackets = data.discountBrackets;

  return [
    // 1. Línea: Precio de 15 productos
    ChartItem(
      number: 1,
      title: 'Línea: Precio de primeros 15 productos',
      advanced: false,
      observation: 'Muestra la dispersión y picos en los precios individuales del catálogo.',
      builder: (context) {
        final sample = products.take(15).toList();
        return LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
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
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),

    // 2. Barras: Stock total por categoría (top 6)
    ChartItem(
      number: 2,
      title: 'Barras: Stock total por categoría (Top 6)',
      advanced: false,
      observation: 'Compara el volumen físico disponible en almacén para las 6 categorías principales.',
      builder: (context) => BarChart(
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

    // 3. Pastel: Proporción de productos en Top 5 categorías
    ChartItem(
      number: 3,
      title: 'Pastel: Proporción de productos por categoría (Top 5)',
      advanced: false,
      observation: 'Muestra la distribución relativa del número de artículos entre las 5 categorías más pobladas.',
      builder: (context) => Row(
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
                      color: palette[i % palette.length],
                      radius: 80,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
          flLegend(top5.map((c) => c.name).toList()),
        ],
      ),
    ),

    // 4. Barras: Precio promedio por categoría (Top 6)
    ChartItem(
      number: 4,
      title: 'Barras: Precio promedio en Top 6 categorías',
      advanced: false,
      observation: 'Identifica cuáles categorías concentran artículos de mayor valor comercial unitario.',
      builder: (context) => BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: flTitles(bottom: (v) => top6[v.toInt()].shortName, rotate: true),
          barGroups: [
            for (var i = 0; i < top6.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: top6[i].avgPrice,
                    color: palette[2],
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
        ),
      ),
    ),

    // 5. Línea: Rating de 20 productos
    ChartItem(
      number: 5,
      title: 'Línea: Rating de primeros 20 productos',
      advanced: false,
      observation: 'Monitorea las calificaciones de satisfacción de clientes sobre una muestra de 20 artículos.',
      builder: (context) {
        final sample = products.take(20).toList();
        return LineChart(
          LineChartData(
            minY: 1,
            maxY: 5,
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < sample.length; i++)
                    FlSpot(i.toDouble(), sample[i].rating),
                ],
                isCurved: true,
                color: palette[3],
                barWidth: 2.5,
              ),
            ],
          ),
        );
      },
    ),

    // 6. Dona: Distribución de stock en Top 5 categorías
    ChartItem(
      number: 6,
      title: 'Dona: Distribución de unidades de inventario en Top 5',
      advanced: false,
      observation: 'El anillo resalta la cuota de inventario que acapara cada categoría destacada.',
      builder: (context) => Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                sections: [
                  for (var i = 0; i < top5.length; i++)
                    PieChartSectionData(
                      value: top5[i].totalStock.toDouble(),
                      title: '${top5[i].totalStock}',
                      color: palette[i % palette.length],
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
          flLegend(top5.map((c) => c.shortName).toList()),
        ],
      ),
    ),

    // 7. Barras: Descuento promedio por categoría (Top 6)
    ChartItem(
      number: 7,
      title: 'Barras: Descuento promedio (%) en Top 6 categorías',
      advanced: false,
      observation: 'Permite verificar qué familias de productos ofrecen mayores rebajas promocionales.',
      builder: (context) => BarChart(
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
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
        ),
      ),
    ),

    // 8. Línea: Porcentaje de descuento de primeros 15 productos
    ChartItem(
      number: 8,
      title: 'Línea: Variación de descuento en 15 productos',
      advanced: false,
      observation: 'Visualiza la volatilidad de las ofertas entre productos consecutivos.',
      builder: (context) {
        final sample = products.take(15).toList();
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < sample.length; i++)
                    FlSpot(i.toDouble(), sample[i].discount),
                ],
                isCurved: false,
                color: palette[1],
                barWidth: 2,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),

    // 9. Barras: Cantidad de productos en todas las categorías
    ChartItem(
      number: 9,
      title: 'Barras: Variedad de productos por categoría',
      advanced: false,
      observation: 'Describe el volumen de catálogo disponible por cada departamento registrado.',
      builder: (context) {
        final cats = data.categories.take(10).toList();
        return BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => cats[v.toInt()].shortName, rotate: true),
            barGroups: [
              for (var i = 0; i < cats.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: cats[i].count.toDouble(),
                      color: palette[i % palette.length],
                      width: 14,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ),

    // 10. Pastel: Distribución de productos por rango de precio
    ChartItem(
      number: 10,
      title: 'Pastel: Segmentación del catálogo por rango de precio',
      advanced: false,
      observation: 'Divide el catálogo en rangos de precio para entender la estrategia de precios de la tienda.',
      builder: (context) => Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                sections: [
                  for (var i = 0; i < pBrackets.length; i++)
                    PieChartSectionData(
                      value: pBrackets[i].count.toDouble(),
                      title: '${pBrackets[i].count}',
                      color: palette[i % palette.length],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
          flLegend(pBrackets.map((b) => b.label).toList()),
        ],
      ),
    ),

    // 11. Barras: Stock de los 10 productos con mayor inventario
    ChartItem(
      number: 11,
      title: 'Barras: Top 10 productos con mayor stock',
      advanced: false,
      observation: 'Identifica los artículos con mayor disponibilidad física inmediata en almacén.',
      builder: (context) {
        final topP = data.topProductsByStock(10);
        return BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => 'P${v.toInt() + 1}'),
            barGroups: [
              for (var i = 0; i < topP.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: topP[i].stock.toDouble(),
                      color: palette[6],
                      width: 15,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ),

    // 12. Línea: Precios de los 10 productos más costosos
    ChartItem(
      number: 12,
      title: 'Línea: Precios de los 10 productos más caros',
      advanced: false,
      observation: 'Curva descendente del segmento premium del catálogo.',
      builder: (context) {
        final topPrice = data.topProductsByPrice(10);
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => 'Top ${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < topPrice.length; i++)
                    FlSpot(i.toDouble(), topPrice[i].price),
                ],
                isCurved: true,
                color: palette[7],
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),

    // 13. Barras: Precios de los 10 productos más económicos
    ChartItem(
      number: 13,
      title: 'Barras: Precios de los 10 productos más baratos',
      advanced: false,
      observation: 'Permite examinar los artículos de entrada y bajo costo disponibles.',
      builder: (context) {
        final cheap = data.cheapestProducts(10);
        return BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => 'B${v.toInt() + 1}'),
            barGroups: [
              for (var i = 0; i < cheap.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: cheap[i].price,
                      color: palette[0],
                      width: 16,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ),

    // 14. Pastel: Distribución de productos por rango de rating
    ChartItem(
      number: 14,
      title: 'Pastel: Segmentación de productos por nivel de rating',
      advanced: false,
      observation: 'Refleja la proporción de artículos calificados con excelente, regular o baja nota.',
      builder: (context) => Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                sections: [
                  for (var i = 0; i < rBrackets.length; i++)
                    PieChartSectionData(
                      value: rBrackets[i].count.toDouble(),
                      title: '${rBrackets[i].count}',
                      color: palette[i % palette.length],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
          flLegend(rBrackets.map((b) => b.label).toList()),
        ],
      ),
    ),

    // 15. Barras: Stock acumulado por rango de precio
    ChartItem(
      number: 15,
      title: 'Barras: Unidades en almacén por rango de precio',
      advanced: false,
      observation: 'Indica en qué niveles de precio está concentrado el mayor volumen de unidades.',
      builder: (context) => BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: flTitles(bottom: (v) => pBrackets[v.toInt()].label, rotate: true),
          barGroups: [
            for (var i = 0; i < pBrackets.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: pBrackets[i].totalStock.toDouble(),
                    color: palette[5],
                    width: 22,
                  ),
                ],
              ),
          ],
        ),
      ),
    ),

    // 16. Línea: Precios en la primera categoría
    ChartItem(
      number: 16,
      title: 'Línea: Precios de productos de la categoría líder',
      advanced: false,
      observation: 'Fluctuación interna de precios dentro de la categoría con más productos.',
      builder: (context) {
        final catName = top5.first.name;
        final list = products.where((p) => p.category == catName).toList();
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < list.length; i++)
                    FlSpot(i.toDouble(), list[i].price),
                ],
                isCurved: true,
                color: palette[3],
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),

    // 17. Pastel: Distribución de productos por nivel de stock
    ChartItem(
      number: 17,
      title: 'Pastel: Salud del inventario (Crítico, Bajo, Medio, Alto)',
      advanced: false,
      observation: 'Detecta rápidamente el porcentaje de artículos que requieren reabastecimiento urgente.',
      builder: (context) => Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                sections: [
                  for (var i = 0; i < sBrackets.length; i++)
                    PieChartSectionData(
                      value: sBrackets[i].count.toDouble(),
                      title: '${sBrackets[i].count}',
                      color: palette[i % palette.length],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
          flLegend(sBrackets.map((b) => b.label).toList()),
        ],
      ),
    ),

    // 18. Barras: Rating promedio en Top 8 categorías
    ChartItem(
      number: 18,
      title: 'Barras: Rating promedio en Top 8 categorías',
      advanced: false,
      observation: 'Evaluación comparativa del nivel de satisfacción en las 8 categorías más grandes.',
      builder: (context) => BarChart(
        BarChartData(
          minY: 0,
          maxY: 5,
          borderData: FlBorderData(show: false),
          titlesData: flTitles(bottom: (v) => top8[v.toInt()].shortName, rotate: true),
          barGroups: [
            for (var i = 0; i < top8.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: top8[i].avgRating,
                    color: palette[1],
                    width: 16,
                  ),
                ],
              ),
          ],
        ),
      ),
    ),

    // 19. Línea: Precios con área sombreada (12 productos)
    ChartItem(
      number: 19,
      title: 'Línea con área: Rango de precios en 12 productos',
      advanced: false,
      observation: 'El área sombreada enfatiza el volumen económico total representado por esta muestra.',
      builder: (context) {
        final sample = products.take(12).toList();
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
                color: palette[2],
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: true,
                  color: palette[2].withValues(alpha: 0.25),
                ),
              ),
            ],
          ),
        );
      },
    ),

    // 20. Dona: Proporción de descuento alto vs moderado
    ChartItem(
      number: 20,
      title: 'Dona: Distribución de artículos por nivel de descuento',
      advanced: false,
      observation: 'Permite identificar qué porcentaje de artículos tienen descuentos agresivos superiores al 15%.',
      builder: (context) => Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 38,
                sections: [
                  for (var i = 0; i < dBrackets.length; i++)
                    PieChartSectionData(
                      value: dBrackets[i].count.toDouble(),
                      title: '${dBrackets[i].count}',
                      color: palette[i % palette.length],
                      radius: 52,
                      titleStyle: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
          flLegend(dBrackets.map((b) => b.label).toList()),
        ],
      ),
    ),

    // 21. Barras: Valor monetario total de inventario en Top 6
    ChartItem(
      number: 21,
      title: 'Barras: Valor total de inventario (\$ USD) en Top 6',
      advanced: false,
      observation: 'Calcula el capital inmovilizado (precio × unidades) por cada departamento principal.',
      builder: (context) => BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: flTitles(bottom: (v) => top6[v.toInt()].shortName, rotate: true),
          barGroups: [
            for (var i = 0; i < top6.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: top6[i].totalValue,
                    color: palette[4],
                    width: 18,
                  ),
                ],
              ),
          ],
        ),
      ),
    ),

    // 22. Línea: Descuentos de los 15 productos con mejor rating
    ChartItem(
      number: 22,
      title: 'Línea: Descuentos en productos con mejor calificación',
      advanced: false,
      observation: 'Analiza si los productos mejor valorados por clientes reciben también descuentos altos.',
      builder: (context) {
        final topRated = data.topProductsByRating(15);
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < topRated.length; i++)
                    FlSpot(i.toDouble(), topRated[i].discount),
                ],
                isCurved: true,
                color: palette[5],
                barWidth: 2.5,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),

    // 23. Pastel: Proporción de categorías con rating >= 4.0
    ChartItem(
      number: 23,
      title: 'Pastel: Categorías de alta calificación (Rating ≥ 4.0)',
      advanced: false,
      observation: 'Compara cuántas categorías superan el umbral de satisfacción de 4.0 estrellas.',
      builder: (context) {
        final highCats = data.categories.where((c) => c.avgRating >= 4.0).length;
        final lowCats = data.categories.length - highCats;
        return Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: highCats.toDouble(),
                      title: '$highCats',
                      color: palette[2],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: lowCats.toDouble(),
                      title: '$lowCats',
                      color: palette[3],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            flLegend(['≥ 4.0 ★', '< 4.0 ★'], [palette[2], palette[3]]),
          ],
        );
      },
    ),

    // 24. Barras: Stock en categorías ordenadas por precio
    ChartItem(
      number: 24,
      title: 'Barras: Stock en las categorías más costosas',
      advanced: false,
      observation: 'Muestra la disponibilidad de inventario en las categorías con precio promedio más elevado.',
      builder: (context) {
        final topPriceCats = data.topByPrice(6);
        return BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => topPriceCats[v.toInt()].shortName, rotate: true),
            barGroups: [
              for (var i = 0; i < topPriceCats.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: topPriceCats[i].totalStock.toDouble(),
                      color: palette[i % palette.length],
                      width: 18,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ),

    // 25. Línea: Variación de precio en productos con poco stock
    ChartItem(
      number: 25,
      title: 'Línea: Precios de productos con inventario crítico (<25)',
      advanced: false,
      observation: 'Examina si la escasez de inventario se asocia a precios particulares.',
      builder: (context) {
        final lowStock = products.where((p) => p.stock < 25).take(15).toList();
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < lowStock.length; i++)
                    FlSpot(i.toDouble(), lowStock[i].price),
                ],
                isCurved: false,
                color: palette[6],
                barWidth: 2.5,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),

    // 26. Pastel: Cuota de inventario según rango de descuento
    ChartItem(
      number: 26,
      title: 'Pastel: Stock total según nivel de descuento',
      advanced: false,
      observation: 'Mide cuántas unidades físicas en stock tienen ofertas menores al 5% vs mayores al 15%.',
      builder: (context) => Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                sections: [
                  for (var i = 0; i < dBrackets.length; i++)
                    PieChartSectionData(
                      value: dBrackets[i].totalStock.toDouble(),
                      title: '${dBrackets[i].totalStock}',
                      color: palette[i % palette.length],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
          flLegend(dBrackets.map((b) => b.label).toList()),
        ],
      ),
    ),

    // 27. Barras: Top 8 productos con mayor porcentaje de descuento
    ChartItem(
      number: 27,
      title: 'Barras: Top 8 productos con mayor % de descuento',
      advanced: false,
      observation: 'Ranking de los descuentos más agresivos aplicados en la tienda.',
      builder: (context) {
        final topDisc = data.topProductsByDiscount(8);
        return BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => 'D${v.toInt() + 1}'),
            barGroups: [
              for (var i = 0; i < topDisc.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: topDisc[i].discount,
                      color: palette[3],
                      width: 18,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ),

    // 28. Línea: Evolución de rating a lo largo de 25 productos
    ChartItem(
      number: 28,
      title: 'Línea: Fluctuación de rating en 25 productos continuos',
      advanced: false,
      observation: 'Permite visualizar la estabilidad de la calidad percibida en el catálogo.',
      builder: (context) {
        final sample = products.take(25).toList();
        return LineChart(
          LineChartData(
            minY: 1,
            maxY: 5,
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < sample.length; i++)
                    FlSpot(i.toDouble(), sample[i].rating),
                ],
                isCurved: true,
                color: palette[0],
                barWidth: 2,
              ),
            ],
          ),
        );
      },
    ),

    // 29. Pastel: Stock en las 4 categorías con más stock
    ChartItem(
      number: 29,
      title: 'Pastel: Stock en las 4 categorías líderes en inventario',
      advanced: false,
      observation: 'Compara la cuota de inventario entre los 4 gigantes del almacén.',
      builder: (context) {
        final top4Stock = data.topByStock(4);
        return Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    for (var i = 0; i < top4Stock.length; i++)
                      PieChartSectionData(
                        value: top4Stock[i].totalStock.toDouble(),
                        title: '${top4Stock[i].totalStock}',
                        color: palette[i],
                        radius: 75,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
            flLegend(top4Stock.map((c) => c.shortName).toList()),
          ],
        );
      },
    ),

    // 30. Barras: Inventario de los 7 productos más económicos
    ChartItem(
      number: 30,
      title: 'Barras: Unidades disponibles de 7 productos más baratos',
      advanced: false,
      observation: 'Verifica si los productos accesibles cuentan con inventario suficiente para alta demanda.',
      builder: (context) {
        final cheap = data.cheapestProducts(7);
        return BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => 'B${v.toInt() + 1}'),
            barGroups: [
              for (var i = 0; i < cheap.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: cheap[i].stock.toDouble(),
                      color: palette[1],
                      width: 20,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ),

    // 31. Línea: Precios de 15 productos con rating superior a 4.0
    ChartItem(
      number: 31,
      title: 'Línea: Precios de productos con rating superior a 4.0',
      advanced: false,
      observation: 'Rango de precios de los productos que reciben excelente valoración por parte de clientes.',
      builder: (context) {
        final high = products.where((p) => p.rating >= 4.0).take(15).toList();
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < high.length; i++)
                    FlSpot(i.toDouble(), high[i].price),
                ],
                isCurved: true,
                color: palette[4],
                barWidth: 3,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),

    // 32. Pastel: Proporción de stock crítico (<20 unidades)
    ChartItem(
      number: 32,
      title: 'Pastel: Artículos en stock crítico (<20 unidades) vs Resto',
      advanced: false,
      observation: 'Alerta visual inmediata sobre la proporción de productos en riesgo de agotarse.',
      builder: (context) {
        final crit = products.where((p) => p.stock < 20).length;
        final rest = products.length - crit;
        return Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: crit.toDouble(),
                      title: '$crit',
                      color: palette[3],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: rest.toDouble(),
                      title: '$rest',
                      color: palette[0],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            flLegend(['Crítico (<20)', 'Normal (≥20)'], [palette[3], palette[0]]),
          ],
        );
      },
    ),

    // 33. Barras: Cantidad de productos por rango de descuento
    ChartItem(
      number: 33,
      title: 'Barras: Cantidad de productos según porcentaje de descuento',
      advanced: false,
      observation: 'Histograma por bandas de porcentaje de descuento.',
      builder: (context) => BarChart(
        BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: flTitles(bottom: (v) => dBrackets[v.toInt()].label, rotate: true),
          barGroups: [
            for (var i = 0; i < dBrackets.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: dBrackets[i].count.toDouble(),
                    color: palette[i % palette.length],
                    width: 22,
                  ),
                ],
              ),
          ],
        ),
      ),
    ),

    // 34. Línea: Nivel de stock de 15 productos más baratos
    ChartItem(
      number: 34,
      title: 'Línea: Unidades de stock en los 15 productos más baratos',
      advanced: false,
      observation: 'Verifica la suficiencia de stock en la gama económica del catálogo.',
      builder: (context) {
        final cheap = data.cheapestProducts(15);
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < cheap.length; i++)
                    FlSpot(i.toDouble(), cheap[i].stock.toDouble()),
                ],
                isCurved: false,
                color: palette[2],
                barWidth: 2.5,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),

    // 35. Pastel: Participación de las 3 categorías con mayor valor
    ChartItem(
      number: 35,
      title: 'Pastel: Participación de valor en las 3 categorías líderes',
      advanced: false,
      observation: 'Determina qué categorías representan el grueso de la inversión en inventario.',
      builder: (context) {
        final topVal = data.topByValue(3);
        return Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    for (var i = 0; i < topVal.length; i++)
                      PieChartSectionData(
                        value: topVal[i].totalValue,
                        title: '\$${(topVal[i].totalValue / 1000).toStringAsFixed(1)}k',
                        color: palette[i * 2],
                        radius: 80,
                        titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ),
            ),
            flLegend(topVal.map((c) => c.shortName).toList()),
          ],
        );
      },
    ),

    // 36. Barras: Descuento promedio en categorías con rating >= 4.0
    ChartItem(
      number: 36,
      title: 'Barras: Descuento promedio en categorías bien calificadas',
      advanced: false,
      observation: 'Compara si las categorías con alta reputación conservan o sacrifican su margen promocional.',
      builder: (context) {
        final cats = data.categories.where((c) => c.avgRating >= 4.0).take(6).toList();
        return BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => cats[v.toInt()].shortName, rotate: true),
            barGroups: [
              for (var i = 0; i < cats.length; i++)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: cats[i].avgDiscount,
                      color: palette[5],
                      width: 18,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    ),

    // 37. Línea: Precios suavizados de 18 productos
    ChartItem(
      number: 37,
      title: 'Línea suavizada: Tendencia continua de precios',
      advanced: false,
      observation: 'Curva suavizada sin aristas para apreciar tendencias generales de precio.',
      builder: (context) {
        final sample = products.skip(10).take(18).toList();
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
                curveSmoothness: 0.35,
                color: palette[6],
                barWidth: 3,
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        );
      },
    ),

    // 38. Pastel: Productos con rating >= 4.5 vs Menores
    ChartItem(
      number: 38,
      title: 'Pastel: Excelencia de catálogo (Rating ≥ 4.5 vs Otros)',
      advanced: false,
      observation: 'Porcentaje de productos calificados con excelencia de 4.5 o más estrellas.',
      builder: (context) {
        final exc = products.where((p) => p.rating >= 4.5).length;
        final oth = products.length - exc;
        return Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: exc.toDouble(),
                      title: '$exc',
                      color: palette[2],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: oth.toDouble(),
                      title: '$oth',
                      color: palette[4],
                      radius: 75,
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            flLegend(['Excelente (≥ 4.5)', 'Otros (< 4.5)'], [palette[2], palette[4]]),
          ],
        );
      },
    ),

    // 39. Barras: Rating promedio por rango de precio
    ChartItem(
      number: 39,
      title: 'Barras: Rating promedio según rango de precio',
      advanced: false,
      observation: 'Revela si los clientes son más exigentes o valoran más los artículos costosos o baratos.',
      builder: (context) => BarChart(
        BarChartData(
          minY: 0,
          maxY: 5,
          borderData: FlBorderData(show: false),
          titlesData: flTitles(bottom: (v) => pBrackets[v.toInt()].label, rotate: true),
          barGroups: [
            for (var i = 0; i < pBrackets.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: pBrackets[i].avgRating,
                    color: palette[0],
                    width: 22,
                  ),
                ],
              ),
          ],
        ),
      ),
    ),

    // 40. Línea: Margen de descuento en 20 productos
    ChartItem(
      number: 40,
      title: 'Línea: Porcentaje de descuento continuo en 20 artículos',
      advanced: false,
      observation: 'Visualiza la constancia y variaciones de las ofertas aplicadas a 20 artículos.',
      builder: (context) {
        final sample = products.skip(15).take(20).toList();
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: flTitles(bottom: (v) => '${v.toInt() + 1}'),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var i = 0; i < sample.length; i++)
                    FlSpot(i.toDouble(), sample[i].discount),
                ],
                isCurved: true,
                color: palette[7],
                barWidth: 2.5,
                dotData: const FlDotData(show: true),
              ),
            ],
          ),
        );
      },
    ),
  ];
}
