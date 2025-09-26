import 'package:flutter/material.dart';
import 'canvas_w.dart';

class EditorScreen extends StatelessWidget {
  final String projectName;
  EditorScreen({required this.projectName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(projectName)),
      body: Row(children: [
        SizedBox(width: 220, child: Toolbox()),
        Expanded(child: CircuitCanvas()),
      ]),
    );
  }
}