import 'package:flutter/material.dart';
import 'canvas.dart';

void main() { runApp(CircuitApp()); }

class CircuitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ورك بنش - المحاكي',
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text('ورك بنش - المحاكي')),
          body: Row(children: [ SizedBox(width:200, child: Toolbox()), Expanded(child: CircuitCanvas()) ]),
        ),
      ),
    );
  }
}