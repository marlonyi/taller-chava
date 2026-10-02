import 'package:flutter/material.dart';
import '../widgets/chart_card.dart';

/// Representa la definición de un gráfico con evaluación perezosa (lazy builder).
class ChartItem {
  final int number;
  final String title;
  final bool advanced;
  final String observation;
  final double height;
  final Widget Function(BuildContext context) builder;

  const ChartItem({
    required this.number,
    required this.title,
    required this.advanced,
    required this.observation,
    this.height = 280,
    required this.builder,
  });

  Widget buildCard(BuildContext context) => ChartCard(
        number: number,
        title: title,
        advanced: advanced,
        observation: observation,
        height: height,
        child: builder(context),
      );
}
