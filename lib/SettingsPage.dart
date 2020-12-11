import 'package:flutter/material.dart';

import 'SideDrawer.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  // #enddocregion RWS-var
  List<bool> selection1 = List.generate(3, (_) => false);

  // #docregion _buildSuggestions
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: SideDrawer(),
      body: Center(
          child: ListView(
        children: <Widget>[
          ToggleButtons(
            children: <Widget>[
              Icon(Icons.ac_unit),
              Icon(Icons.call),
              Icon(Icons.cake),
            ],
            onPressed: (int index) {
              setState(() {
                selection1[index] = !selection1[index];
              });
            },
            isSelected: selection1,
          ),
        ],
      )),
    );
  }
}
