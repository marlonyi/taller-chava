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
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;

    final basicCount = widget.items.where((i) => !i.advanced).length;
    final advCount = widget.items.where((i) => i.advanced).length;
    final filtered = _filteredItems;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 10 : 16,
            isMobile ? 8 : 12,
            isMobile ? 10 : 16,
            isMobile ? 6 : 8,
          ),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Buscador rápido adaptado
              TextField(
                controller: _searchController,
                style: TextStyle(fontSize: isMobile ? 13 : 14),
                decoration: InputDecoration(
                  hintText: isMobile
                      ? 'Buscar en ${widget.libraryName} (#, título)...'
                      : 'Buscar en ${widget.libraryName} por #, título o métrica...',
                  hintStyle: TextStyle(fontSize: isMobile ? 12 : 13),
                  prefixIcon: Icon(Icons.search, size: isMobile ? 18 : 20),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: isMobile ? 16 : 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: isMobile ? 8 : 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (val) => setState(() => _query = val.trim()),
              ),
              SizedBox(height: isMobile ? 6 : 8),
              // Segmented / Filter Chips con densidad compacta
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    FilterChip(
                      selected: _filter == ChartFilter.all,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        'Todas (${widget.items.length})',
                        style: TextStyle(fontSize: isMobile ? 11 : 12),
                      ),
                      onSelected: (_) =>
                          setState(() => _filter = ChartFilter.all),
                    ),
                    const SizedBox(width: 6),
                    FilterChip(
                      selected: _filter == ChartFilter.basic,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        'Básicas ($basicCount)',
                        style: TextStyle(fontSize: isMobile ? 11 : 12),
                      ),
                      avatar: Icon(Icons.auto_graph, size: isMobile ? 14 : 16),
                      onSelected: (_) =>
                          setState(() => _filter = ChartFilter.basic),
                    ),
                    const SizedBox(width: 6),
                    FilterChip(
                      selected: _filter == ChartFilter.advanced,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        'Avanzadas ($advCount)',
                        style: TextStyle(fontSize: isMobile ? 11 : 12),
                      ),
                      avatar: Icon(Icons.insights, size: isMobile ? 14 : 16),
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
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 4 : 6,
          ),
          color: theme.colorScheme.surfaceContainerLowest,
          child: Text(
            'Mostrando ${filtered.length} de ${widget.items.length} gráficos en ${widget.libraryName}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: isMobile ? 11 : 12,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        // Lista optimizada con rebote fluido
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 44, color: Colors.grey.shade400),
                        const SizedBox(height: 10),
                        Text(
                          'No se encontraron gráficos con el filtro actual.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  key: ValueKey('${widget.libraryName}_${_filter.name}_$_query'),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      filtered[index].buildCard(context),
                ),
        ),
      ],
    );
  }
}
