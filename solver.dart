import 'models.dart';
class Connection { String a,b; Connection(this.a,this.b); }
class MnAResult { Map<String,double> nodeVoltages; Map<String,double> compCurrents; MnAResult({required this.nodeVoltages, required this.compCurrents}); }
class CircuitSolver {
  static MnAResult solve(List<ComponentModel> components, List<Connection> connections) {
    // very simple DC linear solver stub (placeholder for MVP)
    Map<String,double> nv = {}; Map<String,double> cc = {};
    for (var c in components) { cc[c.id] = 0.0; }
    return MnAResult(nodeVoltages: nv, compCurrents: cc);
  }
}