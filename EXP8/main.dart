import 'package:flutter/material.dart';

void main() => runApp(QuickNotesApp());

class QuickNotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickNotes',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: QuickNotesHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuickNotesHome extends StatelessWidget {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Notes'),
    Tab(text: 'To-Do'),
    Tab(text: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('QuickNotes'),
          bottom: TabBar(tabs: myTabs),
        ),
        body: TabBarView(children: [NotesTab(), ToDoTab(), SettingsTab()]),
      ),
    );
  }
}

class NotesTab extends StatelessWidget {
  final List<String> notes = [
    'Study Flutter navigation',
    'Update GitHub README',
    'Prepare Arduino write-up',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.note, color: Colors.teal),
            title: Text(notes[index]),
          ),
        );
      },
    );
  }
}

class ToDoTab extends StatelessWidget {
  final List<Map<String, dynamic>> tasks = [
    {'task': 'Complete CRUD experiment', 'done': false},
    {'task': 'Upload counter app to GitHub', 'done': true},
    {'task': 'Design Figma layout', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: tasks.map((item) {
        return CheckboxListTile(
          title: Text(item['task']),
          value: item['done'],
          onChanged: (val) {},
          activeColor: Colors.teal,
        );
      }).toList(),
    );
  }
}

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        ListTile(
          leading: Icon(Icons.palette),
          title: Text('Theme'),
          subtitle: Text('Teal'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('About'),
          subtitle: Text('QuickNotes v1.0\nMade by Vaibhavi'),
        ),
      ],
    );
  }
}
