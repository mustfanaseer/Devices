import 'package:flutter/material.dart';
import 'editor.dart';

class HomeScreen extends StatefulWidget {
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> projects = ['مشروع 1'];

  void _openProject(String name) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => EditorScreen(projectName: name)));
  }

  void _newProject() {
    String name = 'مشروع ${projects.length+1}';
    setState(()=> projects.add(name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('المشاريع')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (ctx, i) {
                return ListTile(
                  title: Text(projects[i]),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: Icon(Icons.open_in_new), onPressed: ()=>_openProject(projects[i])),
                    IconButton(icon: Icon(Icons.delete), onPressed: ()=> setState(()=>projects.removeAt(i))),
                  ]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(onPressed: _newProject, icon: Icon(Icons.add), label: Text('مشروع جديد')),
          )
        ],
      ),
    );
  }
}