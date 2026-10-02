import 'package:flutter/material.dart';

/// Tarjeta que envuelve cada gráfico con número, título, nivel y observación.
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 12,
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
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    advanced ? 'Avanzado' : 'Básico',
                    style: const TextStyle(fontSize: 11),
                  ),
                  backgroundColor: advanced
                      ? Colors.deepPurple.shade100
                      : Colors.teal.shade100,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: height,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: child,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Observación: $observation',
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
