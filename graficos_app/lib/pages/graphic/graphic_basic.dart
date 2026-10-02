import 'package:graphic/graphic.dart';

import '../../models/models.dart';
import '../../theme/palette.dart';

List<ChartItem> getGraphicBasicItems(ChartData data) {
  final products = data.products;
  final top8 = data.top(8);
  final top6 = data.top(6);
  final pBrackets = data.priceBrackets;
  final sBrackets = data.stockBrackets;
  final dBrackets = data.discountBrackets;

  return [
    // 131. Barras horizontales: Cantidad por categoría
    ChartItem(
      number: 131,
      title: 'Barras horizontales: Catálogo por categoría',
      advanced: false,
      observation: 'Orientación horizontal que optimiza la lectura de nombres largos de categoría.',
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
              label: LabelEncode(encoder: (t) => Label(t['count'].toString())),
            ),
          ],
          coord: RectCoord(transposed: true),
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 132. Línea suave con área: Rating de 20 productos
    ChartItem(
      number: 132,
      title: 'Línea suave + área: Rating de primeros 20 productos',
      advanced: false,
      observation: 'Curva suavizada con área translúcida que resalta la constancia de notas altas.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 20; i++)
            {'idx': '${i + 1}', 'rating': products[i].rating},
        ];
        return Chart(
          data: rows,
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
        );
      },
    ),

    // 133. Puntos: Stock vs Descuento
    ChartItem(
      number: 133,
      title: 'Puntos: Unidades de stock vs % de descuento',
      advanced: false,
      observation: 'Dispersión bidimensional que evalúa si el nivel de existencias condiciona las ofertas.',
      builder: (context) {
        final rows = [
          for (final p in products.take(30))
            {'stock': p.stock, 'discount': p.discount},
        ];
        return Chart(
          data: rows,
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
        );
      },
    ),

    // 134. Barras verticales: Precio promedio en Top 6
    ChartItem(
      number: 134,
      title: 'Barras verticales: Precio promedio en Top 6 categorías',
      advanced: false,
      observation: 'Compara la media de precios de venta entre las familias principales.',
      builder: (context) {
        final rows = [
          for (final c in top6)
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
              color: ColorEncode(value: palette[0]),
              label: LabelEncode(encoder: (t) => Label('\$${t['price']}')),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 135. Línea simple: Precios de los primeros 15 productos
    ChartItem(
      number: 135,
      title: 'Línea continua: Precios de 15 productos',
      advanced: false,
      observation: 'Trazo continuo de precios que detecta variaciones abruptas de costos.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 15; i++)
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
              color: ColorEncode(value: palette[1]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 136. Barras horizontales: Stock total en Top 6
    ChartItem(
      number: 136,
      title: 'Barras horizontales: Stock acumulado en Top 6 categorías',
      advanced: false,
      observation: 'Visualización clara de volumen físico por departamento en eje horizontal.',
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
              label: LabelEncode(encoder: (t) => Label(t['stock'].toString())),
            ),
          ],
          coord: RectCoord(transposed: true),
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 137. Puntos: Precio vs Rating
    ChartItem(
      number: 137,
      title: 'Puntos: Precio (\$ USD) vs Rating (★)',
      advanced: false,
      observation: 'Cada punto es un artículo mapeado por su precio y nota otorgada por usuarios.',
      builder: (context) {
        final rows = [
          for (final p in products.take(30))
            {'price': p.price, 'rating': p.rating},
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
          },
          marks: [
            PointMark(
              size: SizeEncode(value: 6),
              color: ColorEncode(value: palette[3]),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 138. Área continua: Variación de descuento en 20 productos
    ChartItem(
      number: 138,
      title: 'Área continua: Porcentaje de descuento en 20 productos',
      advanced: false,
      observation: 'Volumen y fluctuación continua de los márgenes de descuento aplicados.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 20; i++)
            {'idx': '${i + 1}', 'discount': products[i].discount},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'discount': Variable(
              accessor: (Map m) => m['discount'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            AreaMark(
              color: ColorEncode(value: palette[5].withValues(alpha: 0.4)),
            ),
            LineMark(
              color: ColorEncode(value: palette[5]),
              size: SizeEncode(value: 2),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 139. Barras verticales: Descuento promedio en Top 6
    ChartItem(
      number: 139,
      title: 'Barras verticales: Descuento medio (%) en Top 6',
      advanced: false,
      observation: 'Revela el nivel de rebajas promedio por categoría.',
      builder: (context) {
        final rows = [
          for (final c in top6)
            {'cat': c.shortName, 'discount': double.parse(c.avgDiscount.toStringAsFixed(1))},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'discount': Variable(
              accessor: (Map m) => m['discount'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(variable: 'cat', values: palette),
              label: LabelEncode(encoder: (t) => Label('${t['discount']}%')),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 140. Línea con escalones (Step Line): Precios ordenados
    ChartItem(
      number: 140,
      title: 'Línea escalonada: Progresión ordenada de precios',
      advanced: false,
      observation: 'Gráfico con saltos discretos que resalta cambios de nivel tarifario.',
      builder: (context) {
        final sample = data.topProductsByPrice(15).reversed.toList();
        final rows = [
          for (var i = 0; i < sample.length; i++)
            {'idx': '${i + 1}', 'price': sample[i].price},
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
              shape: ShapeEncode(value: BasicLineShape(stepped: true)),
              color: ColorEncode(value: palette[6]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 141. Barras horizontales: Cantidad por banda de precio
    ChartItem(
      number: 141,
      title: 'Barras horizontales: Artículos por rango de precio',
      advanced: false,
      observation: 'Muestra la densidad de referencias ofrecidas en cada tramo presupuestario.',
      builder: (context) {
        final rows = [
          for (final b in pBrackets) {'bracket': b.label, 'count': b.count},
        ];
        return Chart(
          data: rows,
          variables: {
            'bracket': Variable(accessor: (Map m) => m['bracket'] as String),
            'count': Variable(
              accessor: (Map m) => m['count'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(value: palette[0]),
              label: LabelEncode(encoder: (t) => Label(t['count'].toString())),
            ),
          ],
          coord: RectCoord(transposed: true),
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 142. Puntos: Precio vs Stock
    ChartItem(
      number: 142,
      title: 'Puntos: Precio vs Unidades en almacén',
      advanced: false,
      observation: 'Analiza la relación entre valor monetario y cantidad física almacenada.',
      builder: (context) {
        final rows = [
          for (final p in products.take(30))
            {'price': p.price, 'stock': p.stock},
        ];
        return Chart(
          data: rows,
          variables: {
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
              size: SizeEncode(value: 6),
              color: ColorEncode(value: palette[1]),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 143. Línea suavizada: Ratings continuos de 20 productos
    ChartItem(
      number: 143,
      title: 'Línea suavizada: Calificaciones continuas en 20 productos',
      advanced: false,
      observation: 'Trazo suave sin quiebres de calificaciones de clientes.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 20; i++)
            {'idx': '${i + 1}', 'rating': products[i].rating},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'rating': Variable(
              accessor: (Map m) => m['rating'] as num,
              scale: LinearScale(min: 1, max: 5),
            ),
          },
          marks: [
            LineMark(
              shape: ShapeEncode(value: BasicLineShape(smooth: true)),
              color: ColorEncode(value: palette[3]),
              size: SizeEncode(value: 3),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 144. Barras verticales: Stock en las 8 categorías líderes
    ChartItem(
      number: 144,
      title: 'Barras verticales: Unidades de stock en Top 8 categorías',
      advanced: false,
      observation: 'Comparación visual directa del volumen de existencias en el almacén.',
      builder: (context) {
        final rows = [
          for (final c in top8) {'cat': c.shortName, 'stock': c.totalStock},
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
              color: ColorEncode(value: palette[4]),
              label: LabelEncode(encoder: (t) => Label(t['stock'].toString())),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 145. Área rellena: Acumulación de inventario en 15 productos
    ChartItem(
      number: 145,
      title: 'Área continua: Perfil de inventario en 15 artículos',
      advanced: false,
      observation: 'Representa gráficamente el volumen de piezas en bodega para una muestra.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 15; i++)
            {'idx': '${i + 1}', 'stock': products[i].stock},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            AreaMark(
              color: ColorEncode(value: palette[0].withValues(alpha: 0.3)),
            ),
            LineMark(
              color: ColorEncode(value: palette[0]),
              size: SizeEncode(value: 2),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 146. Barras horizontales: Top 8 productos con mayor stock
    ChartItem(
      number: 146,
      title: 'Barras horizontales: 8 productos con más existencias',
      advanced: false,
      observation: 'Artículos con mayor disponibilidad física inmediata.',
      builder: (context) {
        final sample = data.topProductsByStock(8).reversed.toList();
        final rows = [
          for (final p in sample) {'prod': p.shortTitle, 'stock': p.stock},
        ];
        return Chart(
          data: rows,
          variables: {
            'prod': Variable(accessor: (Map m) => m['prod'] as String),
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(value: palette[2]),
              label: LabelEncode(encoder: (t) => Label(t['stock'].toString())),
            ),
          ],
          coord: RectCoord(transposed: true),
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 147. Puntos: Descuento vs Rating
    ChartItem(
      number: 147,
      title: 'Puntos: % Descuento vs Calificación de satisfacción',
      advanced: false,
      observation: 'Verifica si productos con mayores descuentos obtienen mejores notas.',
      builder: (context) {
        final rows = [
          for (final p in products.take(30))
            {'discount': p.discount, 'rating': p.rating},
        ];
        return Chart(
          data: rows,
          variables: {
            'discount': Variable(
              accessor: (Map m) => m['discount'] as num,
              scale: LinearScale(min: 0),
            ),
            'rating': Variable(
              accessor: (Map m) => m['rating'] as num,
              scale: LinearScale(min: 1, max: 5),
            ),
          },
          marks: [
            PointMark(
              size: SizeEncode(value: 6),
              color: ColorEncode(value: palette[5]),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 148. Línea: Precios de los 12 productos más caros
    ChartItem(
      number: 148,
      title: 'Línea: Curva descendente de los 12 productos más costosos',
      advanced: false,
      observation: 'Refleja la caída de precio dentro del segmento premium.',
      builder: (context) {
        final sample = data.topProductsByPrice(12);
        final rows = [
          for (var i = 0; i < sample.length; i++)
            {'idx': 'T${i + 1}', 'price': sample[i].price},
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
              color: ColorEncode(value: palette[7]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 149. Barras verticales: Valor de inventario en Top 6
    ChartItem(
      number: 149,
      title: 'Barras verticales: Capital en inventario (\$k) en Top 6',
      advanced: false,
      observation: 'Capital acumulado en miles de dólares en los departamentos líderes.',
      builder: (context) {
        final rows = [
          for (final c in top6)
            {'cat': c.shortName, 'val': double.parse((c.totalValue / 1000).toStringAsFixed(1))},
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
              label: LabelEncode(encoder: (t) => Label('\$${t['val']}k')),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 150. Área suave: Descuentos en productos con alta calificación (≥4.0)
    ChartItem(
      number: 150,
      title: 'Área suave: Descuento en productos de alta satisfacción',
      advanced: false,
      observation: 'Muestra las ofertas disponibles en productos con nota superior a 4.0.',
      builder: (context) {
        final high = products.where((p) => p.rating >= 4.0).take(15).toList();
        final rows = [
          for (var i = 0; i < high.length; i++)
            {'idx': '${i + 1}', 'discount': high[i].discount},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'discount': Variable(
              accessor: (Map m) => m['discount'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            AreaMark(
              shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
              color: ColorEncode(value: palette[6].withValues(alpha: 0.35)),
            ),
            LineMark(
              shape: ShapeEncode(value: BasicLineShape(smooth: true)),
              color: ColorEncode(value: palette[6]),
              size: SizeEncode(value: 2),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 151. Barras horizontales: 8 productos más costosos
    ChartItem(
      number: 151,
      title: 'Barras horizontales: 8 artículos con mayor precio de venta',
      advanced: false,
      observation: 'Identifica los productos más caros ofertados en el catálogo.',
      builder: (context) {
        final sample = data.topProductsByPrice(8).reversed.toList();
        final rows = [
          for (final p in sample) {'prod': p.shortTitle, 'price': p.price},
        ];
        return Chart(
          data: rows,
          variables: {
            'prod': Variable(accessor: (Map m) => m['prod'] as String),
            'price': Variable(
              accessor: (Map m) => m['price'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(value: palette[1]),
              label: LabelEncode(encoder: (t) => Label('\$${t['price']}')),
            ),
          ],
          coord: RectCoord(transposed: true),
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 152. Puntos: Stock vs Precio de 30 productos
    ChartItem(
      number: 152,
      title: 'Puntos: Unidades de stock vs Precio individual',
      advanced: false,
      observation: 'Detecta correlaciones entre nivel de existencias y precio.',
      builder: (context) {
        final rows = [
          for (final p in products.take(30))
            {'stock': p.stock, 'price': p.price},
        ];
        return Chart(
          data: rows,
          variables: {
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
            'price': Variable(
              accessor: (Map m) => m['price'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            PointMark(
              size: SizeEncode(value: 6),
              color: ColorEncode(value: palette[4]),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 153. Línea simple: Rating en productos de bajo costo (< $50)
    ChartItem(
      number: 153,
      title: 'Línea: Rating en productos accesibles (< \$50)',
      advanced: false,
      observation: 'Inspecciona la satisfacción del cliente en la gama económica.',
      builder: (context) {
        final cheap = products.where((p) => p.price < 50).take(15).toList();
        final rows = [
          for (var i = 0; i < cheap.length; i++)
            {'idx': '${i + 1}', 'rating': cheap[i].rating},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'rating': Variable(
              accessor: (Map m) => m['rating'] as num,
              scale: LinearScale(min: 1, max: 5),
            ),
          },
          marks: [
            LineMark(
              color: ColorEncode(value: palette[2]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 154. Barras verticales: Cantidad de productos por nivel de stock
    ChartItem(
      number: 154,
      title: 'Barras verticales: Salud de stock (Crítico a Alto)',
      advanced: false,
      observation: 'Histograma por semáforo de existencias en almacén.',
      builder: (context) {
        final rows = [
          for (final b in sBrackets) {'bracket': b.label, 'count': b.count},
        ];
        return Chart(
          data: rows,
          variables: {
            'bracket': Variable(accessor: (Map m) => m['bracket'] as String),
            'count': Variable(
              accessor: (Map m) => m['count'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(variable: 'bracket', values: palette),
              label: LabelEncode(encoder: (t) => Label(t['count'].toString())),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 155. Área rellena: Margen de descuento en 18 artículos
    ChartItem(
      number: 155,
      title: 'Área rellena: Rebajas aplicadas en 18 artículos',
      advanced: false,
      observation: 'Muestra la cobertura promocional de ofertas activas.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 18; i++)
            {'idx': '${i + 1}', 'discount': products[i].discount},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'discount': Variable(
              accessor: (Map m) => m['discount'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            AreaMark(
              color: ColorEncode(value: palette[1].withValues(alpha: 0.3)),
            ),
            LineMark(
              color: ColorEncode(value: palette[1]),
              size: SizeEncode(value: 2),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 156. Barras horizontales: Rating promedio en Top 6
    ChartItem(
      number: 156,
      title: 'Barras horizontales: Rating promedio en Top 6 categorías',
      advanced: false,
      observation: 'Compara la reputación de los 6 departamentos con más artículos.',
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
              scale: LinearScale(min: 0, max: 5),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(value: palette[3]),
              label: LabelEncode(encoder: (t) => Label('★${t['rating']}')),
            ),
          ],
          coord: RectCoord(transposed: true),
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 157. Puntos: Unidades de stock vs Descuento
    ChartItem(
      number: 157,
      title: 'Puntos: Unidades de stock vs Porcentaje de descuento',
      advanced: false,
      observation: 'Permite descubrir si el sobrestock provoca mayores descuentos.',
      builder: (context) {
        final rows = [
          for (final p in products.take(30))
            {'stock': p.stock, 'discount': p.discount},
        ];
        return Chart(
          data: rows,
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
              size: SizeEncode(value: 6),
              color: ColorEncode(value: palette[0]),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 158. Línea: Nivel de existencias en 20 productos
    ChartItem(
      number: 158,
      title: 'Línea: Unidades en bodega en 20 artículos continuos',
      advanced: false,
      observation: 'Seguimiento de la disponibilidad de inventario.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 20; i++)
            {'idx': '${i + 1}', 'stock': products[i].stock},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            LineMark(
              color: ColorEncode(value: palette[5]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 159. Barras verticales: Precio mínimo por categoría
    ChartItem(
      number: 159,
      title: 'Barras verticales: Precio de entrada mínimo en Top 6',
      advanced: false,
      observation: 'El artículo más asequible de cada categoría.',
      builder: (context) {
        final rows = [
          for (final c in top6) {'cat': c.shortName, 'min': c.minPrice},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'min': Variable(
              accessor: (Map m) => m['min'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(value: palette[2]),
              label: LabelEncode(encoder: (t) => Label('\$${t['min']}')),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 160. Área suave: Precios de la primera categoría
    ChartItem(
      number: 160,
      title: 'Área suave: Precios en la categoría líder',
      advanced: false,
      observation: 'Visualiza la distribución de precios en la categoría con más productos.',
      builder: (context) {
        final list = products.where((p) => p.category == data.top(1).first.name).toList();
        final rows = [
          for (var i = 0; i < list.length; i++)
            {'idx': '${i + 1}', 'price': list[i].price},
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
            AreaMark(
              shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
              color: ColorEncode(value: palette[4].withValues(alpha: 0.3)),
            ),
            LineMark(
              shape: ShapeEncode(value: BasicLineShape(smooth: true)),
              color: ColorEncode(value: palette[4]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 161. Barras horizontales: Stock en productos baratos
    ChartItem(
      number: 161,
      title: 'Barras horizontales: Stock en los 8 artículos más baratos',
      advanced: false,
      observation: 'Verifica si los artículos económicos tienen alto inventario disponible.',
      builder: (context) {
        final sample = data.cheapestProducts(8).reversed.toList();
        final rows = [
          for (final p in sample) {'prod': p.shortTitle, 'stock': p.stock},
        ];
        return Chart(
          data: rows,
          variables: {
            'prod': Variable(accessor: (Map m) => m['prod'] as String),
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(value: palette[0]),
              label: LabelEncode(encoder: (t) => Label(t['stock'].toString())),
            ),
          ],
          coord: RectCoord(transposed: true),
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 162. Puntos: Rating vs Precio en artículos con descuento >= 10%
    ChartItem(
      number: 162,
      title: 'Puntos: Rating vs Precio en productos con descuento ≥ 10%',
      advanced: false,
      observation: 'Inspecciona la relación de calidad y costo en ofertas destacadas.',
      builder: (context) {
        final disc = products.where((p) => p.discount >= 10).take(25).toList();
        final rows = [
          for (final p in disc) {'rating': p.rating, 'price': p.price},
        ];
        return Chart(
          data: rows,
          variables: {
            'rating': Variable(
              accessor: (Map m) => m['rating'] as num,
              scale: LinearScale(min: 1, max: 5),
            ),
            'price': Variable(
              accessor: (Map m) => m['price'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            PointMark(
              size: SizeEncode(value: 6),
              color: ColorEncode(value: palette[7]),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 163. Línea: Descuentos en productos con inventario crítico (<20)
    ChartItem(
      number: 163,
      title: 'Línea: Descuentos en productos con stock crítico (<20u)',
      advanced: false,
      observation: 'Determina si artículos con pocas unidades están siendo liquidados.',
      builder: (context) {
        final crit = products.where((p) => p.stock < 20).take(15).toList();
        final rows = [
          for (var i = 0; i < crit.length; i++)
            {'idx': '${i + 1}', 'discount': crit[i].discount},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'discount': Variable(
              accessor: (Map m) => m['discount'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            LineMark(
              color: ColorEncode(value: palette[3]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 164. Barras verticales: Precio máximo registrado en Top 6
    ChartItem(
      number: 164,
      title: 'Barras verticales: Precio máximo en Top 6 categorías',
      advanced: false,
      observation: 'Precios tope observados en cada categoría principal.',
      builder: (context) {
        final rows = [
          for (final c in top6) {'cat': c.shortName, 'max': c.maxPrice},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'max': Variable(
              accessor: (Map m) => m['max'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(value: palette[5]),
              label: LabelEncode(encoder: (t) => Label('\$${t['max']}')),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 165. Área rellena: Curva de precios de 15 productos
    ChartItem(
      number: 165,
      title: 'Área rellena: Perfil de precios de 15 productos',
      advanced: false,
      observation: 'Visualiza la acumulación de valor unitario a lo largo de la serie.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 15; i++)
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
            AreaMark(
              color: ColorEncode(value: palette[0].withValues(alpha: 0.35)),
            ),
            LineMark(
              color: ColorEncode(value: palette[0]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 166. Barras horizontales: Artículos según bandas de descuento
    ChartItem(
      number: 166,
      title: 'Barras horizontales: Artículos por rango de descuento',
      advanced: false,
      observation: 'Distribución de cantidad de productos según porcentaje de rebaja.',
      builder: (context) {
        final rows = [
          for (final b in dBrackets) {'bracket': b.label, 'count': b.count},
        ];
        return Chart(
          data: rows,
          variables: {
            'bracket': Variable(accessor: (Map m) => m['bracket'] as String),
            'count': Variable(
              accessor: (Map m) => m['count'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(value: palette[1]),
              label: LabelEncode(encoder: (t) => Label(t['count'].toString())),
            ),
          ],
          coord: RectCoord(transposed: true),
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 167. Puntos: Rating vs Stock en 25 productos
    ChartItem(
      number: 167,
      title: 'Puntos: Rating vs Stock en 25 productos',
      advanced: false,
      observation: 'Comprueba si la reputación se correlaciona con el volumen en almacén.',
      builder: (context) {
        final rows = [
          for (final p in products.take(25))
            {'rating': p.rating, 'stock': p.stock},
        ];
        return Chart(
          data: rows,
          variables: {
            'rating': Variable(
              accessor: (Map m) => m['rating'] as num,
              scale: LinearScale(min: 1, max: 5),
            ),
            'stock': Variable(
              accessor: (Map m) => m['stock'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            PointMark(
              size: SizeEncode(value: 6),
              color: ColorEncode(value: palette[6]),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 168. Línea: Precios continuos de productos con rating superior a 4.0
    ChartItem(
      number: 168,
      title: 'Línea: Precios de productos con Rating ≥ 4.0',
      advanced: false,
      observation: 'Gama de costos en los productos con mejores reseñas.',
      builder: (context) {
        final high = products.where((p) => p.rating >= 4.0).take(15).toList();
        final rows = [
          for (var i = 0; i < high.length; i++)
            {'idx': '${i + 1}', 'price': high[i].price},
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
              color: ColorEncode(value: palette[2]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 169. Barras verticales: Promedio de descuento en categorías bien valoradas
    ChartItem(
      number: 169,
      title: 'Barras verticales: Descuento en categorías con Rating ≥ 4.0',
      advanced: false,
      observation: 'Verifica promociones en los departamentos con mayor satisfacción.',
      builder: (context) {
        final highCats = data.categories.where((c) => c.avgRating >= 4.0).take(6).toList();
        final rows = [
          for (final c in highCats)
            {'cat': c.shortName, 'discount': double.parse(c.avgDiscount.toStringAsFixed(1))},
        ];
        return Chart(
          data: rows,
          variables: {
            'cat': Variable(accessor: (Map m) => m['cat'] as String),
            'discount': Variable(
              accessor: (Map m) => m['discount'] as num,
              scale: LinearScale(min: 0),
            ),
          },
          marks: [
            IntervalMark(
              color: ColorEncode(value: palette[4]),
              label: LabelEncode(encoder: (t) => Label('${t['discount']}%')),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),

    // 170. Área suave: Fluctuación de calificaciones en 15 artículos
    ChartItem(
      number: 170,
      title: 'Área suave: Satisfacción continua en 15 artículos',
      advanced: false,
      observation: 'Curva suavizada continua que ilustra la constancia en el rating de satisfacción.',
      builder: (context) {
        final rows = [
          for (var i = 0; i < 15; i++)
            {'idx': '${i + 1}', 'rating': products[i].rating},
        ];
        return Chart(
          data: rows,
          variables: {
            'idx': Variable(accessor: (Map m) => m['idx'] as String),
            'rating': Variable(
              accessor: (Map m) => m['rating'] as num,
              scale: LinearScale(min: 1, max: 5),
            ),
          },
          marks: [
            AreaMark(
              shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
              color: ColorEncode(value: palette[0].withValues(alpha: 0.3)),
            ),
            LineMark(
              shape: ShapeEncode(value: BasicLineShape(smooth: true)),
              color: ColorEncode(value: palette[0]),
              size: SizeEncode(value: 2.5),
            ),
          ],
          axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
        );
      },
    ),
  ];
}
