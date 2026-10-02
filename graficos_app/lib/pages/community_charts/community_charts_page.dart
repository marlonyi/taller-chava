import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/chart_list_view.dart';
import 'community_charts_advanced.dart';
import 'community_charts_basic.dart';

/// Librería 4: community_charts_flutter — Gráficos 196 a 260 (40 básicos + 25 avanzados).
class CommunityChartsPage extends StatelessWidget {
  final ChartData data;
  const CommunityChartsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = [
      ...getCommunityChartsBasicItems(data),
      ...getCommunityChartsAdvancedItems(data),
    ];

    return ChartListView(
      libraryName: 'community_charts',
      items: items,
    );
  }
}
