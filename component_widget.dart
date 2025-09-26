import 'package:flutter/material.dart';
import 'models.dart';
class ComponentWidget extends StatefulWidget {
  final ComponentModel model; final Function(String) onPortTap; final Function(String, Offset) onPos; final Function(ComponentModel) onEdit;
  ComponentWidget({required this.model, required this.onPortTap, required this.onPos, required this.onEdit});
  @override State<ComponentWidget> createState()=> _ComponentWidgetState();
}
class _ComponentWidgetState extends State<ComponentWidget> {
  Offset offset = Offset.zero;
  @override void initState(){ super.initState(); offset = widget.model.position; }
  @override void didUpdateWidget(covariant ComponentWidget oldWidget){ super.didUpdateWidget(oldWidget); offset = widget.model.position; }
  @override Widget build(BuildContext context) {
    return Positioned(left: offset.dx-50, top: offset.dy-20, child: GestureDetector(
      onPanUpdate: (d){ setState(()=> offset = offset + d.delta); widget.onPos(widget.model.id, offset); },
      onLongPress: ()=> widget.onEdit(widget.model),
      child: SizedBox(width:100,height:40,child: Stack(children: [
        Container(decoration: BoxDecoration(color: Colors.white, border: Border.all()), child: Center(child: Text(widget.model.label))),
        for (var p in widget.model.ports) Positioned(left:50 + p.offset.dx-6, top:20 + p.offset.dy-6, child: GestureDetector(onTap: ()=> widget.onPortTap(p.id), child: Container(width:12,height:12,decoration: BoxDecoration(color: Colors.white,border: Border.all(),shape: BoxShape.circle)))),
      ])),
    ));
  }
}