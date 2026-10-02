import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/chart_list_view.dart';
import 'fl_chart_advanced.dart';
import 'fl_chart_basic.dart';

/// Librería 1: fl_chart — Gráficos 1 a 65 (40 básicos + 25 avanzados).
class FlChartPage extends StatelessWidget {
  final ChartData data;
  const FlChartPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = [
      ...getFlChartBasicItems(data),
      ...getFlChartAdvancedItems(data),
    ];

    return ChartListView(
      libraryName: 'fl_chart',
      items: items,
    );
  }
}
