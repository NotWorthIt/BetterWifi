import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'SideDrawer.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  // #enddocregion RWS-var
  var value1 = true;
  var value2 = false;
  var value3 = false;

  // #docregion _buildSuggestions
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: SideDrawer(),
      body: Center(
          child: SettingsList(
            sections: [
              SettingsSection(
                title: 'General',
                tiles: [
                  SettingsTile(
                    title: 'Language',
                    subtitle: 'English',
                    leading: Icon(Icons.language),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: 'Delete scan history',
                    subtitle: 'Delete',
                    leading: Icon(Icons.delete),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile(
                    title: 'Keep screen awake',
                    subtitle: 'Awake',
                    leading: Icon(Icons.wb_sunny),
                    onPressed: (BuildContext context) {},
                  ),
                  SettingsTile.switchTile(
                    title: 'Scan wifi',
                    leading: Icon(Icons.wifi),
                    switchValue: value1,
                    onToggle: (bool value) {
                      value1 = value;
                    },
                  ),
                  SettingsTile.switchTile(
                    title: 'Scan mobile connection',
                    leading: Icon(Icons.data_usage),
                    switchValue: value2,
                    onToggle: (bool value2) {},
                  ),
                  SettingsTile.switchTile(
                    title: 'Dark mode',
                    leading: Icon(Icons.adjust),
                    switchValue: value3,
                    onToggle: (bool value) {},
                  ),
                ],
              ),
            ],
          )),
    );
  }

  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
