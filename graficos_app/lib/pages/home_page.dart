import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/api_service.dart';
import 'community_charts/community_charts_page.dart';
import 'fl_chart/fl_chart_page.dart';
import 'graphic/graphic_page.dart';
import 'syncfusion/syncfusion_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _api = ApiService();
  late Future<ChartData> _future = _api.fetch();
  late final TabController _tabController;

  static const _tabs = [
    ('fl_chart', Icons.show_chart),
    ('Syncfusion', Icons.bar_chart),
    ('graphic', Icons.donut_large),
    ('community', Icons.stacked_bar_chart),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;

    return Scaffold(
      appBar: AppBar(
        title: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '260 Gráficos Flutter',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_tabs[_tabController.index].$1} (65 gráficos)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : const Text('Gráficos en Flutter · 260 ejemplos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar API',
            onPressed: () => setState(() => _future = _api.fetch()),
          ),
        ],
        bottom: isMobile
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [for (final t in _tabs) Tab(text: t.$1, icon: Icon(t.$2))],
              ),
      ),
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _tabController.index,
              onDestinationSelected: (i) {
                _tabController.animateTo(i);
                setState(() {});
              },
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.show_chart, size: 20),
                  selectedIcon: Icon(Icons.show_chart, size: 22),
                  label: 'FL Chart',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart, size: 20),
                  selectedIcon: Icon(Icons.bar_chart, size: 22),
                  label: 'Syncfusion',
                ),
                NavigationDestination(
                  icon: Icon(Icons.donut_large, size: 20),
                  selectedIcon: Icon(Icons.donut_large, size: 22),
                  label: 'Graphic',
                ),
                NavigationDestination(
                  icon: Icon(Icons.stacked_bar_chart, size: 20),
                  selectedIcon: Icon(Icons.stacked_bar_chart, size: 22),
                  label: 'Community',
                ),
              ],
            )
          : null,
      body: FutureBuilder<ChartData>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando productos de DummyJSON...', style: TextStyle(fontSize: 13)),
                ],
              ),
            );
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text(
                      'No se pudo consultar la API:\n${snap.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      onPressed: () => setState(() => _future = _api.fetch()),
                    ),
                  ],
                ),
              ),
            );
          }
          final data = snap.data!;
          return TabBarView(
            controller: _tabController,
            children: [
              FlChartPage(data: data),
              SyncfusionPage(data: data),
              GraphicPage(data: data),
              CommunityChartsPage(data: data),
            ],
          );
        },
      ),
    );
  }
}
