import 'package:flutter/material.dart';
import 'models.dart';
class ComponentWidget extends StatelessWidget {
  final ComponentModel model; final Function(String) onPortTap; final Function(String, Offset) onPos; final Function(ComponentModel) onEdit;
  ComponentWidget({required this.model, required this.onPortTap, required this.onPos, required this.onEdit});
  @override
  Widget build(BuildContext context) {
    return Positioned(left: model.position.dx-50, top: model.position.dy-20, child:
      GestureDetector(
        onPanUpdate: (d){ onPos(model.id, model.position + d.delta); },
        onLongPress: (){ onEdit(model); },
        child: Container(width:100,height:40,decoration: BoxDecoration(color:Colors.white,border:Border.all()),child: Center(child: Text(model.label))),
      )
    );
  }
}