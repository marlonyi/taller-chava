import 'package:flutter/material.dart';

/// Tarjeta adaptativa que envuelve cada gráfico con número, título, nivel y observación.
class ChartCard extends StatelessWidget {
  final int number;
  final String title;
  final bool advanced;
  final String observation;
  final Widget child;
  final double height;

  const ChartCard({
    super.key,
    required this.number,
    required this.title,
    required this.advanced,
    required this.observation,
    required this.child,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 640;

    final effectiveHeight = isMobile ? (height > 250 ? 245.0 : height) : height;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 16,
        vertical: isMobile ? 6 : 8,
      ),
      elevation: isMobile ? 1 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera compacta y responsiva
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 13.5 : 15.5,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: advanced ? Colors.deepPurple.shade50 : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: advanced
                          ? Colors.deepPurple.shade200
                          : Colors.teal.shade200,
                    ),
                  ),
                  child: Text(
                    advanced ? 'Avanzado' : 'Básico',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: advanced
                          ? Colors.deepPurple.shade700
                          : Colors.teal.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Contenedor del gráfico con alto adaptativo
            SizedBox(
              height: effectiveHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: child,
              ),
            ),
            const SizedBox(height: 8),
            // Observación adaptada
            Text(
              'Observación: $observation',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                fontSize: isMobile ? 11 : 12,
                color: Colors.grey.shade700,
              ),
              maxLines: isMobile ? 2 : 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
