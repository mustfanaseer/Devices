import 'models.dart';
class Connection { String a,b; Connection(this.a,this.b); }
class CircuitSolver { static Map<String,double> solve(List<ComponentModel> comps, List<Connection> conns) { return {'ok':0.0}; } }