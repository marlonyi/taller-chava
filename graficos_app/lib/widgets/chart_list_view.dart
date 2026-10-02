import 'package:flutter/material.dart';
import '../models/chart_item.dart';

enum ChartFilter { all, basic, advanced }

class ChartListView extends StatefulWidget {
  final String libraryName;
  final List<ChartItem> items;

  const ChartListView({
    super.key,
    required this.libraryName,
    required this.items,
  });

  @override
  State<ChartListView> createState() => _ChartListViewState();
}

class _ChartListViewState extends State<ChartListView> {
  ChartFilter _filter = ChartFilter.all;
  String _query = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChartItem> get _filteredItems {
    return widget.items.where((item) {
      if (_filter == ChartFilter.basic && item.advanced) return false;
      if (_filter == ChartFilter.advanced && !item.advanced) return false;
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        final matchNum = '${item.number}'.contains(q);
        final matchTitle = item.title.toLowerCase().contains(q);
        final matchObs = item.observation.toLowerCase().contains(q);
        if (!matchNum && !matchTitle && !matchObs) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final basicCount = widget.items.where((i) => !i.advanced).length;
    final advCount = widget.items.where((i) => i.advanced).length;
    final filtered = _filteredItems;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Buscador rápido
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar en ${widget.libraryName} por #, título o métrica...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (val) => setState(() => _query = val.trim()),
              ),
              const SizedBox(height: 8),
              // Segmented / Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      selected: _filter == ChartFilter.all,
                      label: Text('Todas (${widget.items.length})'),
                      onSelected: (_) =>
                          setState(() => _filter = ChartFilter.all),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _filter == ChartFilter.basic,
                      label: Text('Básicas ($basicCount)'),
                      avatar: const Icon(Icons.auto_graph, size: 16),
                      onSelected: (_) =>
                          setState(() => _filter = ChartFilter.basic),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      selected: _filter == ChartFilter.advanced,
                      label: Text('Avanzadas ($advCount)'),
                      avatar: const Icon(Icons.insights, size: 16),
                      onSelected: (_) =>
                          setState(() => _filter = ChartFilter.advanced),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Barra informativa de conteo
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: theme.colorScheme.surfaceContainerLowest,
          child: Text(
            'Mostrando ${filtered.length} de ${widget.items.length} gráficos en ${widget.libraryName}',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
          ),
        ),
        // Lista optimizada
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'No se encontraron gráficos con el filtro actual.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  key: ValueKey('${widget.libraryName}_${_filter.name}_$_query'),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      filtered[index].buildCard(context),
                ),
        ),
      ],
    );
  }
}
