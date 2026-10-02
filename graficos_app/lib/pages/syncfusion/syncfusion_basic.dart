import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/models.dart';
import '../../theme/palette.dart';

List<ChartItem> getSyncfusionBasicItems(ChartData data) {
  final products = data.products;
  final top6 = data.top(6);
  final top5 = data.top(5);
  final top8 = data.top(8);
  final pBrackets = data.priceBrackets;
  final sBrackets = data.stockBrackets;
  final dBrackets = data.discountBrackets;

  return [
    // 66. Columnas: Precio promedio por categoría (Top 6)
    ChartItem(
      number: 66,
      title: 'Columnas: Precio promedio en Top 6 categorías',
      advanced: false,
      observation: 'Las etiquetas muestran el valor exacto promediado de cada categoría.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => double.parse(c.avgPrice.toStringAsFixed(1)),
            pointColorMapper: (c, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ],
      ),
    ),

    // 67. Área: % de descuento en 20 productos
    ChartItem(
      number: 67,
      title: 'Área: Porcentaje de descuento en 20 productos',
      advanced: false,
      observation: 'El área sombreada resalta el volumen y fluctuación de descuentos.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(interval: 2),
        series: <CartesianSeries<Product, int>>[
          AreaSeries<Product, int>(
            dataSource: products.take(20).toList(),
            xValueMapper: (p, i) => i + 1,
            yValueMapper: (p, _) => p.discount,
            color: palette[1].withValues(alpha: 0.5),
            borderColor: palette[1],
            borderWidth: 2,
          ),
        ],
      ),
    ),

    // 68. Dona: Distribución de stock en Top 5 categorías
    ChartItem(
      number: 68,
      title: 'Dona: Distribución de stock en Top 5 categorías',
      advanced: false,
      observation: 'El anillo interactivo permite ver la cuota de inventario con leyenda interactiva.',
      builder: (context) => SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.right),
        series: <CircularSeries<CategoryStat, String>>[
          DoughnutSeries<CategoryStat, String>(
            dataSource: top5,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalStock,
            pointColorMapper: (c, i) => palette[i % palette.length],
            innerRadius: '55%',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 69. Línea: Rating de primeros 20 productos
    ChartItem(
      number: 69,
      title: 'Línea: Rating de primeros 20 productos',
      advanced: false,
      observation: 'Permite observar la tendencia de calificaciones de satisfacción.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(interval: 2),
        primaryYAxis: const NumericAxis(minimum: 1, maximum: 5),
        series: <CartesianSeries<Product, int>>[
          LineSeries<Product, int>(
            dataSource: products.take(20).toList(),
            xValueMapper: (p, i) => i + 1,
            yValueMapper: (p, _) => p.rating,
            color: palette[3],
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 70. Barras horizontales: Stock en Top 6 categorías
    ChartItem(
      number: 70,
      title: 'Barras horizontales: Stock total en Top 6 categorías',
      advanced: false,
      observation: 'La disposición horizontal facilita la lectura de nombres largos de categoría.',
      builder: (context) => SfCartesianChart(
        primaryYAxis: const NumericAxis(),
        primaryXAxis: const CategoryAxis(),
        series: <CartesianSeries<CategoryStat, String>>[
          BarSeries<CategoryStat, String>(
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalStock,
            pointColorMapper: (c, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 71. Spline: Precios continuos de 15 productos
    ChartItem(
      number: 71,
      title: 'Spline: Curva suave de precios en 15 artículos',
      advanced: false,
      observation: 'Interpolación spline para una visualización estética del contorno de precios.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(interval: 2),
        series: <CartesianSeries<Product, int>>[
          SplineSeries<Product, int>(
            dataSource: products.take(15).toList(),
            xValueMapper: (p, i) => i + 1,
            yValueMapper: (p, _) => p.price,
            color: palette[0],
            width: 3,
          ),
        ],
      ),
    ),

    // 72. Pastel: Participación de categorías por cantidad de artículos
    ChartItem(
      number: 72,
      title: 'Pastel: Participación de productos en Top 5 categorías',
      advanced: false,
      observation: 'Cada sección representa la cantidad de referencias ofertadas.',
      builder: (context) => SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.right),
        series: <CircularSeries<CategoryStat, String>>[
          PieSeries<CategoryStat, String>(
            dataSource: top5,
            xValueMapper: (c, _) => c.name,
            yValueMapper: (c, _) => c.count,
            pointColorMapper: (c, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 73. StepLine: Umbrales de precios en catálogo
    ChartItem(
      number: 73,
      title: 'Línea escalonada (Step Line): Precios ordenados',
      advanced: false,
      observation: 'La línea escalonada resalta los saltos discretos entre niveles de precio.',
      builder: (context) {
        final sample = data.topProductsByPrice(15).reversed.toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(interval: 2),
          series: <CartesianSeries<Product, int>>[
            StepLineSeries<Product, int>(
              dataSource: sample,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.price,
              color: palette[4],
              width: 2.5,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        );
      },
    ),

    // 74. Columnas: Stock total por categoría (Top 8)
    ChartItem(
      number: 74,
      title: 'Columnas: Stock total en Top 8 categorías',
      advanced: false,
      observation: 'Compara el inventario en las 8 categorías principales de la tienda.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -35),
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            dataSource: top8,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalStock,
            color: palette[5],
          ),
        ],
      ),
    ),

    // 75. Barras: Comparación de precios de los 10 productos más caros
    ChartItem(
      number: 75,
      title: 'Barras horizontales: 10 productos más costosos',
      advanced: false,
      observation: 'Ranking directo de los productos con mayor precio de lista.',
      builder: (context) {
        final topP = data.topProductsByPrice(10).reversed.toList();
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries<Product, String>>[
            BarSeries<Product, String>(
              dataSource: topP,
              xValueMapper: (p, _) => p.shortTitle,
              yValueMapper: (p, _) => p.price,
              color: palette[7],
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    ),

    // 76. Área: Curva de precios de 18 productos
    ChartItem(
      number: 76,
      title: 'Área: Distribución de precios de 18 artículos',
      advanced: false,
      observation: 'Resalta el volumen financiero subyacente bajo la curva.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(interval: 2),
        series: <CartesianSeries<Product, int>>[
          AreaSeries<Product, int>(
            dataSource: products.take(18).toList(),
            xValueMapper: (p, i) => i + 1,
            yValueMapper: (p, _) => p.price,
            color: palette[2].withValues(alpha: 0.4),
            borderColor: palette[2],
            borderWidth: 2,
          ),
        ],
      ),
    ),

    // 77. Dona: Stock en las 4 categorías con más stock
    ChartItem(
      number: 77,
      title: 'Dona: Cuota de inventario en 4 categorías líderes',
      advanced: false,
      observation: 'Proporción de unidades en almacén concentradas en el Top 4.',
      builder: (context) => SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.right),
        series: <CircularSeries<CategoryStat, String>>[
          DoughnutSeries<CategoryStat, String>(
            dataSource: data.topByStock(4),
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalStock,
            pointColorMapper: (c, i) => palette[i % palette.length],
            innerRadius: '50%',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 78. Línea: Descuentos en productos con rating >= 4.0
    ChartItem(
      number: 78,
      title: 'Línea: Descuento en productos de alta satisfacción (≥4.0)',
      advanced: false,
      observation: 'Muestra las ofertas disponibles en artículos favoritos de los clientes.',
      builder: (context) {
        final high = products.where((p) => p.rating >= 4.0).take(15).toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(interval: 2),
          series: <CartesianSeries<Product, int>>[
            LineSeries<Product, int>(
              dataSource: high,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.discount,
              color: palette[6],
              width: 3,
            ),
          ],
        );
      },
    ),

    // 79. Columnas: Valor de inventario (\$ USD) en Top 6 categorías
    ChartItem(
      number: 79,
      title: 'Columnas: Capital total en almacén (\$ USD) en Top 6',
      advanced: false,
      observation: 'Inversión monetaria acumulada en inventario por departamento.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalValue,
            pointColorMapper: (c, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 80. SplineArea: Calificaciones continuas con área suave
    ChartItem(
      number: 80,
      title: 'Spline de Área: Curva de satisfacción en 20 productos',
      advanced: false,
      observation: 'Formato estilizado que resalta la constancia de calificaciones positivas.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(interval: 2),
        primaryYAxis: const NumericAxis(minimum: 1, maximum: 5),
        series: <CartesianSeries<Product, int>>[
          SplineAreaSeries<Product, int>(
            dataSource: products.take(20).toList(),
            xValueMapper: (p, i) => i + 1,
            yValueMapper: (p, _) => p.rating,
            color: palette[1].withValues(alpha: 0.35),
            borderColor: palette[1],
            borderWidth: 2,
          ),
        ],
      ),
    ),

    // 81. Barras: Rating promedio en 7 categorías principales
    ChartItem(
      number: 81,
      title: 'Barras horizontales: Rating promedio en 7 categorías',
      advanced: false,
      observation: 'Evaluación directa de la satisfacción en los principales departamentos.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: const NumericAxis(minimum: 0, maximum: 5),
        series: <CartesianSeries<CategoryStat, String>>[
          BarSeries<CategoryStat, String>(
            dataSource: data.top(7),
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => double.parse(c.avgRating.toStringAsFixed(2)),
            color: palette[2],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 82. Pie: Distribución de productos por rango de precio
    ChartItem(
      number: 82,
      title: 'Pastel: Distribución de artículos por banda de precio',
      advanced: false,
      observation: 'Proporción de productos divididos en rangos accesibles hasta premium.',
      builder: (context) => SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.right),
        series: <CircularSeries<RangeBracket, String>>[
          PieSeries<RangeBracket, String>(
            dataSource: pBrackets,
            xValueMapper: (b, _) => b.label,
            yValueMapper: (b, _) => b.count,
            pointColorMapper: (b, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 83. Columnas: Descuento promedio en Top 6 categorías
    ChartItem(
      number: 83,
      title: 'Columnas: Descuento promedio (%) en Top 6 categorías',
      advanced: false,
      observation: 'Determina qué categorías ofrecen las mejores oportunidades de ahorro.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => double.parse(c.avgDiscount.toStringAsFixed(1)),
            color: palette[3],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 84. StepArea: Descuentos escalonados
    ChartItem(
      number: 84,
      title: 'Área escalonada (Step Area): Progresión de descuentos',
      advanced: false,
      observation: 'Muestra saltos y acumulaciones en las ofertas del catálogo.',
      builder: (context) {
        final sample = data.topProductsByDiscount(15).reversed.toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(interval: 2),
          series: <CartesianSeries<Product, int>>[
            StepAreaSeries<Product, int>(
              dataSource: sample,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.discount,
              color: palette[5].withValues(alpha: 0.4),
              borderColor: palette[5],
              borderWidth: 2,
            ),
          ],
        );
      },
    ),

    // 85. Line: Precios ordenados de menor a mayor
    ChartItem(
      number: 85,
      title: 'Línea ascendente: Precios ordenados de menor a mayor',
      advanced: false,
      observation: 'Visualiza la pendiente de crecimiento de precios en 20 artículos.',
      builder: (context) {
        final sample = data.cheapestProducts(20);
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(interval: 2),
          series: <CartesianSeries<Product, int>>[
            LineSeries<Product, int>(
              dataSource: sample,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.price,
              color: palette[0],
              width: 3,
            ),
          ],
        );
      },
    ),

    // 86. Dona: Distribución por nivel de stock
    ChartItem(
      number: 86,
      title: 'Dona: Estado del inventario (Crítico, Bajo, Medio, Alto)',
      advanced: false,
      observation: 'Alerta sobre la concentración de productos en estado crítico de existencias.',
      builder: (context) => SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.right),
        series: <CircularSeries<RangeBracket, String>>[
          DoughnutSeries<RangeBracket, String>(
            dataSource: sBrackets,
            xValueMapper: (b, _) => b.label,
            yValueMapper: (b, _) => b.count,
            pointColorMapper: (b, i) => palette[i % palette.length],
            innerRadius: '50%',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 87. Columnas: Cantidad de productos en categorías de alta rotación
    ChartItem(
      number: 87,
      title: 'Columnas: Variedad de artículos en Top 8 categorías',
      advanced: false,
      observation: 'Recuento de productos diferentes en cada una de las 8 categorías líderes.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            dataSource: top8,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.count,
            color: palette[1],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 88. Barras: Stock de los 8 productos con mayor inventario
    ChartItem(
      number: 88,
      title: 'Barras horizontales: 8 productos con mayor stock',
      advanced: false,
      observation: 'Los artículos con mayor disponibilidad física inmediata en almacén.',
      builder: (context) {
        final sample = data.topProductsByStock(8).reversed.toList();
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries<Product, String>>[
            BarSeries<Product, String>(
              dataSource: sample,
              xValueMapper: (p, _) => p.shortTitle,
              yValueMapper: (p, _) => p.stock,
              color: palette[6],
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    ),

    // 89. Spline: Calificaciones continuas en 25 productos
    ChartItem(
      number: 89,
      title: 'Spline: Calificaciones continuas en 25 productos',
      advanced: false,
      observation: 'Curva que refleja la estabilidad de satisfacción en una muestra amplia.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(interval: 5),
        primaryYAxis: const NumericAxis(minimum: 1, maximum: 5),
        series: <CartesianSeries<Product, int>>[
          SplineSeries<Product, int>(
            dataSource: products.take(25).toList(),
            xValueMapper: (p, i) => i + 1,
            yValueMapper: (p, _) => p.rating,
            color: palette[4],
            width: 2.5,
          ),
        ],
      ),
    ),

    // 90. Área: Variación de ofertas en 15 artículos
    ChartItem(
      number: 90,
      title: 'Área: Variación de descuentos en 15 artículos',
      advanced: false,
      observation: 'Muestra la intensidad de las promociones aplicadas a productos consecutivos.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(interval: 2),
        series: <CartesianSeries<Product, int>>[
          AreaSeries<Product, int>(
            dataSource: products.skip(10).take(15).toList(),
            xValueMapper: (p, i) => i + 1,
            yValueMapper: (p, _) => p.discount,
            color: palette[3].withValues(alpha: 0.4),
            borderColor: palette[3],
            borderWidth: 2,
          ),
        ],
      ),
    ),

    // 91. Pastel: Proporción de artículos con rating >= 4.5
    ChartItem(
      number: 91,
      title: 'Pastel: Artículos excelentes (Rating ≥ 4.5) vs Resto',
      advanced: false,
      observation: 'Determina el porcentaje de productos del catálogo con máxima calificación.',
      builder: (context) {
        final high = products.where((p) => p.rating >= 4.5).length;
        final low = products.length - high;
        return SfCircularChart(
          legend: const Legend(isVisible: true, position: LegendPosition.right),
          series: <CircularSeries<Map<String, dynamic>, String>>[
            PieSeries<Map<String, dynamic>, String>(
              dataSource: [
                {'label': '≥ 4.5 ★', 'val': high, 'col': palette[2]},
                {'label': '< 4.5 ★', 'val': low, 'col': palette[0]},
              ],
              xValueMapper: (m, _) => m['label'] as String,
              yValueMapper: (m, _) => m['val'] as int,
              pointColorMapper: (m, _) => m['col'] as Color,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    ),

    // 92. Columnas: Precios mínimos por categoría (Top 6)
    ChartItem(
      number: 92,
      title: 'Columnas: Precio mínimo registrado en Top 6 categorías',
      advanced: false,
      observation: 'Indica el precio de entrada más económico de cada departamento.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.minPrice,
            color: palette[2],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 93. Barras: Precios de los 10 productos más baratos
    ChartItem(
      number: 93,
      title: 'Barras horizontales: 10 productos más accesibles',
      advanced: false,
      observation: 'Precios de los productos más económicos disponibles para los clientes.',
      builder: (context) {
        final cheap = data.cheapestProducts(10).reversed.toList();
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries<Product, String>>[
            BarSeries<Product, String>(
              dataSource: cheap,
              xValueMapper: (p, _) => p.shortTitle,
              yValueMapper: (p, _) => p.price,
              color: palette[0],
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    ),

    // 94. Línea: Niveles de stock en 20 productos consecutivos
    ChartItem(
      number: 94,
      title: 'Línea: Unidades en bodega en 20 artículos',
      advanced: false,
      observation: 'Permite detectar baches de inventario o desabastecimiento.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(interval: 2),
        series: <CartesianSeries<Product, int>>[
          LineSeries<Product, int>(
            dataSource: products.take(20).toList(),
            xValueMapper: (p, i) => i + 1,
            yValueMapper: (p, _) => p.stock,
            color: palette[5],
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 95. Dona: Composición de catálogo por rango de descuento
    ChartItem(
      number: 95,
      title: 'Dona: Distribución de ofertas por bandas de descuento',
      advanced: false,
      observation: 'Proporción de artículos en rangos desde leves (<5%) hasta altos (≥15%).',
      builder: (context) => SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.right),
        series: <CircularSeries<RangeBracket, String>>[
          DoughnutSeries<RangeBracket, String>(
            dataSource: dBrackets,
            xValueMapper: (b, _) => b.label,
            yValueMapper: (b, _) => b.count,
            pointColorMapper: (b, i) => palette[i % palette.length],
            innerRadius: '50%',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 96. Columnas: Precios máximos registrados en Top 6 categorías
    ChartItem(
      number: 96,
      title: 'Columnas: Precio máximo registrado en Top 6 categorías',
      advanced: false,
      observation: 'El artículo insignia más costoso presente en cada categoría.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.maxPrice,
            color: palette[7],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 97. SplineArea: Precios de lista de artículos de belleza
    ChartItem(
      number: 97,
      title: 'Spline de Área: Precios en la categoría con más productos',
      advanced: false,
      observation: 'Muestra la gama de precios dentro de la categoría líder del catálogo.',
      builder: (context) {
        final list = products.where((p) => p.category == top5.first.name).toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(interval: 1),
          series: <CartesianSeries<Product, int>>[
            SplineAreaSeries<Product, int>(
              dataSource: list,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.price,
              color: palette[0].withValues(alpha: 0.35),
              borderColor: palette[0],
              borderWidth: 2,
            ),
          ],
        );
      },
    ),

    // 98. Barras: Valor de inventario en categorías líderes
    ChartItem(
      number: 98,
      title: 'Barras horizontales: Capital de inventario en Top 6',
      advanced: false,
      observation: 'Facilita la lectura de los montos totales inmovilizados en inventario.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        series: <CartesianSeries<CategoryStat, String>>[
          BarSeries<CategoryStat, String>(
            dataSource: top6.reversed.toList(),
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalValue,
            color: palette[4],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 99. StepLine: Descuentos escalonados en productos premium
    ChartItem(
      number: 99,
      title: 'Step Line: Descuentos escalonados en productos caros',
      advanced: false,
      observation: 'Analiza la magnitud de las ofertas otorgadas a los artículos más costosos.',
      builder: (context) {
        final expensive = data.topProductsByPrice(15);
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(interval: 2),
          series: <CartesianSeries<Product, int>>[
            StepLineSeries<Product, int>(
              dataSource: expensive,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.discount,
              color: palette[1],
              width: 2.5,
              markerSettings: const MarkerSettings(isVisible: true),
            ),
          ],
        );
      },
    ),

    // 100. Pie: Cuota de inventario en Top 3 categorías
    ChartItem(
      number: 100,
      title: 'Pastel: Cuota de inventario en las 3 categorías principales',
      advanced: false,
      observation: 'Participación porcentual de stock en las 3 categorías con mayor volumen.',
      builder: (context) => SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.right),
        series: <CircularSeries<CategoryStat, String>>[
          PieSeries<CategoryStat, String>(
            dataSource: data.topByStock(3),
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalStock,
            pointColorMapper: (c, i) => palette[i * 2],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 101. Columnas: Artículos disponibles por bandas de precio
    ChartItem(
      number: 101,
      title: 'Columnas: Artículos por bandas de precio',
      advanced: false,
      observation: 'Histograma de recuento de artículos según su rango de valor unitario.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -20),
        series: <CartesianSeries<RangeBracket, String>>[
          ColumnSeries<RangeBracket, String>(
            dataSource: pBrackets,
            xValueMapper: (b, _) => b.label,
            yValueMapper: (b, _) => b.count,
            pointColorMapper: (b, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 102. Line: Rating en productos económicos (< $50)
    ChartItem(
      number: 102,
      title: 'Línea: Rating en productos económicos (< \$50)',
      advanced: false,
      observation: 'Verifica la satisfacción de los clientes en artículos de bajo presupuesto.',
      builder: (context) {
        final cheap = products.where((p) => p.price < 50).take(20).toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(interval: 2),
          primaryYAxis: const NumericAxis(minimum: 1, maximum: 5),
          series: <CartesianSeries<Product, int>>[
            LineSeries<Product, int>(
              dataSource: cheap,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.rating,
              color: palette[2],
              width: 3,
            ),
          ],
        );
      },
    ),

    // 103. Dona: Proporción de stock crítico (<20 unidades)
    ChartItem(
      number: 103,
      title: 'Dona: Artículos en stock crítico (<20u) vs Normal',
      advanced: false,
      observation: 'Indicador visual directo sobre urgencia de reposición de catálogo.',
      builder: (context) {
        final crit = products.where((p) => p.stock < 20).length;
        final norm = products.length - crit;
        return SfCircularChart(
          legend: const Legend(isVisible: true, position: LegendPosition.right),
          series: <CircularSeries<Map<String, dynamic>, String>>[
            DoughnutSeries<Map<String, dynamic>, String>(
              dataSource: [
                {'label': 'Crítico (<20)', 'val': crit, 'col': palette[3]},
                {'label': 'Normal (≥20)', 'val': norm, 'col': palette[0]},
              ],
              xValueMapper: (m, _) => m['label'] as String,
              yValueMapper: (m, _) => m['val'] as int,
              pointColorMapper: (m, _) => m['col'] as Color,
              innerRadius: '50%',
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    ),

    // 104. Barras: Descuento promedio en categorías bien calificadas
    ChartItem(
      number: 104,
      title: 'Barras horizontales: Descuento en categorías con Rating ≥ 4.0',
      advanced: false,
      observation: 'Compara promociones en las categorías de mayor prestigio entre compradores.',
      builder: (context) {
        final highCats = data.categories.where((c) => c.avgRating >= 4.0).take(6).toList();
        return SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          series: <CartesianSeries<CategoryStat, String>>[
            BarSeries<CategoryStat, String>(
              dataSource: highCats,
              xValueMapper: (c, _) => c.shortName,
              yValueMapper: (c, _) => double.parse(c.avgDiscount.toStringAsFixed(1)),
              color: palette[5],
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    ),

    // 105. Spline: Variación de precio con marcadores de punto
    ChartItem(
      number: 105,
      title: 'Spline con marcadores: Precios en 16 artículos',
      advanced: false,
      observation: 'Curva suavizada combinada con marcadores geométricos en cada observación.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(interval: 2),
        series: <CartesianSeries<Product, int>>[
          SplineSeries<Product, int>(
            dataSource: products.take(16).toList(),
            xValueMapper: (p, i) => i + 1,
            yValueMapper: (p, _) => p.price,
            color: palette[6],
            width: 3,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              color: Colors.white,
              borderWidth: 2,
            ),
          ),
        ],
      ),
    ),
  ];
}
