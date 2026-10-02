import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/palette.dart';

FlTitlesData flTitles({
  required String Function(double) bottom,
  bool rotate = false,
  double leftReserved = 40,
  String Function(double)? left,
}) {
  return FlTitlesData(
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: leftReserved,
        getTitlesWidget: (v, meta) {
          final text = left != null ? left(v) : (v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}k' : v.toInt().toString());
          return Text(text, style: const TextStyle(fontSize: 10));
        },
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: rotate ? 46 : 24,
        getTitlesWidget: (v, meta) => Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Transform.rotate(
            angle: rotate ? -0.5 : 0,
            child: Text(bottom(v), style: const TextStyle(fontSize: 10)),
          ),
        ),
      ),
    ),
  );
}

Widget flLegend(List<String> names, [List<Color>? colors]) {
  final cols = colors ?? palette;
  return Wrap(
    spacing: 8,
    runSpacing: 4,
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      for (var i = 0; i < names.length; i++)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, size: 8, color: cols[i % cols.length]),
            const SizedBox(width: 4),
            Text(names[i], style: const TextStyle(fontSize: 10.5)),
          ],
        ),
    ],
  );
}
