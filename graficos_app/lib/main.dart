import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() => runApp(const GraficosApp());

class GraficosApp extends StatelessWidget {
  const GraficosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taller de Gráficos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomePage(),
    );
  }
}
