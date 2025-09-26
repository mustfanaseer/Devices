import 'package:flutter/material.dart';
import 'home.dart';

void main() { runApp(CircuitApp()); }

class CircuitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CircuitSim - محاكي الدوائر',
      debugShowCheckedModeBanner: false,
      home: Directionality(textDirection: TextDirection.rtl, child: HomeScreen()),
    );
  }
}