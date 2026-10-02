import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/chart_list_view.dart';
import 'graphic_advanced.dart';
import 'graphic_basic.dart';

/// Librería 3: graphic — Gráficos 131 a 195 (40 básicos + 25 avanzados).
class GraphicPage extends StatelessWidget {
  final ChartData data;
  const GraphicPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = [
      ...getGraphicBasicItems(data),
      ...getGraphicAdvancedItems(data),
    ];

    return ChartListView(
      libraryName: 'graphic',
      items: items,
    );
  }
}
