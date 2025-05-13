import 'package:flutter/material.dart';
import 'pages/kalkulator_page.dart';

void main() {
  runApp(const KalkulatorApp());
}

class KalkulatorApp extends StatelessWidget {
  const KalkulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: false),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark, // otomatis mengikuti mode sistem smartphone
      home: KalkulatorPage(),
    );
  }
}
