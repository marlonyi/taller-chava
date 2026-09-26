import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/api_service.dart';
import 'community_charts_page.dart';
import 'fl_chart_page.dart';
import 'graphic_page.dart';
import 'syncfusion_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = ApiService();
  late Future<ChartData> _future = _api.fetch();

  static const _tabs = [
    ('fl_chart', Icons.show_chart),
    ('Syncfusion', Icons.bar_chart),
    ('graphic', Icons.donut_large),
    ('community', Icons.stacked_bar_chart),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gráficos en Flutter · 20 ejemplos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Recargar API',
              onPressed: () => setState(() => _future = _api.fetch()),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [for (final t in _tabs) Tab(text: t.$1, icon: Icon(t.$2))],
          ),
        ),
        body: FutureBuilder<ChartData>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No se pudo consultar la API:\n${snap.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            final data = snap.data!;
            return TabBarView(
              children: [
                FlChartPage(data: data),
                SyncfusionPage(data: data),
                GraphicPage(data: data),
                CommunityChartsPage(data: data),
              ],
            );
          },
        ),
      ),
    );
  }
}
