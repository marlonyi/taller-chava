import 'dart:ui';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() => runApp(const GraficosApp());

class GraficosApp extends StatelessWidget {
  const GraficosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '260 Gráficos Flutter',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.trackpad,
        },
      ),
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
