import 'package:flutter/material.dart';

const palette = [
  Color(0xFF3B82F6),
  Color(0xFFF97316),
  Color(0xFF10B981),
  Color(0xFFE11D48),
  Color(0xFF8B5CF6),
  Color(0xFFEAB308),
  Color(0xFF06B6D4),
  Color(0xFF64748B),
];

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 14, child: Text('$number')),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                Chip(
                  label: Text(advanced ? 'Avanzado' : 'Básico'),
                  backgroundColor:
                      advanced ? Colors.deepPurple.shade100 : Colors.teal.shade100,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(height: height, child: child),
            const SizedBox(height: 12),
            Text('Observación: $observation',
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}
