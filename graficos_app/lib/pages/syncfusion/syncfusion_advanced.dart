import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/models.dart';
import '../../theme/palette.dart';

List<ChartItem> getSyncfusionAdvancedItems(ChartData data) {
  final products = data.products;
  final top6 = data.top(6);
  final top5 = data.top(5);

  return [
    // 106. Barras radiales: rating promedio (máx. 5)
    ChartItem(
      number: 106,
      title: 'Barras radiales: Rating promedio (Máx. 5) en Top 5',
      advanced: true,
      observation: 'Cada anillo concéntrico codifica la cercanía a la calificación perfecta de 5 estrellas.',
      builder: (context) => SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.right),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries<CategoryStat, String>>[
          RadialBarSeries<CategoryStat, String>(
            dataSource: top5,
            maximumValue: 5,
            gap: '6%',
            radius: '100%',
            cornerStyle: CornerStyle.bothCurve,
            trackOpacity: 0.15,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => double.parse(c.avgRating.toStringAsFixed(2)),
            pointColorMapper: (c, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 107. Combinado con doble eje Y, zoom y trackball
    ChartItem(
      number: 107,
      title: 'Combinado doble eje: Stock (Columnas) + Rating (Spline)',
      advanced: true,
      height: 320,
      observation: 'Eje izquierdo mide inventario, eje derecho mide satisfacción (0 a 5).',
      builder: (context) => SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
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
        primaryXAxis: const CategoryAxis(labelRotation: -30),
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
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalStock,
            color: palette[0],
          ),
          SplineSeries<CategoryStat, String>(
            name: 'Rating',
            dataSource: top6,
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

    // 108. StackedColumn: Rating alto vs Rating regular
    ChartItem(
      number: 108,
      title: 'Columnas apiladas: Artículos con Rating ≥ 4.5 vs < 4.5',
      advanced: true,
      observation: 'Desglosa la composición interna de excelencia vs calidad estándar por categoría.',
      builder: (context) => SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        series: <CartesianSeries<CategoryStat, String>>[
          StackedColumnSeries<CategoryStat, String>(
            name: 'Rating ≥ 4.5 ★',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.highRated,
            color: palette[2],
          ),
          StackedColumnSeries<CategoryStat, String>(
            name: 'Rating < 4.5 ★',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.lowRated,
            color: palette[1],
          ),
        ],
      ),
    ),

    // 109. BubbleSeries: Precio vs Rating (tamaño = stock)
    ChartItem(
      number: 109,
      title: 'Burbujas: Precio vs Rating (Tamaño = Unidades en Bodega)',
      advanced: true,
      observation: 'Cada burbuja mapea tres variables a la vez: costo, notas de usuario y stock.',
      builder: (context) {
        final sample = products.where((p) => p.price < 250).take(30).toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Precio (\$ USD)')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Rating (★)')),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<Product, num>>[
            BubbleSeries<Product, num>(
              dataSource: sample,
              xValueMapper: (p, _) => p.price,
              yValueMapper: (p, _) => p.rating,
              sizeValueMapper: (p, _) => p.stock,
              color: palette[4].withValues(alpha: 0.6),
            ),
          ],
        );
      },
    ),

    // 110. RangeColumnSeries: Rango de precios mín-máx por categoría
    ChartItem(
      number: 110,
      title: 'Rango de Columnas: Amplitud de precios (Mínimo a Máximo)',
      advanced: true,
      observation: 'Las columnas flotantes marcan el precio más bajo y más alto de cada departamento.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Precio (\$ USD)')),
        series: <CartesianSeries<CategoryStat, String>>[
          RangeColumnSeries<CategoryStat, String>(
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            lowValueMapper: (c, _) => c.minPrice,
            highValueMapper: (c, _) => c.maxPrice,
            color: palette[6],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 111. StackedBarSeries (horizontal): Inventario dividido por nivel de riesgo
    ChartItem(
      number: 111,
      title: 'Barras horizontales apiladas: Stock bajo (<25) vs adecuado',
      advanced: true,
      observation: 'Muestra la composición de riesgo de existencias en orientación horizontal.',
      builder: (context) => SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: const CategoryAxis(),
        series: <CartesianSeries<CategoryStat, String>>[
          StackedBarSeries<CategoryStat, String>(
            name: 'Stock Bajo (<25)',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.lowStockCount,
            color: palette[3],
          ),
          StackedBarSeries<CategoryStat, String>(
            name: 'Stock Adecuado (≥25)',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.highStockCount,
            color: palette[0],
          ),
        ],
      ),
    ),

    // 112. SfCartesianChart con Doble Eje: Precio promedio + Descuento %
    ChartItem(
      number: 112,
      title: 'Doble eje: Precio promedio (\$ USD) + Descuento promedio (%)',
      advanced: true,
      height: 320,
      observation: 'Permite analizar si departamentos con precios más caros otorgan mayores rebajas.',
      builder: (context) => SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Precio Promedio (\$)')),
        axes: const <ChartAxis>[
          NumericAxis(
            name: 'discAxis',
            opposedPosition: true,
            title: AxisTitle(text: 'Descuento Promedio (%)'),
          ),
        ],
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            name: 'Precio Promedio',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.avgPrice,
            color: palette[0],
          ),
          LineSeries<CategoryStat, String>(
            name: 'Descuento Promedio',
            dataSource: top6,
            yAxisName: 'discAxis',
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.avgDiscount,
            color: palette[1],
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 113. RadialBarSeries: Descuento promedio en 5 categorías
    ChartItem(
      number: 113,
      title: 'Barras radiales: Promedio de descuento (%) en Top 5',
      advanced: true,
      observation: 'Cada arco circular representa el porcentaje de descuento promedio alcanzado.',
      builder: (context) => SfCircularChart(
        legend: const Legend(isVisible: true, position: LegendPosition.right),
        series: <CircularSeries<CategoryStat, String>>[
          RadialBarSeries<CategoryStat, String>(
            dataSource: top5,
            maximumValue: 25,
            gap: '8%',
            radius: '100%',
            cornerStyle: CornerStyle.bothCurve,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => double.parse(c.avgDiscount.toStringAsFixed(1)),
            pointColorMapper: (c, i) => palette[i % palette.length],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 114. ScatterSeries: Descuento vs Precio
    ChartItem(
      number: 114,
      title: 'Dispersión (Scatter): Precio vs Descuento con formas',
      advanced: true,
      observation: 'Puntos en el plano que revelan ausencia de correlación entre precio y porcentaje de rebaja.',
      builder: (context) {
        final ps = products.take(35).toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Precio (\$ USD)')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Descuento (%)')),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<Product, num>>[
            ScatterSeries<Product, num>(
              dataSource: ps,
              xValueMapper: (p, _) => p.price,
              yValueMapper: (p, _) => p.discount,
              color: palette[2],
              markerSettings: const MarkerSettings(
                shape: DataMarkerType.diamond,
                width: 9,
                height: 9,
              ),
            ),
          ],
        );
      },
    ),

    // 115. StackedAreaSeries: Precio de venta vs Monto de descuento
    ChartItem(
      number: 115,
      title: 'Áreas apiladas: Precio rebajado vs Monto ahorrado',
      advanced: true,
      observation: 'La suma de ambas áreas conforma el 100% del precio de lista original.',
      builder: (context) {
        final sample = products.take(15).toList();
        return SfCartesianChart(
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          primaryXAxis: const NumericAxis(interval: 2),
          series: <CartesianSeries<Product, int>>[
            StackedAreaSeries<Product, int>(
              name: 'Precio Final',
              dataSource: sample,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.discountedPrice,
              color: palette[0].withValues(alpha: 0.6),
            ),
            StackedAreaSeries<Product, int>(
              name: 'Ahorro Descontado',
              dataSource: sample,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.discountAmount,
              color: palette[1].withValues(alpha: 0.6),
            ),
          ],
        );
      },
    ),

    // 116. BubbleSeries: Descuento vs Precio con tamaño = Valor de inventario
    ChartItem(
      number: 116,
      title: 'Burbujas: Descuento vs Precio (Tamaño = Capital en Inventario)',
      advanced: true,
      observation: 'Identifica qué promociones afectan a productos que representan alto volumen financiero.',
      builder: (context) {
        final sample = products.take(25).toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Descuento (%)')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Precio (\$ USD)')),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<Product, num>>[
            BubbleSeries<Product, num>(
              dataSource: sample,
              xValueMapper: (p, _) => p.discount,
              yValueMapper: (p, _) => p.price,
              sizeValueMapper: (p, _) => p.inventoryValue,
              color: palette[5].withValues(alpha: 0.55),
            ),
          ],
        );
      },
    ),

    // 117. RangeAreaSeries: Banda de ahorro entre precio lista y rebajado
    ChartItem(
      number: 117,
      title: 'Área de rango: Brecha monetaria de descuento por producto',
      advanced: true,
      observation: 'La franja rellena resalta el diferencial absoluto de dinero ahorrado.',
      builder: (context) {
        final sample = products.take(16).toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(interval: 2),
          series: <CartesianSeries<Product, int>>[
            RangeAreaSeries<Product, int>(
              dataSource: sample,
              xValueMapper: (p, i) => i + 1,
              lowValueMapper: (p, _) => p.discountedPrice,
              highValueMapper: (p, _) => p.price,
              color: palette[2].withValues(alpha: 0.4),
              borderColor: palette[2],
              borderWidth: 2,
            ),
          ],
        );
      },
    ),

    // 118. StackedColumn100Series: Distribución 100% normalizada
    ChartItem(
      number: 118,
      title: 'Columnas 100% apiladas: Proporción de satisfacción',
      advanced: true,
      observation: 'Normaliza cada columna al 100% para comparar la pureza de calificaciones entre categorías.',
      builder: (context) => SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Porcentaje (%)')),
        series: <CartesianSeries<CategoryStat, String>>[
          StackedColumn100Series<CategoryStat, String>(
            name: 'Rating ≥ 4.5 ★',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.highRated,
            color: palette[2],
          ),
          StackedColumn100Series<CategoryStat, String>(
            name: 'Rating < 4.5 ★',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.lowRated,
            color: palette[4],
          ),
        ],
      ),
    ),

    // 119. HistogramSeries: Distribución de frecuencias de precios
    ChartItem(
      number: 119,
      title: 'Histograma: Distribución de densidad de precios en catálogo',
      advanced: true,
      observation: 'Agrupa automáticamente los precios en contenedores de frecuencia estadística.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Intervalos de Precio')),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Frecuencia de Productos')),
        series: <CartesianSeries<Product, num>>[
          HistogramSeries<Product, num>(
            dataSource: products,
            yValueMapper: (p, _) => p.price,
            binInterval: 25,
            color: palette[0],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 120. SfCartesianChart con Zoom y Pan interactivo
    ChartItem(
      number: 120,
      title: 'Gráfico con Zoom y Pan interactivo: Análisis de 40 artículos',
      advanced: true,
      observation: 'Permite pellizcar y arrastrar horizontalmente para navegar por toda la muestra.',
      builder: (context) {
        final sample = products.take(40).toList();
        return SfCartesianChart(
          zoomPanBehavior: ZoomPanBehavior(
            enablePinching: true,
            enablePanning: true,
            zoomMode: ZoomMode.x,
          ),
          primaryXAxis: const NumericAxis(interval: 5),
          series: <CartesianSeries<Product, int>>[
            SplineSeries<Product, int>(
              dataSource: sample,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.price,
              color: palette[1],
              width: 3,
            ),
          ],
        );
      },
    ),

    // 121. RadialBarSeries: Cobertura de cuota de stock
    ChartItem(
      number: 121,
      title: 'Barras radiales: Porcentaje de cuota sobre stock total',
      advanced: true,
      observation: 'Compara qué porción del inventario general aporta cada una de las 4 categorías líderes.',
      builder: (context) {
        final tot = data.categories.fold(0, (s, c) => s + c.totalStock);
        return SfCircularChart(
          legend: const Legend(isVisible: true, position: LegendPosition.right),
          series: <CircularSeries<CategoryStat, String>>[
            RadialBarSeries<CategoryStat, String>(
              dataSource: data.topByStock(4),
              maximumValue: 30,
              gap: '8%',
              radius: '100%',
              cornerStyle: CornerStyle.bothCurve,
              xValueMapper: (c, _) => c.shortName,
              yValueMapper: (c, _) =>
                  double.parse(((c.totalStock / tot) * 100).toStringAsFixed(1)),
              pointColorMapper: (c, i) => palette[i % palette.length],
              dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        );
      },
    ),

    // 122. SfCartesianChart con Trackball tooltip agrupado
    ChartItem(
      number: 122,
      title: 'Trackball interactivo: Stock vs Precio promedio en Top 6',
      advanced: true,
      observation: 'Toca o arrastra sobre el gráfico para ver el tooltip simultáneo de ambas series.',
      builder: (context) => SfCartesianChart(
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        ),
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            name: 'Stock',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalStock,
            color: palette[6],
          ),
          SplineSeries<CategoryStat, String>(
            name: 'Precio Promedio',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.avgPrice,
            color: palette[7],
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 123. StackedBar100Series: Proporción 100% horizontal de descuento
    ChartItem(
      number: 123,
      title: 'Barras 100% horizontales: Proporción de stock bajo vs adecuado',
      advanced: true,
      observation: 'Muestra visualmente la cuota normalizada de inventario vulnerable por categoría.',
      builder: (context) => SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: const CategoryAxis(),
        series: <CartesianSeries<CategoryStat, String>>[
          StackedBar100Series<CategoryStat, String>(
            name: 'Stock Crítico/Bajo',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.lowStockCount,
            color: palette[3],
          ),
          StackedBar100Series<CategoryStat, String>(
            name: 'Stock Adecuado',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.highStockCount,
            color: palette[2],
          ),
        ],
      ),
    ),

    // 124. WaterfallSeries: Cascada de valor de catálogo
    ChartItem(
      number: 124,
      title: 'Cascada (Waterfall): Aportación de valor por categoría',
      advanced: true,
      observation: 'Gráfico financiero tipo cascada que ilustra la suma progresiva de valor de inventario.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        series: <CartesianSeries<CategoryStat, String>>[
          WaterfallSeries<CategoryStat, String>(
            dataSource: top5,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalValue / 1000,
            color: palette[2],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 125. BubbleSeries: Satisfacción vs Descuento con tamaño = Stock
    ChartItem(
      number: 125,
      title: 'Burbujas: Rating vs Descuento (Tamaño = Unidades en Bodega)',
      advanced: true,
      observation: 'Identifica la coexistencia de altas valoraciones con políticas promocionales generosas.',
      builder: (context) {
        final sample = products.take(30).toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(title: AxisTitle(text: 'Rating (★)')),
          primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Descuento (%)')),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<Product, num>>[
            BubbleSeries<Product, num>(
              dataSource: sample,
              xValueMapper: (p, _) => p.rating,
              yValueMapper: (p, _) => p.discount,
              sizeValueMapper: (p, _) => p.stock,
              color: palette[3].withValues(alpha: 0.5),
            ),
          ],
        );
      },
    ),

    // 126. SfCartesianChart con Crosshair interactivo
    ChartItem(
      number: 126,
      title: 'Gráfico con Crosshair (Mira de precisión): Precios y ofertas',
      advanced: true,
      observation: 'Al mantener pulsado, las líneas guía horizontal y vertical permiten lecturas de precisión milimétrica.',
      builder: (context) {
        final sample = products.take(20).toList();
        return SfCartesianChart(
          crosshairBehavior: CrosshairBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            lineType: CrosshairLineType.both,
          ),
          primaryXAxis: const NumericAxis(interval: 2),
          series: <CartesianSeries<Product, int>>[
            SplineSeries<Product, int>(
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

    // 127. SplineAreaSeries con gradiente: Curva financiera
    ChartItem(
      number: 127,
      title: 'Spline de Área con degradado: Inversión en almacén por artículo',
      advanced: true,
      observation: 'Visualiza la acumulación monetaria por artículo con un gradiente visual estético.',
      builder: (context) {
        final sample = products.take(18).toList();
        return SfCartesianChart(
          primaryXAxis: const NumericAxis(interval: 2),
          series: <CartesianSeries<Product, int>>[
            SplineAreaSeries<Product, int>(
              dataSource: sample,
              xValueMapper: (p, i) => i + 1,
              yValueMapper: (p, _) => p.inventoryValue,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [palette[0], palette[6].withValues(alpha: 0.2)],
              ),
              borderColor: palette[0],
              borderWidth: 2.5,
            ),
          ],
        );
      },
    ),

    // 128. RangeColumnSeries: Variabilidad de descuento (mín-máx)
    ChartItem(
      number: 128,
      title: 'Rango de Columnas: Dispersión de descuentos en Top 6',
      advanced: true,
      observation: 'Muestra la banda mínima y máxima de rebajas promocionales registradas por categoría.',
      builder: (context) => SfCartesianChart(
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Descuento (%)')),
        series: <CartesianSeries<CategoryStat, String>>[
          RangeColumnSeries<CategoryStat, String>(
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            lowValueMapper: (c, _) => (c.avgDiscount * 0.6).clamp(0, 100),
            highValueMapper: (c, _) => (c.avgDiscount * 1.4).clamp(0, 100),
            color: palette[1],
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 129. SfCartesianChart Combinado: Columnas de valor + Spline de descuento
    ChartItem(
      number: 129,
      title: 'Combinado: Capital de inventario (\$k) + Descuento promedio (%)',
      advanced: true,
      height: 320,
      observation: 'Cruza el volumen financiero con la agresividad de las promociones aplicadas.',
      builder: (context) => SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        primaryYAxis: const NumericAxis(title: AxisTitle(text: 'Valor (\$k USD)')),
        axes: const <ChartAxis>[
          NumericAxis(
            name: 'discAxis',
            opposedPosition: true,
            title: AxisTitle(text: 'Descuento Promedio (%)'),
          ),
        ],
        series: <CartesianSeries<CategoryStat, String>>[
          ColumnSeries<CategoryStat, String>(
            name: 'Valor (\$k USD)',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.totalValue / 1000,
            color: palette[4],
          ),
          SplineSeries<CategoryStat, String>(
            name: 'Descuento (%)',
            dataSource: top6,
            yAxisName: 'discAxis',
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.avgDiscount,
            color: palette[5],
            width: 3,
            markerSettings: const MarkerSettings(isVisible: true),
          ),
        ],
      ),
    ),

    // 130. StackedColumnSeries: Composición tridimensional de stock
    ChartItem(
      number: 130,
      title: 'Columnas apiladas (3 niveles): Stock Crítico, Medio y Óptimo',
      advanced: true,
      observation: 'Estratifica el inventario de las categorías líderes en 3 semáforos de riesgo logístico.',
      builder: (context) => SfCartesianChart(
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: const CategoryAxis(labelRotation: -30),
        series: <CartesianSeries<CategoryStat, String>>[
          StackedColumnSeries<CategoryStat, String>(
            name: 'Crítico (<25u)',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => c.lowStockCount,
            color: palette[3],
          ),
          StackedColumnSeries<CategoryStat, String>(
            name: 'Medio (25-50u)',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => (c.highStockCount / 2).round(),
            color: palette[1],
          ),
          StackedColumnSeries<CategoryStat, String>(
            name: 'Óptimo (>50u)',
            dataSource: top6,
            xValueMapper: (c, _) => c.shortName,
            yValueMapper: (c, _) => (c.highStockCount - (c.highStockCount / 2).round()),
            color: palette[2],
          ),
        ],
      ),
    ),
  ];
}
