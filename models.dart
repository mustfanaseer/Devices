import 'dart:ui';
enum ComponentType { resistor, voltageSource, ground, voltmeter }
class Port { final String id; final Offset offset; Port({required this.id, required this.offset}); }
class ComponentModel { String id; ComponentType type; Offset position; Map<String,dynamic> properties; List<Port> ports;
  ComponentModel({required this.id, required this.type, required this.position, Map<String,dynamic>? properties, List<Port>? ports})
  : properties = properties ?? {}, ports = ports ?? [];
  String get label { switch(type) { case ComponentType.resistor: return 'مقاومة'; case ComponentType.voltageSource: return 'مصدر جهد'; case ComponentType.ground: return 'أرضي'; case ComponentType.voltmeter: return 'فولتميتر'; default: return 'عنصر'; } }
}