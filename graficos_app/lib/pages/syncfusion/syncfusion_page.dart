import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../widgets/chart_list_view.dart';
import 'syncfusion_advanced.dart';
import 'syncfusion_basic.dart';

/// Librería 2: syncfusion_flutter_charts — Gráficos 66 a 130 (40 básicos + 25 avanzados).
class SyncfusionPage extends StatelessWidget {
  final ChartData data;
  const SyncfusionPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = [
      ...getSyncfusionBasicItems(data),
      ...getSyncfusionAdvancedItems(data),
    ];

    return ChartListView(
      libraryName: 'Syncfusion',
      items: items,
    );
  }
}
