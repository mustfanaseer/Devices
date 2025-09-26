import 'package:flutter/material.dart';
import 'models.dart';
import 'component_widget.dart';
import 'package:uuid/uuid.dart';

class Toolbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.grey[100], child: ListView(children: [
      ListTile(title: Text('مقاومة'), onTap: ()=>CanvasAdd(ComponentType.resistor).dispatch(context)),
      ListTile(title: Text('مصدر جهد'), onTap: ()=>CanvasAdd(ComponentType.voltageSource).dispatch(context)),
      ListTile(title: Text('أرضي'), onTap: ()=>CanvasAdd(ComponentType.ground).dispatch(context)),
      ListTile(title: Text('فولتميتر'), onTap: ()=>CanvasAdd(ComponentType.voltmeter).dispatch(context)),
    ]));
  }
}

class CanvasAdd extends Notification { final ComponentType type; CanvasAdd(this.type); }

class CircuitCanvas extends StatefulWidget { @override State<CircuitCanvas> createState() => _CircuitCanvasState(); }

class _CircuitCanvasState extends State<CircuitCanvas> {
  List<ComponentModel> comps = []; var uuid = Uuid();
  @override
  void initState(){ super.initState(); }
  void addComponent(ComponentType type){
    String id = uuid.v4();
    comps.add(ComponentModel(id: id, type: type, position: Offset(200,200), properties: {'resistance':1000.0, 'voltage':5.0}, ports: [/*placeholder*/]));
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    return NotificationListener<CanvasAdd>(child: Stack(children: [
      Container(color: Colors.white),
      ...comps.map((c)=>ComponentWidget(model:c, onPortTap: (_){}, onPos: (id,pos){ setState(()=>c.position=pos); }, onEdit:(m){})).toList(),
    ]), onNotification: (n){ addComponent(n.type); return true; },);
  }
}