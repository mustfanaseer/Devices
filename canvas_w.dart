import 'package:flutter/material.dart';
import 'models.dart';
import 'component_widget.dart';
import 'solver.dart';
import 'package:uuid/uuid.dart';

class Toolbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(children: [
        Padding(padding: EdgeInsets.all(8), child: Text('المكونات', style: TextStyle(fontWeight: FontWeight.bold))),
        Expanded(child: ListView(children: [
          ListTile(title: Text('مقاومة'), onTap: ()=> CanvasAddNotification(ComponentType.resistor).dispatch(context)),
          ListTile(title: Text('مصدر جهد (DC)'), onTap: ()=> CanvasAddNotification(ComponentType.voltageSource).dispatch(context)),
          ListTile(title: Text('أرضي'), onTap: ()=> CanvasAddNotification(ComponentType.ground).dispatch(context)),
          ListTile(title: Text('فولتميتر'), onTap: ()=> CanvasAddNotification(ComponentType.voltmeter).dispatch(context)),
        ])),
        Padding(padding: EdgeInsets.all(8), child: Text('الإجراءات')),
        ElevatedButton.icon(onPressed: () { CanvasRunNotification().dispatch(context); }, icon: Icon(Icons.play_arrow), label: Text('تشغيل')),
      ]),
    );
  }
}

class CanvasAddNotification extends Notification { final ComponentType type; CanvasAddNotification(this.type); }
class CanvasRunNotification extends Notification { CanvasRunNotification(); }

class CircuitCanvas extends StatefulWidget {
  @override State<CircuitCanvas> createState() => _CircuitCanvasState();
}

class _CircuitCanvasState extends State<CircuitCanvas> {
  List<ComponentModel> components = [];
  List<Wire> wires = [];
  String? activePortStart;
  Offset? previewPos;
  var uuid = Uuid();

  void addComponent(ComponentType type) {
    String id = uuid.v4();
    List<Port> ports = [Port(id: id+'-p0', offset: Offset(-40,0)), Port(id: id+'-p1', offset: Offset(40,0))];
    var comp = ComponentModel(id: id, type: type, position: Offset(300 + components.length*10, 200 + components.length*6), properties: _defaultProps(type), ports: ports);
    setState(()=> components.add(comp));
  }

  Map<String,dynamic> _defaultProps(ComponentType t) {
    switch(t) {
      case ComponentType.resistor: return {'resistance':1000.0};
      case ComponentType.voltageSource: return {'voltage':5.0};
      default: return {};
    }
  }

  void onPortTap(String portId) {
    if (activePortStart == null) { setState(()=> activePortStart = portId); } else {
      if (activePortStart != portId) { wires.add(Wire(id: uuid.v4(), fromPort: activePortStart!, toPort: portId)); }
      setState(()=> activePortStart = null);
    }
  }

  void onPosChange(String compId, Offset newPos) { setState(()=> components.firstWhere((c)=>c.id==compId).position = newPos); }

  void onEdit(ComponentModel m) async { await showDialog(context: context, builder: (ctx) => PropertyEditor(comp: m)); setState((){}); }

  void runSimulation() {
    var conns = wires.map((w)=> Connection(w.fromPort, w.toPort)).toList();
    try {
      var res = CircuitSolver.solve(components, conns);
      showDialog(context: context, builder: (ctx) {
        return AlertDialog(title: Text('نتائج المحاكاة'), content: SingleChildScrollView(child: Column(children: [
          Text('Node Voltages:'),
          for (var e in res.nodeVoltages.entries) Text('${e.key.substring(0,8)} : ${e.value.toStringAsFixed(4)} V'),
          SizedBox(height:8),
          Text('Component Currents:'),
          for (var e in res.compCurrents.entries) Text('${e.key.substring(0,8)} : ${e.value.toStringAsFixed(6)} A'),
        ])), actions: [TextButton(onPressed: ()=>Navigator.pop(ctx), child: Text('حسناً'))],);
      });
    } catch (ex) {
      showDialog(context: context, builder: (ctx) { return AlertDialog(title: Text('خطأ'), content: Text(ex.toString()), actions:[TextButton(onPressed: ()=>Navigator.pop(ctx), child: Text('OK'))]); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<CanvasAddNotification>(
      onNotification: (n) { addComponent(n.type); return true; },
      child: NotificationListener<CanvasRunNotification>(
        onNotification: (n) { runSimulation(); return true; },
        child: Stack(children: [
          InteractiveViewer(minScale: 0.5, maxScale: 2.5, boundaryMargin: EdgeInsets.all(2000), child: Container(color: Colors.white, width: 2000, height: 2000)),
          CustomPaint(painter: WiresPainter(components: components, wires: wires, activeStart: activePortStart)),
          ...components.map((c) => ComponentWidget(model: c, onPortTap: onPortTap, onPos: onPosChange, onEdit: onEdit)).toList(),
        ]),
      ),
    );
  }
}

class Wire { String id; String fromPort; String toPort; Color color; Wire({required this.id, required this.fromPort, required this.toPort, this.color = Colors.red}); }

class WiresPainter extends CustomPainter {
  final List<ComponentModel> components; final List<Wire> wires; final String? activeStart;
  WiresPainter({required this.components, required this.wires, required this.activeStart});
  Offset? _posOf(String pid) {
    for (var c in components) {
      for (var p in c.ports) if (p.id==pid) return c.position + p.offset;
    }
    return null;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style=PaintingStyle.stroke..strokeWidth=3.0;
    for (var w in wires) {
      var a = _posOf(w.fromPort); var b = _posOf(w.toPort);
      if (a==null || b==null) continue;
      paint.color = w.color;
      var path = Path(); path.moveTo(a.dx, a.dy);
      var mid = Offset((a.dx+b.dx)/2, (a.dy+b.dy)/2);
      path.quadraticBezierTo(mid.dx, mid.dy - 40, b.dx, b.dy);
      canvas.drawPath(path, paint);
    }
    if (activeStart!=null) {
      var p = _posOf(activeStart!);
      if (p!=null) canvas.drawCircle(p,6, Paint()..color=Colors.orange);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PropertyEditor extends StatefulWidget { final ComponentModel comp; PropertyEditor({required this.comp}); @override State<PropertyEditor> createState()=> _PropertyEditorState(); }
class _PropertyEditorState extends State<PropertyEditor> {
  late Map<String, TextEditingController> ctrls;
  @override void initState(){ super.initState(); ctrls={}; widget.comp.properties.forEach((k,v)=> ctrls[k]=TextEditingController(text: v.toString())); }
  @override void dispose(){ ctrls.forEach((k,c)=>c.dispose()); super.dispose(); }
  @override Widget build(BuildContext context) {
    return AlertDialog(title: Text('خصائص ${widget.comp.label}'), content: SingleChildScrollView(child: Column(children: [
      for (var e in ctrls.entries) Padding(padding: EdgeInsets.symmetric(vertical:6), child: TextField(controller: e.value, keyboardType: TextInputType.numberWithOptions(decimal:true), decoration: InputDecoration(labelText: e.key))),
      SizedBox(height:8), ElevatedButton(onPressed: (){ ctrls.forEach((k,c){ widget.comp.properties[k]= double.tryParse(c.text) ?? 0.0; }); Navigator.pop(context); }, child: Text('حفظ'))
    ])), );
  }
}